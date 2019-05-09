import UIKit
import PromiseKit

class AlertNewSignalViewController: UIViewController {

    var investorID: Int!
    var signalID: Int!
    
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
                SignalsDataProvider.default().get(by: signalID!)
            }.then { signal in
                when(fulfilled: Promise.value(signal),
                     InvestorsDataProvider.default().get(by: self.investorID!),
                     CompanyDataProvider.default().rate(signal))
            }.done { signal, investor, rate in
                
                let title = AlertTitleDataSource(item: (investor, signal))
                let subtitle = AddSignalHeaderDataSource(item: (signal, rate))
                
                var buy = CreateSignalDataSource(title: NSLocalizedString("BUY", comment: ""))
                buy.selectors[.select] = {[unowned self] _, _, _ in
                    self.buy(signal)
                }
                
                let chart = ChartDataSource(item: signal)
                let info = SignalInfoSource(item: signal)

                let composed = ComposedDataSource([title, subtitle, info, buy, chart])
                
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
        tableView.register(cell: SignalInfoTableViewCell.self)
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
    var data: [(InvestorModel, SignalModel)]
    
    init(item: (InvestorModel, SignalModel)) {
        self.data = [item]
    }
    
    func configurateCell(_ cell: AlertTitleTableViewCell, item: (InvestorModel, SignalModel), at indexPath: IndexPath) {
        if item.1.investmentIdea != nil {
            cell.icon.image = UIImage(named: "Logo")
        } else {
            cell.icon.setProfileImage(for: item.0)
        }
        cell.tiker.text = item.1.name
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

struct SignalInfoSource:
    TableViewDataSource,
    DataContainable,
    CellContainable,
    CellConfigurator
{
    var data: [SignalModel]
    
    init(item: SignalModel) {
        self.data = [item]
    }
    
    func configurateCell(_ cell: SignalInfoTableViewCell, item: SignalModel, at indexPath: IndexPath) {
        cell.point.text = item.buyPoint + Values.Currency
        cell.pointTitle.text = NSLocalizedString("BUY POINT", comment: "")
        cell.targetPrice.text = item.targetPrice + Values.Currency
        cell.targetTitle.text = NSLocalizedString("TARGET PRICE", comment: "")
        cell.stop.text = item.stopLoss + Values.Currency
        cell.stopTitle.text = NSLocalizedString("STOP LOSS", comment: "")
    }
}