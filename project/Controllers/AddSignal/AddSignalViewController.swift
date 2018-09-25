import UIKit

class AddSignalViewController: KeyboardObservableViewController, UITextFieldDelegate {
    
    var company: CompanyModel!
    
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
        buyDataSource = EditableDataSource(title: NSLocalizedString("BUY POINT", comment: ""))
        targetDataSource = EditableDataSource(title: NSLocalizedString("TARGET PRICE", comment: ""),
                                              rightText: Values.Currency)
        lossDataSource = EditableDataSource(title: NSLocalizedString("STOPP LOSS", comment: ""),
                                            rightText: Values.Currency)
        
        let composed = ComposedDataSource([header, buyDataSource, targetDataSource, lossDataSource, createSignalSection()])
        self.dataSource = TableViewDataSourceShim(composed)
        self.tableView.reloadData()
    }
    
    fileprivate func createSignalSection() -> TableViewDataSource{
        var createSignal = CreateSignalDataSource()
        createSignal.selectors[.select] = {_, _, _ in
            self.createSignal()
        }
        return createSignal
    }
    
    private func createSignal() {
        guard buyDataSource.text.count > 0, targetDataSource.text.count > 0, lossDataSource.text.count > 0 else {
            return
        }
        SignalsDataProvider.default().createSignal(for: company, buyDataSource.text, targetDataSource.text, lossDataSource.text)
        { success, error in
            if !success {
                self.showAlertWith(title: NSLocalizedString("Error!!!", comment: ""),
                                   message: error ?? "")
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
    var data: [CompanyModel]
    
    func configurateCell(_ cell: AddSignalHeaderTableViewCell, item: CompanyModel, at indexPath: IndexPath) {
        cell.companyTitle.text = item.ticker
        cell.companyPrice.attributedText = item.buyPoint.toMoneyStyle()
    }
}
