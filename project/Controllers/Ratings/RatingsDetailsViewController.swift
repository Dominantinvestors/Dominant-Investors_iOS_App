import UIKit

class RatingsDetailsViewController: DMViewController {

    var investor: InvestorModel! {
        didSet {
            if (oldValue != nil) {
                details.data = [investor]
                tableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak private var tableView: UITableView!
    
    private var dataSource: TableViewDataSourceShim? = nil {
        didSet {
            tableView.dataSource = dataSource
            tableView.delegate = dataSource
        }
    }
    
    private var details: InvestorsDetailsDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        tableView.register(cell: InvestorProfileTableViewCell.self)
        tableView.register(cell: AssetsTableViewCell.self)
        tableView.register(AssetsSection.self)
        
        details = InvestorsDetailsDataSource(user: investor)
        details.selectors[.custom("follow")] = {_, _, _ in
            self.follow()
        }
        details.selectors[.custom("unfollow")] = {_, _, _ in
            self.unfollow()
        }
        details.selectors[.custom("message")] = {_, _, _ in
        }
        
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
    
    private func follow() {
        showActivityIndicator()
        InvestorsDataProvider.default().follow(investor) { success, error in
            self.dismissActivityIndicator()
            if success {
                self.update()
            } else {
                self.showAlertWith(message: error)
            }
        }
    }
    
    private func unfollow() {
        showActivityIndicator()
        InvestorsDataProvider.default().unfollow(investor) { success, error in
            self.dismissActivityIndicator()
            if success {
                self.update()
            } else {
                self.showAlertWith(message: error)
            }
        }
    }
    
    private func update() {
        showActivityIndicator()
        InvestorsDataProvider.default().get(investor) { investor, error in
            self.dismissActivityIndicator()
            if let investor = investor {
                self.investor = investor
            } else {
                self.showAlertWith(message: error)
            }
        }
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
        
        if item.isFollowed {
            cell.follow.isHidden = true
            cell.unfollow.isHidden = false
        } else {
            cell.follow.isHidden = false
            cell.unfollow.isHidden = true
        }
        cell.follow.actionHandle(.touchUpInside) {
            self.selectors[.custom("follow")]?(cell, indexPath, item)
        }
        
        cell.unfollow.actionHandle(.touchUpInside) {
            self.selectors[.custom("unfollow")]?(cell, indexPath, item)
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
