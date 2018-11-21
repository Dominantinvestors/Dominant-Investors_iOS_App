import UIKit

struct CreateSignalDataSource:
    TableViewDataSource,
    DataContainable,
    CellContainable,
    CellConfigurator,
    CellSelectable
{
    var data: [String] 
    
    init(title: String ) {
        self.data = [title]
    }
    
    var selectors: [DataSource.Action: (CreateSignalTableViewCell, IndexPath, String) -> ()] = [:]
    
    func configurateCell(_ cell: CreateSignalTableViewCell, item: String, at indexPath: IndexPath) {
        cell.create.setTitle(item, for: .normal)
        cell.create.actionHandle(.touchUpInside) {
            self.selectors[.select]?(cell, indexPath, item)
        }
    }
}

class WatchListDataSource:
    TableViewDataSource,
    DataContainable,
    CellContainable,
    CellConfigurator,
    CellSelectable,
    SectionConfigurator,
    HeaderContainable,
    EditableCellDataSource
{
    var data: [SignalModel]
    
    var selectors: [DataSource.Action: (WatchListTableViewCell, IndexPath, SignalModel) -> ()] = [:]

    var edits: [EditAction]

    init(data: [SignalModel], editActions: [EditAction] = []) {
        self.data = data
        self.edits = editActions
    }
    
    func section() -> HeaderFooterView<WatchListSection> {
        return .view { section, index in }
    }
    
    func editActions() -> [EditAction] {
        return self.edits
    }
  
    func configurateCell(_ cell: WatchListTableViewCell, item: SignalModel, at indexPath: IndexPath) {
        cell.ticker.text = item.ticker
        cell.mktPrice.text = item.mktPrice
        cell.buyPoint.text = item.buyPoint
        cell.targetPrice.text = item.targetPrice
        cell.stopLoss.text = item.stopLoss

        if item.investmentIdea != nil {
            cell.profile.image = UIImage(named: "Logo")
        } else {
            cell.profile.setProfileImage(for: item.user)
        }
    }
}

class PortfolioDataSource:
    TableViewDataSource,
    DataContainable,
    CellContainable,
    CellConfigurator,
    CellSelectable
{
    var data: [(UserModel?, PortfolioModel?)]
    
    init(user: UserModel?, portfolio: PortfolioModel?) {
        self.data = [(user, portfolio)]
    }
    
    var selectors: [DataSource.Action: (PortfolioTableViewCell, IndexPath, (UserModel?, PortfolioModel?)) -> ()] = [:]
    
    func configurateCell(_ cell: PortfolioTableViewCell, item: (UserModel?, PortfolioModel?), at indexPath: IndexPath) {
        
        cell.icon.setProfileImage(for: item.0)
        
        cell.edit.actionHandle(.touchUpInside) {
            self.selectors[.custom("edit")]?(cell, indexPath, item)
        }
        
        cell.message.actionHandle(.touchUpInside) {
            self.selectors[.custom("message")]?(cell, indexPath, item)
        }
        
        if let user = item.0 {
            cell.name.text = user.fullName()
            cell.followers.text = "\(user.followers) followers"
        }
        
        cell.edit.setTitle(NSLocalizedString("Edit profile", comment: ""), for: .normal)
        cell.message.setTitle(" 5", for: .normal)
        
        cell.edit.isHidden = true
        cell.message.isHidden = true
        
        if let portfolio = item.1 {
            cell.value.text = portfolio.value + Values.Currency
            cell.power.text = portfolio.buyingPower + Values.Currency
            cell.total.text = portfolio.total + Values.Currency
            cell.results.text = portfolio.profit + "%"
            cell.rating.text = "\(portfolio.index) Rating"
        }
        cell.valueTitle.text = NSLocalizedString("PORTFOLIO VALUE", comment: "")
        cell.powerTitle.text = NSLocalizedString("BUYING POWER", comment: "")
        cell.totalTitle.text = NSLocalizedString("TOTAL GAIN/LOSS", comment: "")
        cell.resultsTitle.text = NSLocalizedString("PROFIT", comment: "")
    }
}

class TransactionsDataSource:
    TableViewDataSource,
    DataContainable,
    CellContainable,
    CellConfigurator,
    CellSelectable,
    SectionConfigurator,
    HeaderContainable,
    EditableCellDataSource
{
    var data: [TransactionModel]
    
    var edits: [EditAction]
    
    init(data: [TransactionModel], editActions: [EditAction] = []) {
        self.edits = editActions
        self.data = data
    }
    
    func section() -> HeaderFooterView<AssetsSection> {
        return .view { section, index in }
    }
    
    var selectors: [DataSource.Action: (AssetsTableViewCell, IndexPath, TransactionModel) -> ()] = [:]
    
    func editActions() -> [EditAction] {
        return self.edits
    }
    
    func configurateCell(_ cell: AssetsTableViewCell, item: TransactionModel, at indexPath: IndexPath) {
        cell.ticker.text = item.ticker
        cell.amount.text = item.amount
        cell.buyPoint.text = item.buyPoint
        cell.mktPrice.text = item.mktPrice

        if Double(item.profitPoints)! >= 0.0 {
            cell.profitPoints.setGreen()
        } else {
            cell.profitPoints.setRed()
        }
        
        if (Double(item.buyPoint)! - Double(item.mktPrice)!) <= 0.0 {
            cell.mktPrice.setGreen()
        } else {
            cell.mktPrice.setRed()
        }
        
        cell.profitPoints.text = item.profitPoints
        cell.profitValue.text = String(format:"%.2f", Double(item.profitValue)!)
    }
}

struct SearchDataSource:
    TableViewDataSource,
    DataContainable,
    CellContainable,
    CellConfigurator
{
    var data: [String]
    
    weak var delegate: UISearchBarDelegate?
    
    func configurateCell(_ cell: SearchTableViewCell, item: String, at indexPath: IndexPath) {
        cell.searchBar.placeholder = item
        cell.searchBar.delegate = delegate
    }
}
