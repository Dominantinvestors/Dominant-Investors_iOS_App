import UIKit

class AddSignalViewController: KeyboardObservableViewController, UITextFieldDelegate {
    
    var company: CompanyModel!
    
    private var buyDataSource: EditableDataSource!
    private var targetDataSource: EditableDataSource!
    private var lossDataSource: EditableDataSource!

    @IBOutlet weak var companyTitle: UILabel!
    @IBOutlet weak var companyPrice: UILabel!
    
    private var dataSource: TableViewDataSourceShim? = nil {
        didSet {
            tableView.dataSource = dataSource
            tableView.delegate = dataSource
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("CREATE SIGNAL", comment: "")
        
        companyTitle.text = company.ticker
        companyPrice.text = company.buyPoint + Values.Currency
        
        tableView.register(cell: BuyTableViewCell.self)
        tableView.register(cell: CreateSignalTableViewCell.self)

        buyDataSource = EditableDataSource(title: NSLocalizedString("BUY POINT", comment: ""))
        targetDataSource = EditableDataSource(title: NSLocalizedString("TARGET PRICE", comment: ""),
                                              rightText: Values.Currency)
        lossDataSource = EditableDataSource(title: NSLocalizedString("STOPP LOSS", comment: ""),
                                            rightText: Values.Currency)
        
        let composed = ComposedDataSource([buyDataSource, targetDataSource, lossDataSource, createSignalSection()])
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
        SignalsDataProvider.default().createSignal(for: company, buyDataSource.text, targetDataSource.text, lossDataSource.text)
        { success, error in
            if !success {
                self.showAlertWith(title: NSLocalizedString("Error!!!", comment: ""),
                                   message: error ?? "")
            }
        }
    }
}
