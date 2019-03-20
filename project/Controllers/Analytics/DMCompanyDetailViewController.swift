import UIKit
import AFDateHelper
import Alamofire

class DMCompanyDetailViewController: DMViewController, UIWebViewDelegate {

    var company: CompanyModel!
    
    var rate: RatingDataSource!
    
    let footerView: CompanyFooterView = CompanyFooterView.instanceFromNib()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var logo: UIImageView!

    private var dataSource: TableViewDataSourceShim? = nil {
        didSet {
            tableView.dataSource = dataSource
            tableView.delegate = dataSource
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.tableFooterView = footerView
        tableView.register(cell: StatsTableViewCell.self)
        tableView.register(cell: ChartTableViewCell.self)
        tableView.register(cell: PriceTableViewCell.self)
        tableView.register(TitleSection.self)
        
        rate = RatingDataSource(item: (company, nil))
        
        var statistic: [TableViewDataSource] = [ChartDataSource(item: company), rate]
        
        if company.stats != nil {
            statistic.append( CompanySatatusDataSource(title: NSLocalizedString("Stats", comment: ""), data: company.status()))
        }
        
        if company.ratings != nil {
            statistic.append( CompanySatatusDataSource(title: NSLocalizedString("Rating", comment: ""), data: company.rating()))
        }
        
        dataSource = TableViewDataSourceShim(ComposedDataSource(statistic))
        tableView.reloadData()
        
        footerView.setCompany(company)
        footerView.revenueEstimizeButton.addTarget(self, action: #selector(estimazeButtonPressed(sender:)), for: .touchUpInside)
        footerView.epsEstimizeButton.addTarget(self, action: #selector(EPSestimazeButtonPressed(sender:)), for: .touchUpInside)
        footerView.tradingViewButton.addTarget(self, action: #selector(tradingViewChartButtonPressed(sender:)), for: .touchUpInside)
        footerView.addToWatchlistButton.addTarget(self, action: #selector(addToWatchlist(sender:)), for: .touchUpInside)

        footerView.comentsButton.addTarget(self, action: #selector(commentsButtonPressed(sender:)), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateRate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let chartVC = segue.destination as? DMTradingViewChartViewController {
            chartVC.ticker = self.company.ticker
            chartVC.isBlack = true
        }
    }
    
    // MARK: Private
    private func updateRate() {
        self.showActivityIndicator()
        CompanyDataProvider.default().rate(company)
            .done{
                self.rate.data = [(self.company, $0)]
                self.tableView.reloadData()
            }.ensure {
                self.dismissActivityIndicator()
            }.catch {
                self.showAlertWith($0)
        }
    }
    
    private func setupUI() {
        infoLabel.text = company.description
        
        if let logo = company.logo {
            Alamofire.request(logo).responseImage { response in
                if let image = response.result.value {
                    self.logo.image = image
                }
            }
        } else {
            title = company.name
        }
        
        if company.estimizeUrl == nil {
            footerView.revenueEstimizeButton.isEnabled = false
            footerView.revenueEstimizeButton.alpha = 0.5
        }
        
        if company.estimizeEPSUrl == nil {
            footerView.epsEstimizeButton.isEnabled = false
            footerView.epsEstimizeButton.alpha = 0.5
        }
    }

    // MARK: Actions
    @IBAction func showSignals(sender : UIButton) {
        self.performSegue(withIdentifier: "DMSignalsSegue", sender: self)
    }
    
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func estimazeButtonPressed(sender: UIButton) {
        guard let estimazeURL = self.company.estimizeUrl else { return }

        let storyboard = UIStoryboard.init(name: "OutsourceCharts", bundle: nil)
        if let chartVC = storyboard.instantiateViewController(withIdentifier: "DMEstimazeChartViewController") as? DMEstimazeChartViewController {
            chartVC.estimazeImageURL = URL(string:estimazeURL)
            chartVC.ticker = self.company.ticker
            self.navigationController?.pushViewController(chartVC, animated: true)
        }
    }
    
    @IBAction func EPSestimazeButtonPressed(sender: UIButton) {
        guard let estimazeURL = self.company.estimizeEPSUrl else { return }

        let storyboard = UIStoryboard.init(name: "OutsourceCharts", bundle: nil)
        if let chartVC = storyboard.instantiateViewController(withIdentifier: "DMEstimazeChartViewController") as? DMEstimazeChartViewController {
            chartVC.estimazeImageURL = URL(string:estimazeURL)
            chartVC.ticker = self.company.ticker
            self.navigationController?.pushViewController(chartVC, animated: true)
        }
    }
    
    @IBAction func commentsButtonPressed(sender: UIButton) {
        let chat = CompanyChatViewController()
        chat.company = company
        navigationController?.pushViewController(chat, animated: true)
    }
    
    @IBAction func tradingViewChartButtonPressed(sender: UIButton) {
        showActivityIndicator()
        CompanyDataProvider.default().chart(company) { widget, error in
            self.dismissActivityIndicator()
            if let widget = widget {
                let add: MoreViewController = UIStoryboard.init(name: "Screener", bundle: nil)[.More]
                add.HTMLString = widget.html
                add.ticker = self.company.ticker
                self.navigationController?.pushViewController(add, animated: true)
            }
        }
    }
    
    @IBAction func addToWatchlist(sender: UIButton) {
        CompanyDataProvider.default().addToWatchList(company) { success, error in
            if success {
                self.tabBarController?.selectedIndex = 2
            } else {
                self.showAlertWith(message: error)
            }
        }
    }
}

struct CompanySatatusDataSource:
    TableViewDataSource,
    DataContainable,
    CellContainable,
    CellConfigurator,
    SectionConfigurator,
    HeaderContainable
{
    let title: String
    
    var data: [StatusModel]
    
    func section() -> HeaderFooterView<TitleSection> {
        return .view { section, index in
            section.title.text = self.title.uppercased()
        }
    }
    
    func configurateCell(_ cell: StatsTableViewCell, item: StatusModel, at indexPath: IndexPath) {
        cell.title.text = item.title
        cell.subtitle.text = item.subtitle
    }
}

class RatingDataSource:
    TableViewDataSource,
    DataContainable,
    CellContainable,
    CellConfigurator
{
    var data: [(CompanyModel, Rate?)]
    
    init(item: (CompanyModel, Rate?)) {
        self.data = [item]
    }
    
    func configurateCell(_ cell: PriceTableViewCell, item: (CompanyModel, Rate?), at indexPath: IndexPath) {
        cell.isGrowingIcon.image = item.0.isGrowing ?
            UIImage(named: "grouving_green") :
            UIImage(named: "grouving_red")
        cell.priceLabel.attributedText = (item.1?.rate ?? "0.00").toMoneyStyle()
    }
}

