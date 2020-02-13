//
//  DMEstimazeChartViewController.swift
//  Dominant Investors
//
//  Created by ios_nikitos on 19.11.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import WebKit
import AlamofireImage

class DMEstimazeChartViewController: DMViewController, WKNavigationDelegate, UIScrollViewDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var webimageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var estimazeImageURL : URL!
    var ticker : String!
    
    //MARK: ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        self.navigationItem.title = self.ticker!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.webimageView.contentMode = .scaleAspectFit
        if let urlLink = self.estimazeImageURL {
            self.webimageView.af_setImage(withURL: urlLink)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    //MARK: UIWebViewDelegate
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        let bodyStyleVertical = "document.getElementsByTagName('body')[0].style.verticalAlign = 'middle';";
        let bodyStyleHorizontal = "document.getElementsByTagName('body')[0].style.textAlign = 'center';";
        let mapStyle = "document.getElementById('mapid').style.margin = 'auto';";
        
        webView.evaluateJavaScript(bodyStyleVertical, completionHandler: nil)
        webView.evaluateJavaScript(bodyStyleHorizontal, completionHandler: nil)
        webView.evaluateJavaScript(mapStyle, completionHandler: nil)
    }
    
    //MARK: UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return self.webimageView
    }

}
