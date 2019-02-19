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
    private var transactions: TransactionsDataSource!
    
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
        let buy = storyboard![.SearchSignal]
        self.navigationController?.pushViewController(buy, animated: true)
    }
    
    private func editProfile() {
    }
    
    private func onMessage() {
        let vc = storyboard![.Conversations]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func buyCompany(_ company: Company) {
        let buy: BuyViewController = storyboard![.Buy]
        buy.company = company
        self.navigationController?.pushViewController(buy, animated: true)
    }
    
    fileprivate func sellCompany(_ company: TransactionModel) {
        let sell: SellViewController = storyboard![.Sell]
        sell.maxAmount = company.amount
        sell.company = company
        self.navigationController?.pushViewController(sell, animated: true)
    }
    
    fileprivate func chart(_ company: Company) {
        showActivityIndicator()
        CompanyDataProvider.default().chart(company) { widget, error in
            self.dismissActivityIndicator()
            if let widget = widget {
                self.showCompanyWidget(company, widget: widget.html)
            }
        }
    }
    
    fileprivate func moreInfo(_ company: Company) {
        showActivityIndicator()
        CompanyDataProvider.default().more(company) { widget, error in
            self.dismissActivityIndicator()
            if let widget = widget {
                self.showCompanyWidget(company, widget: widget.html)
            }
        }
    }
    
    fileprivate func delete(_ signal: SignalModel) {
        self.showActivityIndicator()
        SignalsDataProvider.default().delete(signal) {[unowned self] success, error in
            self.dismissActivityIndicator()
            if success {
                self.reloadData()
            } else {
                self.showAlertWith(message: error)
            }
        }
    }
    
    fileprivate func reloadData() {
        PortfolioDataProvider.default().get {[unowned self] portfolio, error in
            if let portfolio = portfolio {
                let user: UserModel = ServiceLocator.shared.getService()
                self.portfolio.data = [(user, portfolio)]
                self.tableView.reloadData()
            } else {
                self.showAlertWith(message: error)
            }
        }
        
        PortfolioDataProvider.default().transactions {[unowned self] assets, error in
            if let assets = assets {
                self.transactions.data = assets
                self.tableView.reloadData()
            } else {
                self.showAlertWith(message: error)
            }
        }
        
        SignalsDataProvider.default().get()
            .done {
                self.watchList.data = $0.items
                self.tableView.reloadData()
            }.ensure{
                
            }.catch {
                self.showAlertWith($0)
        }
        
        ConversationsDataProvider.default().unread { count, _ in
            self.portfolio.unread = count
            self.tableView.reloadData()
        }
    }
    
    fileprivate func setUpSegmentControll() {
        segmentControll.setLeft(NSLocalizedString("WATCHLIST SIGNALS", comment: ""))
        segmentControll.setRight(NSLocalizedString("YOUR PORTFOLIO", comment: ""))
        
        segmentControll.selector = {[unowned self] index in
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
        transactions = transactionsSection()
        return ComposedDataSource([portfolio, search, transactions])
    }
    
    fileprivate func createSignalSection() -> TableViewDataSource{
        var createSignal = CreateSignalDataSource(title: NSLocalizedString("CREATE SIGNAL", comment: ""))
        createSignal.selectors[.select] = {[unowned self] _, _, _ in
            self.createSignal()
        }
        return createSignal
    }
    
    fileprivate func watchListSection() -> WatchListDataSource {
        let editActions = [EditAction(action: .custom("Delete"),
                                      title: NSLocalizedString("X", comment: ""),
                                      color: UIColor.red),
                           EditAction(action: .custom("Chart"),
                                      title: NSLocalizedString("CHART", comment: ""),
                                      color: Colors.DMChartButtonColor)]

        let watchList = WatchListDataSource(data: [], editActions: editActions)
        watchList.selectors[.select] = { _, _, _ in
        }
        
        watchList.selectors[.custom("Delete")] = {[unowned self] _, _, model in
            self.delete(model)
        }
        
        watchList.selectors[.custom("Chart")] = {[unowned self] _, _, model in
            self.chart(model)
        }
        
        return watchList
    }
    
    fileprivate func portfolioSection() -> PortfolioDataSource {
        let portfolio = PortfolioDataSource(user: nil, portfolio: nil)
        portfolio.selectors[.custom("edit")] = {[unowned self] _, _, _ in
            self.editProfile()
        }
        portfolio.selectors[.custom("message")] = {[unowned self] _, _, _ in
            self.onMessage()
        }
        return portfolio
    }
    
    fileprivate func searchBy(_ text: String, _ searchController: SearchController ) {
        self.showActivityIndicator(searchController)
        SignalsDataProvider.default().search(by: text) {[unowned self] items, error in
            self.dismissActivityIndicator(searchController)
            if let items = items {
                searchController.data = items
            } else {
                self.showAlertWith(message: error)
            }
        }
    }
    
    fileprivate func searchSection() -> TableViewDataSource {
        let searchController = SearchController()
        searchController.textDidUpdate = {[unowned self] text in
            self.searchBy(text, searchController)
        }
        
        searchController.selectedItem = { item in
            if let company = item as? SearchAssetModel {
                self.buyCompany(company)
            }
        }
        return SearchDataSource(data: [NSLocalizedString("Enter the ticket", comment: "")], delegate: searchController)
    }
    
    fileprivate func showCompanyWidget(_ company: Company, widget: String) {
        let add: MoreViewController = UIStoryboard.init(name: "Screener", bundle: nil)[.More]
        add.HTMLString = widget
        add.ticker = company.ticker
        self.navigationController?.pushViewController(add, animated: true)
    }
    
    fileprivate func transactionsSection() -> TransactionsDataSource {
        let editActions = [EditAction(action: .custom("Sell"),
                                      title: NSLocalizedString("Sell", comment: ""),
                                      color: UIColor.red),
                           EditAction(action: .custom("Chart"),
                                      title: NSLocalizedString("CHART", comment: ""),
                                      color: Colors.DMChartButtonColor),
                           EditAction(action: .custom("More"),
                                      title: NSLocalizedString("MORE", comment: ""),
                                      color: UIColor.lightGray)]
        
        let transactions = TransactionsDataSource(data: [], editActions: editActions)
        transactions.selectors[.custom("Sell")] = {[unowned self] _, _, model in
           self.sellCompany(model)
        }
        transactions.selectors[.custom("Chart")] = {[unowned self] _, _, model in
            self.chart(model)
        }
        transactions.selectors[.custom("More")] = {[unowned self] _, _, model in
            self.moreInfo(model)
        }
        return transactions
    }
}
