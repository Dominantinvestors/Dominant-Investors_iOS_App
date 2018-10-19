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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func createSignal() {
        let buy = UIStoryboard(name: "Portfolio", bundle: nil)[.SearchSignal]
        self.navigationController?.pushViewController(buy, animated: true)
    }
    
    private func editProfile() {
    }
    
    private func onMessage() {
    }
    
    fileprivate func reloadData() {
        PortfolioDataProvider.default().get { portfolio, error in
            if let portfolio = portfolio {
                let user: UserModel = ServiceLocator.shared.getService()
                self.portfolio.data = [(user, portfolio)]
                self.tableView.reloadData()
            } else {
                self.showAlertWith(message: error)
            }
        }
        
        PortfolioDataProvider.default().transactions { assets, error in
            if let assets = assets {
                self.assets.data = assets
                self.tableView.reloadData()
            } else {
                self.showAlertWith(message: error)
            }
        }
        
        SignalsDataProvider.default().get { signals, error in
            if let signals = signals {
                self.watchList.data = signals
                self.tableView.reloadData()
            } else {
                self.showAlertWith(message: error)
            }
        }
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
        var createSignal = CreateSignalDataSource(title: NSLocalizedString("CREATE SIGNAL", comment: ""))
        createSignal.selectors[.select] = {_, _, _ in
            self.createSignal()
        }
        return createSignal
    }
    
    fileprivate func watchListSection() -> WatchListDataSource {
        let watchList = WatchListDataSource(data: [])
        watchList.selectors[.select] = {_, _, _ in
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
            
            self.showActivityIndicator(searchController)
            DrivewealthDataProvider.default().search(by: text) { items, error in
            

//            SignalsDataProvider.default().search(by: text) { items, error in
                self.dismissActivityIndicator(searchController)
                if let items = items {
                    searchController.data = items
                } else {
                    self.showAlertWith(message: error)
                }
            }
        }
        
        searchController.selectedItem = { item in
            if let asset = item as? SearchAssetModel {
                self.selectedSearchAsset(asset)
            }
            
            if let company = item as? Company {
                self.buyCompany(company)
            }
        }
  
        return SearchDataSource(data: [NSLocalizedString("Enter the ticket", comment: "")], delegate: searchController)
    }
    
    fileprivate func buyCompany(_ company: Company) {
        let buy: BuyViewController = UIStoryboard(name: "Portfolio", bundle: nil)[.Buy]
        buy.company = company
        self.navigationController?.pushViewController(buy, animated: true)
    }
    
    fileprivate func selectedSearchAsset(_ asset: SearchAssetModel) {
        self.showActivityIndicator()
        CompanyDataProvider.default().get(asset.id, completion: { company, error  in
            self.dismissActivityIndicator()
            if let company = company {
               self.buyCompany(company)
            } else {
                self.showAlertWith(message: error)
            }
        })
    }
    
    fileprivate func assetsSection() -> AssetsDataSource {
        let assets = AssetsDataSource(data: [])
        return assets
    }
}
