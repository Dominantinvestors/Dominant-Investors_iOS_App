import UIKit

class BuyViewController: KeyboardObservableViewController {
    
    var company: Company!
    
    var buyDataSource: EditableDataSource!
    var priceDataSource: EditableDataSource!
    private var costDataSource: EditableDataSource!
    
    private var dataSource: TableViewDataSourceShim? = nil {
        didSet {
            tableView.dataSource = dataSource
            tableView.delegate = dataSource
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("MARKET BUY", comment: "")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        tableView.register(cell: BuyTableViewCell.self)
        tableView.register(BuySectionView.self)
        
        let footer = BuySectionConfigurator(subtitle: NSLocalizedString("Tou are simulating a trade with Dominant investors. No money will be transacted at this time.", comment: ""))
        footer.selectors[.select] = { _, _ in
            self.onSubmit()
        }
        
        let priceTitle = company.isCrypto() ? NSLocalizedString("AMOUNT OF COIN", comment: "") :  NSLocalizedString("AMOUNT OF SHARES", comment: "")
        
        buyDataSource = EditableDataSource(title: priceTitle,
                                           delegate: self)
        
        priceDataSource = EditableDataSource(title: NSLocalizedString("MKT PRICE", comment: ""),
                                             rightText: Values.Currency,
                                             editable: false)
        
        costDataSource = EditableDataSource(title: NSLocalizedString("EST COST", comment: ""),
                                            rightText: Values.Currency,
                                            editable: false,
                                            footer: footer)
        
        let composed = ComposedDataSource([buyDataSource, priceDataSource, costDataSource])
        dataSource = TableViewDataSourceShim(composed)
        tableView.reloadData()
        
        updateRate()
    }
    
    func onSubmit() {
        showActivityIndicator()
        PortfolioDataProvider.default().buy(priceDataSource.text, buyDataSource.text, company) { success, error in
            self.dismissActivityIndicator()
            if success {
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                self.showAlertWith(message: error)
            }
        }
    }
    
    private func updateRate() {
        self.showActivityIndicator()
        CompanyDataProvider.default().rate(company) { rate, error in
            self.dismissActivityIndicator()
            if let rate = rate {
                self.priceDataSource.text = rate.rate
                self.costDataSource.text = self.cost(self.buyDataSource.text, rate.rate)
                self.tableView.reloadData()
            } else {
                self.showAlertWith(message: error)
            }
        }
    }
    
    private func cost(_ left: String?, _ right: String?) -> String {
        let cost = (left.flatMap{ Double($0) } ?? 0.0) * (right.flatMap{ Double($0) } ?? 0.0)
        if company.isCrypto() {
            return String(format:"%.6f", cost)
        } else {
            return String(format:"%.2f", cost)
        }
    }
}

extension BuyViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField)  {
        buyDataSource.cell?.editStyle()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        buyDataSource.cell?.normalStyle()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        var amount = currentString.replacingCharacters(in: range, with: string)
        amount = amount.replacingOccurrences(of: ",", with: ".")
        self.costDataSource.text = cost(amount, self.priceDataSource.text)
        return true
    }
}

class BuySectionConfigurator:
    SectionConfigurator,
    SectionSelectable
{
    var subtitle: String
    var selectors: [DataSource.Action: (BuySectionView, Int) -> ()] = [:]
    
    init(subtitle: String) {
        self.subtitle = subtitle
    }
    
    func section() -> HeaderFooterView<BuySectionView> {
        return .view { section, index in
            section.subtitle.text = self.subtitle
            section.submit.actionHandle(.touchUpInside, ForAction: {
                self.selectors[.select]? (section, index)
            })
        }
    }
}

class EditableDataSource: NSObject,
    TableViewDataSource,
    DataContainable,
    CellContainable,
    CellConfigurator,
    FooterContainable
{
    weak var cell: BuyTableViewCell?
    var footer: BuySectionConfigurator?

    var data: [String]
    var text: String {
        set {
            editebleText = newValue
            cell?.textField.text = newValue
        }
        get {
            return cell?.textField.text ?? "0.0"
        }
    }
    
    private var editebleText: String?
    private let delegate: UITextFieldDelegate?
    private let rightText: String
    private let editable: Bool

    init(title: String,
         text: String = "",
         rightText: String = "",
         delegate: UITextFieldDelegate? = nil,
         editable: Bool = true,
         footer: BuySectionConfigurator? = nil)
    {
        self.data = [title]
        self.delegate = delegate
        self.rightText = rightText
        self.footer = footer
        self.editable = editable
    }
    
    func configurateCell(_ cell: BuyTableViewCell, item: String, at indexPath: IndexPath) {
        self.cell = cell
        cell.title.text = item
        cell.textField.text = editebleText
        cell.textField.delegate = delegate != nil ? delegate : self
        cell.normalStyle()
        cell.textField.setRight(rightText)
        cell.textField.isUserInteractionEnabled = editable
    }
}

extension EditableDataSource: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField)  {
        cell?.editStyle()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        cell?.normalStyle()
    }
}
