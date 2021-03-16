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
           let HTMLString = "<!-- TradingView Widget BEGIN --><meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0\"><div class=\"tradingview-widget-container\"><div class=\"tradingview-widget-container__widget\"></div><div class=\"tradingview-widget-copyright\"><a href=\"https://www.tradingview.com/screener/\" rel=\"noopener\" target=\"_blank\"><span class=\"blue-text\">Stock Screener</span></a> by TradingView</div><script type=\"text/javascript\" src=\"https://s3.tradingview.com/external-embedding/embed-widget-screener.js\" async>{\"width\": \"\(Int(self.webView.frame.size.width - 15))\",\"height\": \"\(Int(self.webView.frame.size.height + 15))\",\"defaultColumn\": \"oscillators\",\"defaultScreen\": \"most_capitalized\",\"market\": \"america\",\"showToolbar\": false,\"colorTheme\": \"light\",\"locale\": \"en\"}</script></div><!-- TradingView Widget END -->"
            self.webView.loadHTMLString(HTMLString, baseURL: nil)
            self.webView.sizeToFit()
            self.webView.scrollView.bounces = false
            self.tickerLoaded = true
        }
    }
        
}

class MoreViewController: DMScreenerTypeViewController {
    
    var ticker: String!
    var isAnalyze: Bool = false
    private(set) var HTMLString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ticker
        
        if isAnalyze {
            HTMLString = "<!-- TradingView Widget BEGIN --><meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0\"> <div class=\"tradingview-widget-container\"><div class=\"tradingview-widget-container__widget\"></div><div class=\"tradingview-widget-copyright\"><a href=\"https://www.tradingview.com/symbols/NASDAQ-AAPL/technicals/\"rel=\"noopener\" target=\"_blank\"><span class=\"blue-text\">Technical Analysis for AAPL</span></a> by TradingView</div><script type=\"text/javascript\" src=\"https://s3.tradingview.com/external-embedding/embed-widget-technical-analysis.js\" async>{\"interval\": \"1m\",\"width\": \"\(Int(self.webView.frame.size.width - 15))\",\"isTransparent\": false,\"height\": \"\(Int(self.webView.frame.size.height + 15))\",\"symbol\": \"\(ticker!)\",\"showIntervalTabs\": true,\"locale\": \"en\",\"colorTheme\": \"light\"}</script></div><!-- TradingView Widget END -->"
        } else {
            HTMLString = "<!-- TradingView Widget BEGIN --> <meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0\"><div class=\"tradingview-widget-container\"><div id=\"tradingview_96d90\"></div><div class=\"tradingview-widget-copyright\"><a href=\"https://www.tradingview.com/symbols/NASDAQ-AAPL/\" rel=\"noopener\" target=\"_blank\"><span class=\"blue-text\">AAPL Chart</span></a> by TradingView</div><script type=\"text/javascript\" src=\"https://s3.tradingview.com/tv.js\"></script><script type=\"text/javascript\">new TradingView.widget({\"width\": \"\(Int(self.webView.frame.size.width - 15))\", \"height\": \"\(Int(self.webView.frame.size.height + 15))\", \"symbol\": \"\(self.ticker!)\",\"interval\": \"D\",\"timezone\": \"Etc/UTC\",\"theme\": \"light\",\"style\": \"1\",\"locale\": \"en\",\"toolbar_bg\": \"#f1f3f6\",\"enable_publishing\": false,\"allow_symbol_change\": true,\"container_id\": \"tradingview_96d90\"});</script></div><!-- TradingView Widget END -->"
        }
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
