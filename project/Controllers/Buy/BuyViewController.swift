import UIKit

class BuyViewController: KeyboardObservableViewController {

    var company: CompanyModel!
    
    private var costDataSource: NotEditableDataSource!
    private var buyDataSource: EditableDataSource!
    
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

        let footer = BuySectionDataSource(subtitle: NSLocalizedString("Tou are simulating a trade with Dominant investors. No money will be transacted at this time.", comment: ""))
        footer.selectors[.select] = { _, _ in
            self.onSubmit()
        }
        
        buyDataSource = EditableDataSource(title: NSLocalizedString("SHARES OF FB", comment: ""), delegate: self)
        let priceDataSource = NotEditableDataSource(title: NSLocalizedString("MKT PRICE", comment: ""), text: company.buyPoint)
        costDataSource = NotEditableDataSource(title: NSLocalizedString("EST COST", comment: ""), text: nil, footer: footer)

        let composed = ComposedDataSource([buyDataSource, priceDataSource, costDataSource])
        self.dataSource = TableViewDataSourceShim(composed)
        self.tableView.reloadData()
    }
    
    private func cost(_ left: String?, _ right: String?) -> String {
        let cost = (left.flatMap{ Double($0) } ?? 0.0) * (right.flatMap{ Double($0) } ?? 0.0)
        return String(format:"%.2f", cost)
    }
    
    private func onSubmit() {
        if let amount = buyDataSource.cell?.textField.text, amount.count > 0 {
            SignalsDataProvider.default().buy(amount, company) { succes, error in
                if !succes {
                    self.showAlertWith(title: NSLocalizedString("Error!!!", comment: ""),
                                       message: error ?? "")
                }
            }
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
        let amount = currentString.replacingCharacters(in: range, with: string)
        
        self.costDataSource.cell?.textField.text = cost(amount, company.buyPoint)
        
        return true
    }
}

class BuySectionDataSource:
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

class EditableDataSource:
    TableViewDataSource,
    DataContainable,
    CellContainable,
    CellConfigurator
{
    var data: [String]
    var text: String { return cell?.textField.text ?? ""}
    let delegate: UITextFieldDelegate?
    
    weak var cell: BuyTableViewCell?
    
    let rightText: String
    
    init(title: String, delegate: UITextFieldDelegate? = nil, rightText: String = "") {
        self.data = [title]
        self.delegate = delegate
        self.rightText = rightText
    }
    
    func configurateCell(_ cell: BuyTableViewCell, item: String, at indexPath: IndexPath) {
        self.cell = cell
        cell.title.text = item
        cell.textField.delegate = delegate
        cell.normalStyle()
        cell.textField.setRight(rightText)
        cell.textField.isUserInteractionEnabled = true
    }
}

class NotEditableDataSource:
    TableViewDataSource,
    DataContainable,
    CellContainable,
    CellConfigurator,
    FooterContainable
{
    weak var cell: BuyTableViewCell?
    
    var data: [(String, String?)]
    
    var footer: BuySectionDataSource?
    
    init(title: String, text: String?, footer: BuySectionDataSource? = nil) {
        data = [(title, text)]
        self.footer = footer
    }

    func configurateCell(_ cell: BuyTableViewCell, item: (String, String?), at indexPath: IndexPath) {
        self.cell = cell
        cell.title.text = item.0
        cell.textField.text = item.1 ?? "0.00"
        cell.textField.setRight(Values.Currency)
        cell.normalStyle()
        cell.textField.isUserInteractionEnabled = false
    }
}
