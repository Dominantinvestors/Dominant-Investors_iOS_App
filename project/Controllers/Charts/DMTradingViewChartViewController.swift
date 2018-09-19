//
//  DMTradingViewChartViewController.swift
//  Dominant Investors
//
//  Created by ios_nikitos on 25.09.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit
import WebKit

class DMTradingViewChartViewController: DMViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    var ticker : String!
    
    var isBlack = false
    
    //MARK: ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.ticker!
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var html = ""
        if (isBlack == false) {
            
            html = "<!doctype html><html lang=\"en\"> <head> <meta charset=\"utf-8\"><title>The HTML5 Herald</title> <meta name=\"description\" content=\"The HTML5 Herald\"> <meta name=\"author\" content=\"SitePoint\"><link rel=\"stylesheet\" href=\"css/styles.css?v=1.0\"><!--[if lt IE 9]> <script src=\"https://cdnjs.cloudflare.com/ajax/libs/html5shiv/3.7.3/html5shiv.js\"></script> <![endif]--> </head><body><!-- TradingView Widget BEGIN --> <script type=\"text/javascript\" src=\"https://s3.tradingview.com/tv.js\"></script> <script type=\"text/javascript\"> new TradingView.widget({ \"width\":  \(String(format: "%.2f", self.webView.frame.size.width - 10)), \"height\": \(String(format: "%.2f", self.webView.frame.size.height - 10)), \"symbol\": \"\(self.ticker!)\", \"interval\": \"D\", \"timezone\": \"Etc/UTC\", \"theme\": \"Light\", \"style\": \"0\", \"locale\": \"en\", \"toolbar_bg\": \"#f1f3f6\", \"enable_publishing\": false,  \"save_image\": false, \"hideideas\": true,  \"hide_side_toolbar\": false, \"withdateranges\": true, }); </script> <!-- TradingView Widget END --></body> </html>"
            
        } else {
            self.webView.backgroundColor = UIColor.black
            self.view.backgroundColor = UIColor.black
            
//            html = "<!doctype html><html lang=\"en\"> <head> <meta charset=\"utf-8\"><title>The HTML5 Herald</title> <meta name=\"description\" content=\"The HTML5 Herald\"> <meta name=\"author\" content=\"SitePoint\"><link rel=\"stylesheet\" href=\"css/styles.css?v=1.0\"><!--[if lt IE 9]> <script src=\"https://cdnjs.cloudflare.com/ajax/libs/html5shiv/3.7.3/html5shiv.js\"></script> <![endif]--> </head><body><!-- TradingView Widget BEGIN --> <script type=\"text/javascript\" src=\"https://s3.tradingview.com/tv.js\"></script> <script type=\"text/javascript\"> new TradingView.widget({ \"width\":  \(String(format: "%.2f", self.webView.frame.size.width - 10)), \"height\": \(String(format: "%.2f", self.webView.frame.size.height - 10)), \"symbol\":\"\(self.ticker!)\", \"interval\": \"D\", \"timezone\": \"Etc/UTC\", \"theme\": \"Dark\", \"style\": \"0\", \"locale\": \"ru\", \"toolbar_bg\": \"rgba(0, 0, 0, 1)\", \"enable_publishing\": false, \"hide_top_toolbar\": true, \"save_image\": false, \"hideideas\": true }); </script> <!-- TradingView Widget END --></body></html>"
            
            html = "<!doctype html><html lang=\"en\"> <head> <meta charset=\"utf-8\"><title>The HTML5 Herald</title> <meta name=\"description\" content=\"The HTML5 Herald\"> <meta name=\"author\" content=\"SitePoint\"><link rel=\"stylesheet\" href=\"css/styles.css?v=1.0\"><!--[if lt IE 9]> <script src=\"https://cdnjs.cloudflare.com/ajax/libs/html5shiv/3.7.3/html5shiv.js\"></script> <![endif]--> </head><body bgcolor=\"#E6E6FA\"><!-- TradingView Widget BEGIN --> <div id=\"tv-medium-widget-e495d\"></div> <script type=\"text/javascript\" src=\"https://s3.tradingview.com/tv.js\"></script> <script type=\"text/javascript\"> new TradingView.MediumWidget({ \"container_id\": \"tv-medium-widget-e495d\", \"symbols\": [  [\"\(self.ticker!)\", \"TEST\"] ], \"greyText\": \"Котировки предоставлены\", \"gridLineColor\": \"#e9e9ea\", \"fontColor\": \"#83888D\", \"underLineColor\": \"rgba(66, 66, 66, 1)\", \"trendLineColor\": \"rgba(255, 0, 0, 1)\", \"width\": \(String(format: "%.2f", self.view.frame.size.width)), \"height\": \(String(format: "%.2f", self.view.frame.size.height)), \"locale\": \"en\", \"chartOnly\": true }); </script> <!-- TradingView Widget END --></body></html>"
        }
        
        //self.webView.scrollView.isScrollEnabled = false
        self.webView.loadHTMLString(html, baseURL: nil)
    }
    
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        print("DONE")
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(error.localizedDescription)
    }

}
