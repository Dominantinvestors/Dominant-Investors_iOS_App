import UIKit

class DMRatingsViewController: DMViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView : UITableView!
    
    var ratings: [InvestorModel]?
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        renewRating()
    }
    
    private func setupUI() {
       self.tableView.dataSource = self
       self.tableView.delegate = self
       self.tableView.register(UINib(nibName: "DMRatingTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DMRatingTableViewCell")
       self.refreshControl = UIRefreshControl()
       self.refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
       self.refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
       self.tableView.addSubview(self.refreshControl)
    }
    
    @objc private func refresh(sender : UIRefreshControl) {
        renewRating()
    }
    
    open func renewRating() {
        showActivityIndicator()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "DMRatingTableViewCell") as! DMRatingTableViewCell
        cell.setupWith(model: ratings![indexPath.row])
        return cell
    }
    
}
