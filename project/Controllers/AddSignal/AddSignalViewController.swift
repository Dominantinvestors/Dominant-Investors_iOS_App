import UIKit

class AddSignalViewController: KeyboardObservableViewController, UITextFieldDelegate {
    
    var company: Company!
    
    private var buyDataSource: EditableDataSource!
    private var targetDataSource: EditableDataSource!
    private var lossDataSource: EditableDataSource!

    private var dataSource: TableViewDataSourceShim? = nil {
        didSet {
            tableView.dataSource = dataSource
            tableView.delegate = dataSource
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("CREATE SIGNAL", comment: "")
        
        tableView.register(cell: BuyTableViewCell.self)
        tableView.register(cell: CreateSignalTableViewCell.self)
        tableView.register(cell: AddSignalHeaderTableViewCell.self)

        let header = AddSignalHeaderDataSource(data: [company])
        buyDataSource = EditableDataSource(title: NSLocalizedString("BUY POINT", comment: ""),
                                           rightText: Values.Currency)
        targetDataSource = EditableDataSource(title: NSLocalizedString("TARGET PRICE", comment: ""),
                                              rightText: Values.Currency)
        lossDataSource = EditableDataSource(title: NSLocalizedString("STOPP LOSS", comment: ""),
                                            rightText: Values.Currency)
        
        let composed = ComposedDataSource([header, buyDataSource, targetDataSource, lossDataSource, createSignalSection()])
        self.dataSource = TableViewDataSourceShim(composed)
        self.tableView.reloadData()
    }
    
    fileprivate func createSignalSection() -> TableViewDataSource{
        var createSignal = CreateSignalDataSource(title: NSLocalizedString("CREATE SIGNAL", comment: ""))
        createSignal.selectors[.select] = {_, _, _ in
            self.createSignal()
        }
        return createSignal
    }
    
    private func createSignal() {
        guard buyDataSource.text.count > 0, targetDataSource.text.count > 0, lossDataSource.text.count > 0 else {
            return
        }
        showActivityIndicator()
        SignalsDataProvider.default().create(for: company, buyDataSource.text, targetDataSource.text, lossDataSource.text)
        { success, error in
            self.dismissActivityIndicator()
            if success {
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                self.showAlertWith(message: error)
            }
        }
    }
}

struct AddSignalHeaderDataSource:
    TableViewDataSource,
    DataContainable,
    CellContainable,
    CellConfigurator
{
    var data: [Company]
    
    func configurateCell(_ cell: AddSignalHeaderTableViewCell, item: Company, at indexPath: IndexPath) {
        cell.companyTitle.text = item.name
        cell.companyPrice.attributedText = item.rate.toMoneyStyle()
    }
}
