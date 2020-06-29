import UIKit
import NVActivityIndicatorView

class ChartTableViewCell: UITableViewCell {
    
    var company: Company! {
        didSet {
            loadChart()
            loadChartWithRange(range: .OneDay)
        }
    }
    
    var chartView: ChartView!
    var chart: SwiftStockChart!
    
    var items: [ChartPoint] = []
    
    private func loadChart() {
        chartView = ChartView.create()
        chartView.delegate = self
        
        chartView.frame = CGRect(x: 24,
                                 y: 10,
                                 width: UIScreen.main.bounds.width - 48,
                                 height: frame.height - 20)
        addSubview(chartView)
        
        chart = SwiftStockChart(frame: CGRect(x : 16,
                                              y :  0,
                                              width : UIScreen.main.bounds.width - 60,
                                              height : frame.height - 100))
        
        chartView.backgroundColor = UIColor.clear
        
        chart.axisColor = UIColor.red
        chart.verticalGridStep = 3
        
        chartView.addSubview(chart)
        chartView.backgroundColor = UIColor.black
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
        
        if self.company.isCrypto() {
            rangeChangeForCrypto(range: range)
        } else {
            rangeChangeForCompany(range: range)
        }
    }
    
    func rangeChangeForCompany(range: ChartTimeRange) {
        showActivityIndicator()
        SwiftStockKit.fetchChartPoints(symbol: self.company.ticker,
                                       range: range,
                                       crypto: self.company.isCrypto())
        { (chartPoints) -> () in
            self.dismissActivityIndicator()
            self.chart.clearChartData()
            self.chart.setChartPoints(points: chartPoints)
        }
    }
    
    func rangeChangeForCrypto(range: ChartTimeRange) {
        let endDate = Date()
        var startDate: Date
        
        switch (range) {
        case .OneDay:
            startDate = endDate.adjust(.day, offset: -1)
        case .FiveDays:
            startDate = endDate.adjust(.day, offset: -5)
        case .TenDays:
            startDate = endDate.adjust(.day, offset: -10)
        case .OneMonth:
            startDate = endDate.adjust(.month, offset: -1)
        case .ThreeMonths:
            startDate = endDate.adjust(.month, offset: -3)
        case .OneYear:
            startDate = endDate.adjust(.year, offset: -1)
        case .FiveYears:
            startDate = endDate.adjust(.year, offset: -5)
        }
        
        if !self.items.isEmpty {
            self.filter(fot: startDate.timeIntervalSince1970)
        } else {
            showActivityIndicator()
            CryptoCompareDataProvider.default().get(for: self.company.ticker) { points, error in
                self.dismissActivityIndicator()
                if let points = points {
                    self.items = points
                    self.filter(fot: startDate.timeIntervalSince1970)
                }
            }
        }
    }
    
    open func showActivityIndicator() {
        let activityData = ActivityData()

        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
     }
     
     open func dismissActivityIndicator() {
         NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
     }
    
    func filter(fot date: Double)  {
        let points = self.items.filter({ TimeInterval( $0.timeStamp ?? 0.0) > date})
        self.chart.clearChartData()
        self.chart.setChartPoints(points: points)
    }
}

extension ChartTableViewCell: ChartViewDelegate {
    
    func didChangeTimeRange(range: ChartTimeRange) {
        loadChartWithRange(range: range)
    }
}
