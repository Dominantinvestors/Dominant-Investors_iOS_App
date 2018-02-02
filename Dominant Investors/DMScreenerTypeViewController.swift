//
//  DMScreenerTypeViewController.swift
//  Dominant Investors
//
//  Created by ios_nikitos on 21.11.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit

class DMScreenerTypeViewController: DMViewController, UIWebViewDelegate {

    //MARK: Outlets
    
    @IBOutlet  weak var webView : UIWebView!
    
    var tickerLoaded = false
    
    //MARK: Properties
    
    var parentContainer : DMScreenerContainerViewController!
    
    //MARK: ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Open
    
    open func openChartFor(ticker : String) {
        
        let storyboard = UIStoryboard.init(name: "OutsourceCharts", bundle: nil)
        if let chartVC = storyboard.instantiateViewController(withIdentifier: "DMTradingViewChartViewController") as? DMTradingViewChartViewController {
            chartVC.ticker = ticker
            if let parent = self.parentContainer {
                parent.showChart(chartVC: chartVC)
            }
        }
    }
    
    //MARK: UIWebViewDelegate
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.url?.absoluteString.contains("symbols") == true {
            if let ticker = request.url?.lastPathComponent {
                if ticker.contains("-") {
                    var token = ticker.components(separatedBy: "-")
                    if token.count >= 2 {
                        self.openChartFor(ticker: token[1])
                    } else {
                        self.openChartFor(ticker: ticker)
                        return false
                    }
                } else {
                    self.openChartFor(ticker: ticker)
                }
            }
            return false
        }
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.dismissActivityIndicator()
        let bodyStyleVertical = "document.getElementsByTagName('body')[0].style.verticalAlign = 'middle';";
        let bodyStyleHorizontal = "document.getElementsByTagName('body')[0].style.textAlign = 'center';";
        let mapStyle = "document.getElementById('mapid').style.margin = 'auto';";
        
        self.webView.stringByEvaluatingJavaScript(from: bodyStyleVertical)
        self.webView.stringByEvaluatingJavaScript(from: bodyStyleHorizontal)
        self.webView.stringByEvaluatingJavaScript(from: mapStyle)
        
    }
    
}
