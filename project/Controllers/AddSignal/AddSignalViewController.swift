import UIKit

class AddSignalViewController: KeyboardObservableViewController, UITextFieldDelegate {
    
    var company: Company!
    
    private var header: AddSignalHeaderDataSource!
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

        header = AddSignalHeaderDataSource(data: [(company, nil)])
        buyDataSource = EditableDataSource(title: NSLocalizedString("BUY POINT", comment: ""),
                                           rightText: Values.Currency)
        targetDataSource = EditableDataSource(title: NSLocalizedString("TARGET PRICE", comment: ""),
                                              rightText: Values.Currency)
        lossDataSource = EditableDataSource(title: NSLocalizedString("STOPP LOSS", comment: ""),
                                            rightText: Values.Currency)
        
        let composed = ComposedDataSource([header, buyDataSource, targetDataSource, lossDataSource, createSignalSection()])
        dataSource = TableViewDataSourceShim(composed)
        tableView.reloadData()
        updateRate()
    }
    
    fileprivate func createSignalSection() -> TableViewDataSource{
        var createSignal = CreateSignalDataSource(title: NSLocalizedString("CREATE SIGNAL", comment: ""))
        createSignal.selectors[.select] = {_, _, _ in
            self.createSignal()
        }
        return createSignal
    }
    
    private func updateRate() {
        self.showActivityIndicator()
        CompanyDataProvider.default().rate(company) { rate, error in
            self.dismissActivityIndicator()
            if let rate = rate {
                self.header.data = [(self.company, rate)]
                self.tableView.reloadData()
            } else {
                self.showAlertWith(message: error)
            }
        }
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

class AddSignalHeaderDataSource:
    TableViewDataSource,
    DataContainable,
    CellContainable,
    CellConfigurator
{
    var data: [(Company, Rate?)]
    
    init(data: [(Company, Rate?)]) {
        self.data = data
    }
    
    func configurateCell(_ cell: AddSignalHeaderTableViewCell, item: (Company, Rate?), at indexPath: IndexPath) {
        cell.companyTitle.text = item.0.name
        cell.companyPrice.attributedText = (item.1.flatMap{ $0.rate } ?? "0.0" ).toMoneyStyle()
    }
}
