import UIKit

class PersonalViewController: KeyboardObservableViewController {
    
    private var dataSource: SegmentDataSourceShim? = nil {
        didSet {
            tableView.dataSource = dataSource
            tableView.delegate = dataSource
        }
    }
    
    private var watchList: WatchListDataSource!
    private var portfolio: PortfolioDataSource!
    private var assets: AssetsDataSource!
    
    @IBOutlet weak var segmentControll: SegmentControll!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
 
        tableView.register(cell: CreateSignalTableViewCell.self)
        tableView.register(cell: WatchListTableViewCell.self)
        tableView.register(cell: PortfolioTableViewCell.self)
        tableView.register(cell: SearchTableViewCell.self)
        tableView.register(cell: AssetsTableViewCell.self)

        tableView.register(WatchListSection.self)
        tableView.register(AssetsSection.self)

        setUpSegmentControll()
        
        let watchListController = watchListControllerDataSource()
        
        let portfolioController = portfolioControllerDataSource()
        
        self.dataSource = SegmentDataSourceShim([watchListController, portfolioController], tableView: tableView)
        self.tableView.reloadData()
        
        PortfolioDataProvider.default().get { portfolio, error in
            if let portfolio = portfolio {
                let user: UserModel = ServiceLocator.shared.getService()
                self.portfolio.data = [(user, portfolio)]
                self.tableView.reloadData()
            } else {
                self.showAlertWith(title: NSLocalizedString("Error!!!", comment: ""),
                                   message: error ?? "")
            }
        }
        
        PortfolioDataProvider.default().assets { assets, error in
            if let assets = assets {
                self.assets.data = assets
                self.tableView.reloadData()
            } else {
                self.showAlertWith(title: NSLocalizedString("Error!!!", comment: ""),
                                   message: error ?? "")
            }
        }

        SignalsDataProvider.default().get { signals, error in
            if let signals = signals {
                self.watchList.data = signals
                self.tableView.reloadData()
            } else {
                self.showAlertWith(title: NSLocalizedString("Error!!!", comment: ""),
                                   message: error ?? "")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func createSignal() {
        
        self.tabBarController?.selectedIndex = 0
    }
    
    private func editProfile() {
    }
    
    private func onMessage() {
    }
    
    fileprivate func setUpSegmentControll() {
        segmentControll.setLeft(NSLocalizedString("WATCHLIST SIGNALS", comment: ""))
        segmentControll.setRight(NSLocalizedString("YOUR PORTFOLIO", comment: ""))
        
        segmentControll.selector = { index in
            self.dataSource?.selectIndex = index
        }
    }
    
    fileprivate func watchListControllerDataSource() -> TableViewDataSource {
        watchList = watchListSection()
        let createSignal = createSignalSection()
        return ComposedDataSource([createSignal, watchList])
    }
    
    fileprivate func portfolioControllerDataSource() -> TableViewDataSource {
        portfolio = portfolioSection()
        let search = searchSection()
        assets = assetsSection()
        return ComposedDataSource([portfolio, search, assets])
    }
    
    fileprivate func createSignalSection() -> TableViewDataSource{
        var createSignal = CreateSignalDataSource()
        createSignal.selectors[.select] = {_, _, _ in
            self.createSignal()
        }
        return createSignal
    }
    
    fileprivate func watchListSection() -> WatchListDataSource {
        let watchList = WatchListDataSource(data: [])
        watchList.selectors[.select] = {_, _, _ in
            self.createSignal()
        }
        return watchList
    }
    
    fileprivate func portfolioSection() -> PortfolioDataSource {
        let portfolio = PortfolioDataSource(user: nil, portfolio: nil)
        portfolio.selectors[.custom("edit")] = {_, _, _ in
            self.editProfile()
        }
        portfolio.selectors[.custom("message")] = {_, _, _ in
            self.onMessage()
        }
        return portfolio
    }
    
    fileprivate func searchSection() -> TableViewDataSource {
        let searchController = SearchController()
        searchController.textDidUpdate = { text in
            PortfolioDataProvider.default().searchAssets(by: text) { items, error in
                if let items = items {
                    searchController.data = items
                } else {
                    self.showAlertWith(title: NSLocalizedString("Error!!!", comment: ""),
                                       message: error ?? "")
                }
            }
        }
        
        searchController.selectedItem = { item in
            if let asset = item as? AssetsModel {
                let buy: BuyViewController = UIStoryboard(name: "Portfolio", bundle: nil)[.Buy]
                buy.asset = asset
                self.navigationController?.pushViewController(buy, animated: true)
            }
        }
  
        return SearchDataSource(data: [NSLocalizedString("Enter the ticket", comment: "")], delegate: searchController)
    }
    
    fileprivate func assetsSection() -> AssetsDataSource {
        let assets = AssetsDataSource(data: [])
        return assets
    }
}
