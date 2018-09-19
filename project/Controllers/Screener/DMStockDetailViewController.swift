//
//  DMStockDetailDMStockDetailViewController.swift
//  Dominant
//
//  Created by n.agoshkov on 08/07/2016.
//  Copyright 2016 Agoshkov_Personal. All rights reserved.
//

import UIKit

class DMStockDetailViewController: DMViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, ChartViewDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var viewOfChart    : UIView!
    
    var stockSymbol : String = String()
    var stock       : Stock?
    var chartView   : ChartView!
    var chart       : SwiftStockChart!

    
    // MARK: <UIViewController>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self

        setupUI()
        setupChart()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        for view in self.viewOfChart.subviews {
            view.removeFromSuperview()
        }
        coordinator.animate(alongsideTransition: { context in
            context.viewController(forKey: UITransitionContextViewControllerKey.from)
        }, completion: { context in
            self.setupChart()
        })
    }
    
    // MARK: Actions
    
    @IBAction func backButtonClicked (sender : UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Private
    
    private func setupUI() {
      
        navigationItem.title = stockSymbol
     
        collectionView.register(UINib(nibName: "DMStockInfoCell", bundle: Bundle.main), forCellWithReuseIdentifier: "DMStockInfoCell")
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)

        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
 
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    // MARK: ChartView
    
    private func setupChart() {
        chartView = ChartView.create()
        chartView.delegate = self
        chartView?.frame = CGRect(x: 24, y: 0, width: self.viewOfChart.frame.width-48, height: self.viewOfChart.frame.height)
        viewOfChart?.addSubview(chartView!)
        
        chart = SwiftStockChart(frame: CGRect(x : 16, y :  10, width : self.viewOfChart.bounds.size.width - 60, height : viewOfChart.frame.height - 80))
        
        loadChartWithRange(range: .OneDay)
        
        SwiftStockKit.fetchStockForSymbol(symbol: stockSymbol) { (stock) -> () in
            self.stock = stock
            self.collectionView.reloadData()
        }
        
        chart.fillColor = UIColor.clear
        chart.verticalGridStep = 3
        chartView.addSubview(chart)
    }
    
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
        
        SwiftStockKit.fetchChartPoints(symbol: stockSymbol, range: range, crypto : false) { (chartPoints) -> () in
            self.chart.clearChartData()
            self.chart.setChartPoints(points: chartPoints)
        }
    }
    
    // MARK: ChartViewDelegate
    
    func didChangeTimeRange(range: ChartTimeRange) {
        loadChartWithRange(range: range)
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.stock!.dataFields.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DMStockInfoCell", for: indexPath as IndexPath) as! DMStockInfoCell
        cell.setData(data: stock!.dataFields[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: (UIScreen.main.bounds.size.width/2), height: 44)
    }
    
}
