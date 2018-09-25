import UIKit

class DMScreenerContainerViewController: DMViewController {
    
    @IBOutlet  weak var screenerContainer : UIView!
    @IBOutlet  weak var cryptoContainer   : UIView!

    @IBOutlet weak var segmentControll: SegmentControll!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setUpSegmentControll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "stockChart" || segue.identifier == "cryptoChart" {
            if let screenerContainer = segue.destination as? DMScreenerTypeViewController {
                screenerContainer.parentContainer = self
            }
        }
    }
    
    fileprivate func setUpSegmentControll() {
        segmentControll.setLeft(NSLocalizedString("STOCK SCREENER", comment: ""))
        segmentControll.setRight(NSLocalizedString("CRYPTO SCREENER", comment: ""))
        
        segmentControll.selector = { index in
            if index == 0 {
                self.showScrenner()
            } else {
                self.showCryptoScreener()
            }
        }
    }

    //MARK: Open
    
    open func showChart(chartVC : DMTradingViewChartViewController) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.white
        ]
        navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 16/255, green: 18/255, blue: 26/255, alpha: 1)
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        self.navigationController?.pushViewController(chartVC, animated: true)
    }
    
    //MARK: Private
    
    fileprivate func setupUI() {
        self.screenerContainer.alpha = 1
        self.cryptoContainer.alpha = 0
        self.cryptoContainer.isHidden = true
    }
    
    fileprivate func showScrenner() {
        UIView.animate(withDuration: 0.3, animations: {
            self.screenerContainer.alpha = 1
            self.cryptoContainer.alpha = 0
        }) { (completed) in
            self.screenerContainer.isHidden = false
            self.cryptoContainer.isHidden = true
        }
    }
    
    fileprivate func showCryptoScreener() {
        UIView.animate(withDuration: 0.3, animations: {
            self.screenerContainer.alpha = 0
            self.cryptoContainer.alpha = 1
        }) { (completed) in
            self.screenerContainer.isHidden = true
            self.cryptoContainer.isHidden = false
        }
    }
}
