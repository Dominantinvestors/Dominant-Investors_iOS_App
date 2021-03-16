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

        header = AddSignalHeaderDataSource(item: (company, nil))
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
        createSignal.selectors[.select] = {[unowned self] _, _, _ in
            self.createSignal()
        }
        return createSignal
    }
    
    private func updateRate() {
        self.showActivityIndicator()
        CompanyDataProvider.default().rate(company)
            .done{
                self.header.data = [(self.company, $0)]
                self.tableView.reloadData()
            }.ensure {
                self.dismissActivityIndicator()

            }.catch {
                self.showAlertWith($0)
        }
    }
    
    private func createSignal() {

        guard !buyDataSource.text.isEmpty,
              !targetDataSource.text.isEmpty,
              !lossDataSource.text.isEmpty else {
            return
        }
        
        let buyText = buyDataSource.text.replacingOccurrences(of: ",", with: ".")
        let targetText = targetDataSource.text.replacingOccurrences(of: ",", with: ".")
        let stopLossText = lossDataSource.text.replacingOccurrences(of: ",", with: ".")
         
        showActivityIndicator()
        SignalsDataProvider.default().create(for: company, buyText, targetText, stopLossText)
        {[unowned self] success, error in
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
    var data: [(Company?, Rate?)]
    
    init(item: (Company?, Rate?)) {
        self.data = [item]
    }
    
    func configurateCell(_ cell: AddSignalHeaderTableViewCell, item: (Company?, Rate?), at indexPath: IndexPath) {
        cell.companyTitle.text = item.0?.name
        cell.companyPrice.attributedText = (item.1.flatMap{ $0.rate } ?? "0.0" ).toMoneyStyle()
    }
}
