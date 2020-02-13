import WebKit

class DMScreenerTypeViewController: DMViewController, WKNavigationDelegate {
    
    @IBOutlet  weak var webView : WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    var tickerLoaded = false
    
    var parentContainer : DMScreenerContainerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    open func openChartFor(ticker : String) {
        
        let storyboard = UIStoryboard.init(name: "OutsourceCharts", bundle: nil)
        if let chartVC = storyboard.instantiateViewController(withIdentifier: "DMTradingViewChartViewController") as? DMTradingViewChartViewController {
            chartVC.ticker = ticker
            if let parent = self.parentContainer {
                parent.navigationController?.pushViewController(chartVC, animated: true)
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        let request = navigationAction.request
        
        if request.url?.absoluteString.contains("https://www.tradingview.com/?utm_campaign=screener&utm_medium=widget&utm_source=") == true {
                   decisionHandler(.cancel)
               }
               if request.url?.absoluteString.contains("https://www.tradingview.com/?utm_campaign=cryptoscreener&utm_medium=widget&utm_source=") == true {
                   decisionHandler(.cancel)
               }
               
               if request.url?.absoluteString.contains("symbols") == true {
                   if let ticker = request.url?.lastPathComponent {
                       if ticker.contains("-") {
                           let token = ticker.components(separatedBy: "-")
                           if token.count >= 2 {
                               self.openChartFor(ticker: token[1])
                           } else {
                               self.openChartFor(ticker: ticker)
                               decisionHandler(.cancel)
                           }
                       } else {
                           self.openChartFor(ticker: ticker)
                       }
                   }
                   decisionHandler(.cancel)

               }
        
          decisionHandler(.allow)
      }

      func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            self.dismissActivityIndicator()

          let bodyStyleVertical = "document.getElementsByTagName('body')[0].style.verticalAlign = 'middle';";
          let bodyStyleHorizontal = "document.getElementsByTagName('body')[0].style.textAlign = 'center';";
          let mapStyle = "document.getElementById('mapid').style.margin = 'auto';";
          
          webView.evaluateJavaScript(bodyStyleVertical, completionHandler: nil)
          webView.evaluateJavaScript(bodyStyleHorizontal, completionHandler: nil)
          webView.evaluateJavaScript(mapStyle, completionHandler: nil)
      }
}
