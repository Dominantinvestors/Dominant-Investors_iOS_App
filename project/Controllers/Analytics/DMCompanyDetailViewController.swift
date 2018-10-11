import UIKit
import AFDateHelper
import Alamofire

class DMCompanyDetailViewController: DMViewController, ChartViewDelegate, UIWebViewDelegate {

    var company: CompanyModel!
    var chartView: ChartView? = nil
    var chart: SwiftStockChart!
    
    var items: [ChartPoint] = []
    
    let footerView: CompanyFooterView = CompanyFooterView.instanceFromNib()

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var chartContainer: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var chartContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var isGrowingIcon: UIImageView!
    @IBOutlet weak var logo: UIImageView!

    private var dataSource: TableViewDataSourceShim? = nil {
        didSet {
            tableView.dataSource = dataSource
            tableView.delegate = dataSource
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        tableView.tableFooterView = footerView
        tableView.register(cell: StatsTableViewCell.self)
        tableView.register(TitleSection.self)
        
        var statistic: [TableViewDataSource] = []
        if let _ = company.stats {
            statistic.append( CompanySatatusDataSource(title: NSLocalizedString("Stats", comment: ""), data: company.status()))
        }
        
        if let _ = company.ratings {
            statistic.append( CompanySatatusDataSource(title: NSLocalizedString("Rating", comment: ""), data: company.rating()))
        }
        
        dataSource = TableViewDataSourceShim(ComposedDataSource(statistic))
        tableView.reloadData()
        
        footerView.setCompany(company)
        footerView.revenueEstimizeButton.addTarget(self, action: #selector(estimazeButtonPressed(sender:)), for: .touchUpInside)
        footerView.epsEstimizeButton.addTarget(self, action: #selector(EPSestimazeButtonPressed(sender:)), for: .touchUpInside)
        footerView.tradingViewButton.addTarget(self, action: #selector(tradingViewChartButtonPressed(sender:)), for: .touchUpInside)
        footerView.addToWatchlistButton.addTarget(self, action: #selector(addToWatchlist(sender:)), for: .touchUpInside)

        _ = self.chartContainerHeight.setMultiplier(multiplier: 0.25)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadChart()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let chartVC = segue.destination as? DMTradingViewChartViewController {
            chartVC.ticker = self.company.ticker
            chartVC.isBlack = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        for view in self.chartContainer.subviews {
            view.removeFromSuperview()
        }
        coordinator.animate(alongsideTransition: { context in
            context.viewController(forKey: UITransitionContextViewControllerKey.from)
        }, completion: { context in
            self.loadChart()
        })
    }
    
    // MARK: Private
    
    private func setupUI() {
        infoLabel.text = company.description
        priceLabel.attributedText = company.buyPoint.toMoneyStyle()
        
        isGrowingIcon.image = company.isGrowing ?
            UIImage(named: "grouving_green") :
            UIImage(named: "grouving_red")
        
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
        self.priceView.layer.cornerRadius = 25.0
    }
    
    private func loadChart() {
        chartView = ChartView.create()
        chartView?.delegate = self
        chartView?.frame = CGRect(x: 24, y: 10, width: self.chartContainer.frame.width-48, height: self.chartContainer.frame.height - 20)
        chartContainer?.addSubview(chartView!)
        
        chart = SwiftStockChart(frame: CGRect(x : 16, y :  0, width : self.chartContainer.bounds.size.width - 60, height : chartContainer.frame.height -
            100))
        
        chartView?.backgroundColor = UIColor.clear
        
        chart.axisColor = UIColor.red
        chart.verticalGridStep = 3
        
        loadChartWithRange(range: .OneDay)
        
        chartView?.addSubview(chart)
        chartView?.backgroundColor = UIColor.black
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
}
    
    
    // MARK: ChartViewDelegate
    
    func loadChartWithRange(range: ChartTimeRange) {
        
        chart.timeRange = range
        
        let times = chart.timeLabelsForTimeFrame(range: range)
        chart.horizontalGridStep = times.count - 1
        
        chart.labelForIndex = {(index: NSInteger) -> String in
            return times[index]
        }
        
        chart.labelForValue = {(value: CGFloat) -> String in
            return String(format: "%.02f", value)
        }
        
        if self.company.isCrypto() {
            rangeChangeForCrypto(range: range)
        } else {
            rangeChangeForCompany(range: range)
        }
    }
    
    func rangeChangeForCompany(range: ChartTimeRange) {
        SwiftStockKit.fetchChartPoints(symbol: self.company.ticker, range: range, crypto: self.company.isCrypto()) { (chartPoints) -> () in
            self.chart.clearChartData()
            self.chart.setChartPoints(points: chartPoints)
        }
    }
    
    func rangeChangeForCrypto(range: ChartTimeRange) {
        let endDate = Date()
        var startDate: Date
        
        switch (range) {
        case .OneDay:
            startDate = endDate.adjust(.day, offset: -1)
        case .FiveDays:
            startDate = endDate.adjust(.day, offset: -5)
        case .TenDays:
            startDate = endDate.adjust(.day, offset: -10)
        case .OneMonth:
            startDate = endDate.adjust(.month, offset: -1)
        case .ThreeMonths:
            startDate = endDate.adjust(.month, offset: -3)
        case .OneYear:
            startDate = endDate.adjust(.year, offset: -1)
        case .FiveYears:
            startDate = endDate.adjust(.year, offset: -5)
        }
        
        if !self.items.isEmpty {
            self.filter(fot: startDate.timeIntervalSince1970)
        } else {
            self.showActivityIndicator()
            CryptoCompareDataProvider.default().get(for: self.company.ticker) { points, error in
                self.dismissActivityIndicator()
                if let points = points {
                    self.items = points
                    self.filter(fot: startDate.timeIntervalSince1970)
                }
            }
        }
    }
    
    func filter(fot date: Double)  {
        let points = self.items.filter({ TimeInterval( $0.timeStamp ?? 0.0) > date})
        self.chart.clearChartData()
        self.chart.setChartPoints(points: points)
    }
    
    func didChangeTimeRange(range: ChartTimeRange) {
        loadChartWithRange(range: range)
    }

    // MARK: Actions
    
    @IBAction func showSignals(sender : UIButton) {
        self.performSegue(withIdentifier: "DMSignalsSegue", sender: self)
    }
    
    @IBAction func backButtonAction(sender : UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func estimazeButtonPressed(sender: UIButton) {
        guard let estimazeURL = self.company.estimizeUrl else { return }

        let storyboard = UIStoryboard.init(name: "OutsourceCharts", bundle: nil)
        if let chartVC = storyboard.instantiateViewController(withIdentifier: "DMEstimazeChartViewController") as? DMEstimazeChartViewController {
            chartVC.estimazeImageURL = URL(string:estimazeURL)
            chartVC.ticker = self.company.ticker
            self.showChart(chart: chartVC)
        }
    }
    
    @IBAction func EPSestimazeButtonPressed(sender: UIButton) {
        guard let estimazeURL = self.company.estimizeEPSUrl else { return }

        let storyboard = UIStoryboard.init(name: "OutsourceCharts", bundle: nil)
        if let chartVC = storyboard.instantiateViewController(withIdentifier: "DMEstimazeChartViewController") as? DMEstimazeChartViewController {
            chartVC.estimazeImageURL = URL(string:estimazeURL)
            chartVC.ticker = self.company.ticker
            self.showChart(chart: chartVC)
        }
    }
    
    @IBAction func tradingViewChartButtonPressed(sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "OutsourceCharts", bundle: nil)
        if let chartVC = storyboard.instantiateViewController(withIdentifier: "DMTradingViewChartViewController") as? DMTradingViewChartViewController {
            chartVC.ticker = company.ticker
            self.showChart(chart: chartVC)
        }
    }
    
    @IBAction func addToWatchlist(sender: UIButton) {
        SignalsDataProvider.default().addCompany(company) { success, error in
            if success {
                self.tabBarController?.selectedIndex = 2
            } else {
                self.showAlertWith(message: error)
            }
        }
    }
    
    fileprivate func showChart(chart : UIViewController) {
        
        self.navigationController?.pushViewController(chart, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let backItem = UIBarButtonItem()
            backItem.title = ""
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.white
        ]
        navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 16/255, green: 18/255, blue: 26/255, alpha: 1)
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
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
    
    var data: [(StatusModel, StatusModel?)]
    
    func section() -> HeaderFooterView<TitleSection> {
        return .view { section, index in
            section.title.text = self.title.uppercased()
        }
    }
    
    func configurateCell(_ cell: StatsTableViewCell, item: (StatusModel, StatusModel?), at indexPath: IndexPath) {
        cell.titleLeft.text = item.0.title
        cell.subtitleLeft.text = item.0.subtitle
        cell.titleRight.text = item.1?.title
        cell.subtitleRight.text = item.1?.subtitle
    }
}


