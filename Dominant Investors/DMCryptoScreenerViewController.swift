//
//  DMCryptoScreenerViewController.swift
//  Dominant Investors
//
//  Created by ios_nikitos on 21.11.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit

class DMCryptoScreenerViewController: DMScreenerTypeViewController  {

    //MARK : ViewVController
    
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
            self.webView.delegate = self
            let HTMLString = String(format : "<!-- TradingView Widget BEGIN --> <span id=\"tradingview-copyright\"><a ref=\"nofollow noopener\" target=\"_blank\" href=\"http://www.tradingview.com\" style=\"color: rgb(173, 174, 176); font-family: &quot;Trebuchet MS&quot;, Tahoma, Arial, sans-serif; font-size: 13px;\">Cryptocurrencies Screener by <span style=\"color: #3BB3E4\">TradingView</span></a></span> <script src=\"https://s3.tradingview.com/external-embedding/embed-widget-screener.js\">{ \"width\": \"\(Int(self.webView.frame.size.width))\", \"height\": \"\(Int(self.webView.frame.size.height))\", \"defaultColumn\": \"performance\", \"defaultScreen\": \"top_gainers\", \"market\": \"crypto\", \"showToolbar\": true, \"locale\": \"en\" }</script> <!-- TradingView Widget END -->")
            
            
            
            self.webView.loadHTMLString(HTMLString, baseURL: nil)
            self.webView.sizeToFit()
            self.webView.scrollView.bounces = false
            self.tickerLoaded = true
        }
    }
    
    

}
