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
