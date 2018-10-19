import UIKit

class RatingsDetailsViewController: DMViewController {

    var investor: InvestorModel!
    
    @IBOutlet weak private var tableView: UITableView!
    
    private var dataSource: TableViewDataSourceShim? = nil {
        didSet {
            tableView.dataSource = dataSource
            tableView.delegate = dataSource
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        tableView.register(cell: InvestorProfileTableViewCell.self)
        tableView.register(cell: AssetsTableViewCell.self)
        tableView.register(AssetsSection.self)
        
        let details = InvestorsDetailsDataSource(user: investor)
        let assets = AssetsDataSource(data: [])

        showActivityIndicator()
        PortfolioDataProvider.default().transactions(investor.id) { transactions, error in
            self.dismissActivityIndicator()
            if let items = transactions {
                assets.data = items
                self.tableView.reloadData()
            } else {
                self.showAlertWith(message: error)
            }
        }
        
        self.dataSource = TableViewDataSourceShim(ComposedDataSource([details, assets]))
        self.tableView.reloadData()
    }
}

class InvestorsDetailsDataSource:
    TableViewDataSource,
    DataContainable,
    CellContainable,
    CellConfigurator,
    CellSelectable
{
    var data: [InvestorModel]
    
    init(user: InvestorModel) {
        self.data = [user]
    }
    
    var selectors: [DataSource.Action: (InvestorProfileTableViewCell, IndexPath, InvestorModel) -> ()] = [:]
    
    func configurateCell(_ cell: InvestorProfileTableViewCell, item: InvestorModel, at indexPath: IndexPath) {
        
        cell.icon.setProfileImage(for: item)
        
        cell.follow.actionHandle(.touchUpInside) {
            self.selectors[.custom("follow")]?(cell, indexPath, item)
        }
        
        cell.message.actionHandle(.touchUpInside) {
            self.selectors[.custom("message")]?(cell, indexPath, item)
        }
        
        cell.firstName.text = item.firstName
        cell.secondName.text = item.lastName
        cell.rating.text = "\(item.rating)"
        cell.followers.text = "\(item.followers)"
    }
}
