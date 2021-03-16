import UIKit
import WebKit

class DMTradingViewChartViewController: DMViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    var ticker: String!
    var isBlack = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.ticker!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var html = ""
        if isBlack == false {
            html = "<!-- TradingView Widget BEGIN --> <meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0\"><div class=\"tradingview-widget-container\"><div id=\"tradingview_96d90\"></div><div class=\"tradingview-widget-copyright\"><a href=\"https://www.tradingview.com/symbols/NASDAQ-AAPL/\" rel=\"noopener\" target=\"_blank\"><span class=\"blue-text\">AAPL Chart</span></a> by TradingView</div><script type=\"text/javascript\" src=\"https://s3.tradingview.com/tv.js\"></script><script type=\"text/javascript\">new TradingView.widget({\"width\": \"\(Int(self.webView.frame.size.width - 15))\", \"height\": \"\(Int(self.webView.frame.size.height + 15))\", \"symbol\": \"\(self.ticker!)\",\"interval\": \"D\",\"timezone\": \"Etc/UTC\",\"theme\": \"light\",\"style\": \"1\",\"locale\": \"en\",\"toolbar_bg\": \"#f1f3f6\",\"enable_publishing\": false,\"allow_symbol_change\": true,\"container_id\": \"tradingview_96d90\"});</script></div><!-- TradingView Widget END -->"
            
        } else {
            self.webView.backgroundColor = UIColor.black
            self.view.backgroundColor = UIColor.black
            
            html = "<!doctype html><html lang=\"en\">  <meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0\"> <head> <meta charset=\"utf-8\"><title>The HTML5 Herald</title> <meta name=\"description\" content=\"The HTML5 Herald\"> <meta name=\"author\" content=\"SitePoint\"><link rel=\"stylesheet\" href=\"css/styles.css?v=1.0\"><!--[if lt IE 9]> <script src=\"https://cdnjs.cloudflare.com/ajax/libs/html5shiv/3.7.3/html5shiv.js\"></script> <![endif]--> </head><body bgcolor=\"#E6E6FA\"><!-- TradingView Widget BEGIN --> <div id=\"tv-medium-widget-e495d\"></div> <script type=\"text/javascript\" src=\"https://s3.tradingview.com/tv.js\"></script> <script type=\"text/javascript\"> new TradingView.MediumWidget({ \"container_id\": \"tv-medium-widget-e495d\", \"symbols\": [  [\"\(self.ticker!)\", \"TEST\"] ], \"greyText\": \"Котировки предоставлены\", \"gridLineColor\": \"#e9e9ea\", \"fontColor\": \"#83888D\", \"underLineColor\": \"rgba(66, 66, 66, 1)\", \"trendLineColor\": \"rgba(255, 0, 0, 1)\",\"width\": \"\(Int(self.webView.frame.size.width - 15))\", \"height\": \"\(Int(self.webView.frame.size.height + 15))\", \"locale\": \"en\", \"chartOnly\": true }); </script> <!-- TradingView Widget END --></body></html>"
        }
        
        //self.webView.scrollView.isScrollEnabled = false
        self.webView.loadHTMLString(html, baseURL: nil)
    }

}
