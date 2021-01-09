import UIKit

class DMRatingsViewController: DMViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView : UITableView!
    
    var ratings: [InvestorModel]?
    var refreshControl : UIRefreshControl!
    var titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if let navigationBar = self.navigationController?.navigationBar {
            let firstFrame = CGRect(x: 0, y: 0, width: navigationBar.frame.width, height: navigationBar.frame.height)
      
            titleLabel.frame = firstFrame
            titleLabel.font = Fonts.regular(16)
            titleLabel.text = "TOP 100"
            titleLabel.textAlignment = .center
            navigationBar.addSubview(titleLabel)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        titleLabel.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        renewRating()
    }
    
    private func setupUI() {
       self.tableView.dataSource = self
       self.tableView.delegate = self
       self.tableView.register(UINib(nibName: "DMRatingTableViewCell", bundle: Bundle.main),
                               forCellReuseIdentifier: "DMRatingTableViewCell")
       self.refreshControl = UIRefreshControl()
       self.refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
       self.refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
       self.tableView.addSubview(self.refreshControl)
    }
    
    @objc private func refresh(sender : UIRefreshControl) {
        renewRating(false)
    }
    
    open func renewRating(_ showActivity: Bool = true) {
        if showActivity {
            showActivityIndicator()
        }
        
        InvestorsDataProvider.default().get()
            .done { respounse in
                self.dismissActivityIndicator()
                self.ratings = respounse.items.sorted(by: {$0.index < $1.index})
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }.ensure {
                self.dismissActivityIndicator()
            }.catch {
                self.showAlertWith($0)
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let companyDetail: RatingsDetailsViewController = storyboard![.RatingsDetails]
        self.navigationController?.pushViewController(companyDetail, animated: true)
        companyDetail.investor = ratings![indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }

    // MARK: UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratings?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = ratings?[indexPath.row],
              let cell = tableView.dequeueReusableCell(withIdentifier: "DMRatingTableViewCell") as? DMRatingTableViewCell else {
            return UITableViewCell()
        }
        
        let isProHidden = indexPath.row > 10
        cell.setupWith(model: model, isProHidden: isProHidden)
        return cell
    }
    
}
