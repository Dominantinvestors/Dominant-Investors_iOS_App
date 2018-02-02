//
//  DMCompanyDetailViewController.swift
//  Dominant Investors
//
//  Created by Nekit on 19.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit
import Alamofire

class DMCompanyDetailViewController: DMViewController, ChartViewDelegate, UIWebViewDelegate {

    var company   : DMCompanyModel!
    var chartView : ChartView? = nil
    var chart     : SwiftStockChart!
    
    // MARK: Outlets
    @IBOutlet weak var infoLabel                : UILabel!
    
    @IBOutlet weak var companyNameLabel         : UILabel!
    
    @IBOutlet weak var revenueEstimizeButton    : UIButton!
    @IBOutlet weak var epsEstimizeButton        : UIButton!
    @IBOutlet weak var tradingViewButton        : UIButton!
    
    @IBOutlet weak var companyLogo              : UIImageView!
    @IBOutlet weak var chartContainer           : UIView!
    
    @IBOutlet weak var statsContainer           : DMStatsContainer!
    @IBOutlet weak var tradingViewContainer     : UIView!
    @IBOutlet weak var cryptoContainer          : DMCryptoInfoContainer!
    @IBOutlet weak var buttonsContainer         : UIView!
    @IBOutlet weak var buttonsContainerHeight   : NSLayoutConstraint!
    @IBOutlet weak var chartContainerHeight     : NSLayoutConstraint!
    
    @IBOutlet weak var buyPointLabel            : UILabel!
    @IBOutlet weak var growthPotential          : UILabel!
    @IBOutlet weak var stopLoss                 : UILabel!
    @IBOutlet weak var investmentPeriod         : UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadChart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let chartVC = segue.destination as? DMTradingViewChartViewController {
            chartVC.ticker = self.company.tradingViewTicker
            chartVC.isBlack = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        for view in self.chartContainer.subviews {
            view.removeFromSuperview()
        }
        coordinator.animate(alongsideTransition: { context in
            context.viewController(forKey: UITransitionContextViewControllerKey.from)
        }, completion: { context in
            self.loadChart()
        })
    }
    
    // MARK: Private
    
    private func setupUI() {
        self.infoLabel.text        = self.company!.companyDescription
        self.companyLogo.image     = UIImage()
        self.companyNameLabel.text = self.company.name
        
        self.statsContainer.setupWithCompany(company: self.company)
        self.cryptoContainer.setupWithCompany(company: self.company)
        
        if self.company.estimazeURL == nil {
            self.revenueEstimizeButton.isEnabled = false
            self.revenueEstimizeButton.alpha = 0.5
        }
        
        if self.company.estimaze_EPS_URL == nil {
            self.epsEstimizeButton.isEnabled = false
            self.epsEstimizeButton.alpha = 0.5
        }

        fillCompanyData()
        
        self.revenueEstimizeButton.layer.cornerRadius = 25.0
        self.revenueEstimizeButton.layer.borderColor = UIColor.red.cgColor
        self.revenueEstimizeButton.layer.borderWidth = 1.0
        
        self.epsEstimizeButton.layer.cornerRadius = 25.0
        self.epsEstimizeButton.layer.borderColor = UIColor.red.cgColor
        self.epsEstimizeButton.layer.borderWidth = 1.0
    }
    
    private func fillCompanyData() {
        
        if (self.company.isCrypto == true) {
            self.cryptoContainer.isHidden = false
            self.statsContainer.isHidden = true
            self.buttonsContainer.isHidden = true
            self.buttonsContainerHeight.constant = 0
            self.chartContainerHeight.setMultiplier(multiplier: 0)
        } else {
            self.cryptoContainer.isHidden = true
            self.statsContainer.isHidden = false
            self.buttonsContainer.isHidden = false
            self.buttonsContainerHeight.constant = 80
            self.chartContainerHeight.setMultiplier(multiplier: 0.25)
        }
        
        DMAPIService.sharedInstance.downloadCompanyLogoWith(ID: company.id) { (image) in
            DispatchQueue.main.async {
                self.companyLogo.image = image
            }
        }
        
        self.buyPointLabel.text = self.company.buyPoint.replacingOccurrences(of: ",", with: ".")
        self.growthPotential.text = self.company.potentialProfitability.replacingOccurrences(of: ",", with: ".")
        self.stopLoss.text = self.company.stopLoss.replacingOccurrences(of: ",", with: ".")
        self.investmentPeriod.text = self.company.investmentHorizon.replacingOccurrences(of: ",", with: ".")
    }
    
    
    private func loadChart() {
        
        if self.company.isCrypto == false {
            self.tradingViewContainer.isHidden = true
            chartView = ChartView.create()
            chartView?.delegate = self
            chartView?.frame = CGRect(x: 24, y: 0, width: self.chartContainer.frame.width-48, height: self.chartContainer.frame.height)
            chartContainer?.addSubview(chartView!)
            
            chart = SwiftStockChart(frame: CGRect(x : 16, y :  10, width : self.chartContainer.bounds.size.width - 60, height : chartContainer.frame.height - 80))
            
            chartView?.backgroundColor = UIColor.clear
            
            chart.axisColor = UIColor.red
            chart.verticalGridStep = 3
            
            loadChartWithRange(range: .OneDay)
            
            chartView?.addSubview(chart)
            chartView?.backgroundColor = UIColor.black
            
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        } else {
            self.tradingViewContainer.isHidden = false
        }
    
}
    
    
    // MARK: ChartViewDelegate
    
    func loadChartWithRange(range: ChartTimeRange) {
        
        chart.timeRange = range
        
        let times = chart.timeLabelsForTimeFrame(range: range)
        chart.horizontalGridStep = times.count - 1
        
        chart.labelForIndex = {(index: NSInteger) -> String in
            return times[index]
        }
        
        chart.labelForValue = {(value: CGFloat) -> String in
            return String(format: "%.02f", value)
        }
        
        
        SwiftStockKit.fetchChartPoints(symbol: self.company.ticker, range: range, crypto: self.company.isCrypto) { (chartPoints) -> () in
            self.chart.clearChartData()
            self.chart.setChartPoints(points: chartPoints)
        }
    }
    
    func didChangeTimeRange(range: ChartTimeRange) {
        loadChartWithRange(range: range)
    }

    // MARK: Actions
    
    @IBAction func showSignals(sender : UIButton) {
        self.performSegue(withIdentifier: "DMSignalsSegue", sender: self)
    }
    
    @IBAction func backButtonAction(sender : UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func estimazeButtonPressed(sender : UIButton) {
        guard let estimazeURL = self.company.estimazeURL else { return }
        
       
        let storyboard = UIStoryboard.init(name: "OutsourceCharts", bundle: nil)
        if let chartVC = storyboard.instantiateViewController(withIdentifier: "DMEstimazeChartViewController") as? DMEstimazeChartViewController {
            chartVC.estimazeImageURL = estimazeURL
            chartVC.ticker = self.company.ticker
            self.showChart(chart: chartVC)
        }
    }
    
    @IBAction func EPSestimazeButtonPressed(sender : UIButton) {
        guard let estimazeURL = self.company.estimaze_EPS_URL else { return }
        
        
        let storyboard = UIStoryboard.init(name: "OutsourceCharts", bundle: nil)
        if let chartVC = storyboard.instantiateViewController(withIdentifier: "DMEstimazeChartViewController") as? DMEstimazeChartViewController {
            chartVC.estimazeImageURL = estimazeURL
            chartVC.ticker = self.company.ticker
            self.showChart(chart: chartVC)
        }
    }
    
    @IBAction func tradingViewChartButtonPressed(sender : UIButton) {
        let storyboard = UIStoryboard.init(name: "OutsourceCharts", bundle: nil)
        if let chartVC = storyboard.instantiateViewController(withIdentifier: "DMTradingViewChartViewController") as? DMTradingViewChartViewController {
            chartVC.ticker = self.company.tradingViewTicker
            self.showChart(chart: chartVC)
        }
    }
    
    fileprivate func showChart(chart : UIViewController) {
        
        self.navigationController?.pushViewController(chart, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let backItem = UIBarButtonItem()
            backItem.title = ""
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.white
        ]
        navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 16/255, green: 18/255, blue: 26/255, alpha: 1)
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
    }

}




