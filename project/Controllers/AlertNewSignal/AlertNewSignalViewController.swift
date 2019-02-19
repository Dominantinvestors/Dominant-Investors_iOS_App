import UIKit
import PromiseKit

class AlertNewSignalViewController: UIViewController {

    var investorID: String!
    var signalID: String!
    
    @IBOutlet weak var tableView: UITableView!

    private var dataSource: TableViewDataSourceShim? = nil {
        didSet {
            tableView.dataSource = dataSource
            tableView.delegate = dataSource
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstly{
                SignalsDataProvider.default().get(by: Int(signalID)!)
            }.then { signal in
                when(fulfilled: Promise.value(signal),
                     InvestorsDataProvider.default().get(by: Int(self.investorID)!),
                     CompanyDataProvider.default().rate(signal))
            }.done { signal, investor, rate in
                
                let title = AlertTitleDataSource(item: investor)
                let subtitle = AddSignalHeaderDataSource(item: (signal, rate))
                
                var buy = CreateSignalDataSource(title: NSLocalizedString("BUY", comment: ""))
                buy.selectors[.select] = {[unowned self] _, _, _ in
                    self.buy(signal)
                }
                
                let chart = ChartDataSource(item: signal)
                
                let composed = ComposedDataSource([title, subtitle, buy, chart])
                self.dataSource = TableViewDataSourceShim(composed)
                self.tableView.reloadData()
            }.ensure {
                self.dismissActivityIndicator()
            }.catch {
                self.showAlertWith($0)
        }
    
        tableView.register(cell: AddSignalHeaderTableViewCell.self)
        tableView.register(cell: CreateSignalTableViewCell.self)
        tableView.register(cell: AlertTitleTableViewCell.self)
        tableView.register(cell: ChartTableViewCell.self)
    }
    
    fileprivate func buy(_ company: Company) {
        let buy: BuyViewController = UIStoryboard(name: "Portfolio", bundle: nil)[.Buy]
        buy.company = company
        self.navigationController?.pushViewController(buy, animated: true)
    }
}

struct AlertTitleDataSource:
    TableViewDataSource,
    DataContainable,
    CellContainable,
    CellConfigurator
{
    var data: [InvestorModel]
    
    init(item: InvestorModel) {
        self.data = [item]
    }
    
    func configurateCell(_ cell: AlertTitleTableViewCell, item: InvestorModel, at indexPath: IndexPath) {
        cell.icon.setProfileImage(for: item)
    }
}

struct ChartDataSource:
    TableViewDataSource,
    DataContainable,
    CellContainable,
    CellConfigurator
{
    var data: [Company]
    
    init(item: Company) {
        self.data = [item]
    }
    
    func configurateCell(_ cell: ChartTableViewCell, item: Company, at indexPath: IndexPath) {
        cell.company = item
    }
}
