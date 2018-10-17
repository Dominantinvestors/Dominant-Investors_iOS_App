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
    HeaderContainable
{
    var data: [SignalModel]
    
    init(data: [SignalModel]) {
        self.data = data
    }
    
    func section() -> HeaderFooterView<WatchListSection> {
        return .view { section, index in }
    }
    
    var selectors: [DataSource.Action: (WatchListTableViewCell, IndexPath, SignalModel) -> ()] = [:]
  
    func configurateCell(_ cell: WatchListTableViewCell, item: SignalModel, at indexPath: IndexPath) {
        cell.ticker.text = item.ticker
        cell.mktPrice.text = item.mktPrice
        cell.buyPoint.text = item.buyPoint
        cell.targetPrice.text = item.targetPrice
        cell.stopLoss.text = item.stopLoss

        cell.profile.setProfileImage(for: item.user)
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
            cell.rating.text = "\(user.rating) Rating"
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
        }
        cell.valueTitle.text = NSLocalizedString("PORTFOLIO VALUE", comment: "")
        cell.powerTitle.text = NSLocalizedString("BUYING POWER", comment: "")
        cell.totalTitle.text = NSLocalizedString("TOTAL GAIN/LOSS", comment: "")
        cell.resultsTitle.text = NSLocalizedString("PROFIT", comment: "")
    }
}

class AssetsDataSource:
    TableViewDataSource,
    DataContainable,
    CellContainable,
    CellConfigurator,
    CellSelectable,
    SectionConfigurator,
    HeaderContainable
{
    var data: [AssetsModel]
    
    init(data: [AssetsModel]) {
        self.data = data
    }
    
    func section() -> HeaderFooterView<AssetsSection> {
        return .view { section, index in }
    }
    
    var selectors: [DataSource.Action: (AssetsTableViewCell, IndexPath, AssetsModel) -> ()] = [:]
    
    func configurateCell(_ cell: AssetsTableViewCell, item: AssetsModel, at indexPath: IndexPath) {
        cell.ticker.text = item.ticker
        cell.buyPoint.text = item.buyPoint
        cell.set(mkt: Double(item.mktPrice) ?? 0.0)
        cell.profitValue.text = String(item.profitValue)
        cell.set(profit: item.profitPoints)
    }
}

struct SearchDataSource:
    TableViewDataSource,
    DataContainable,
    CellContainable,
    CellConfigurator
{
    var data: [String]
    
    let delegate: UISearchBarDelegate
    
    func configurateCell(_ cell: SearchTableViewCell, item: String, at indexPath: IndexPath) {
        cell.searchBar.placeholder = item
        cell.searchBar.delegate = delegate
    }
}
