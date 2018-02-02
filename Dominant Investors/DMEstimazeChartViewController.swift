//
//  DMEstimazeChartViewController.swift
//  Dominant Investors
//
//  Created by ios_nikitos on 19.11.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit
import AlamofireImage

class DMEstimazeChartViewController: DMViewController, UIWebViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var webView: UIWebView!
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.webimageView.contentMode = .scaleAspectFit
        if let urlLink = self.estimazeImageURL {
            self.webimageView.af_setImage(withURL: urlLink)
        }
    }
    
    //MARK: UIWebViewDelegate
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        webView.scalesPageToFit = true
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let bodyStyleVertical = "document.getElementsByTagName('body')[0].style.verticalAlign = 'middle';";
        let bodyStyleHorizontal = "document.getElementsByTagName('body')[0].style.textAlign = 'center';";
        let mapStyle = "document.getElementById('mapid').style.margin = 'auto';";
        
        self.webView.stringByEvaluatingJavaScript(from: bodyStyleVertical)
        self.webView.stringByEvaluatingJavaScript(from: bodyStyleHorizontal)
        self.webView.stringByEvaluatingJavaScript(from: mapStyle)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(error.localizedDescription)
    }
    
    //MARK: UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return self.webimageView
    }

}
