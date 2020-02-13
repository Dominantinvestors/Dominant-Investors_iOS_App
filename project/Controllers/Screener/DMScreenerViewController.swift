import UIKit

class DMScreenerViewController: DMScreenerTypeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTradingViewScreener()
    }
    
    fileprivate func loadTradingViewScreener() {
      
        if (self.tickerLoaded == false) {
            self.showActivityIndicator()
            self.webView.navigationDelegate = self
            let HTMLString = String(format : "<!-- TradingView Widget BEGIN --> <span id=\"tradingview-copyright\"><a ref=\"nofollow noopener\" target=\"_blank\" href=\"http://www.tradingview.com\" style=\"color: rgb(173, 174, 176); font-family: &quot;Trebuchet MS&quot;, Tahoma, Arial, sans-serif; font-size: 13px;\">Stock Screener by <span style=\"color: #3BB3E4\">TradingView</span></a></span> <script src=\"https://s3.tradingview.com/external-embedding/embed-widget-screener.js\">{ \"width\": \"\(Int(self.webView.frame.size.width))\", \"height\": \"\(Int(self.webView.frame.size.height))\", \"defaultColumn\": \"overview\", \"defaultScreen\": \"most_capitalized\", \"market\": \"america\", \"showToolbar\": true, \"locale\": \"en\" }</script> <!-- TradingView Widget END -->")
            
            self.webView.loadHTMLString(HTMLString, baseURL: nil)
            self.webView.sizeToFit()
            self.webView.scrollView.bounces = false
            self.tickerLoaded = true
        }
    }
        
}

class MoreViewController: DMScreenerTypeViewController {
    
    var ticker: String!
    var HTMLString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ticker
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTradingViewScreener()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    fileprivate func loadTradingViewScreener() {
        self.showActivityIndicator()
        self.webView.navigationDelegate = self
        self.webView.loadHTMLString(HTMLString, baseURL: nil)
        self.webView.sizeToFit()
        self.webView.scrollView.bounces = false
        self.tickerLoaded = true
    }
    
}
