//
//  DMViewController.swift
//  Dominant Investors
//
//  Created by Nekit on 18.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit
import Alamofire

struct StockSearchResult {
    var symbol: String?
    var name: String?
    var exchange: String?
    var assetType: String?
}

class Stock: NSObject {
    var dataFields: [[String : String]] = [[String : String]]()
    var symbol: String?
}

//class Stock2 : NSObject {
//    
//    var ask: String?
//    var averageDailyVolume: String?
//    var bid: String?
//    var bookValue: String?
//    var changeNumeric: String?
//    var changePercent: String?
//    var dayHigh: String?
//    var dayLow: String?
//    var dividendShare: String?
//    var dividendYield: String?
//    var ebitda: String?
//    var epsEstimateCurrentYear: String?
//    var epsEstimateNextQtr: String?
//    var epsEstimateNextYr: String?
//    var eps: String?
//    var fiftydayMovingAverage: String?
//    var lastTradeDate: String?
//    var last: String?
//    var lastTradeTime: String?
//    var marketCap: String?
//    var companyName: String?
//    var oneYearTarget: String?
//    var open: String?
//    var pegRatio: String?
//    var peRatio: String?
//    var previousClose: String?
//    var priceBook: String?
//    var priceSales: String?
//    var shortRatio: String?
//    var stockExchange: String?
//    var symbol: String?
//    var twoHundreddayMovingAverage: String?
//    var volume: String?
//    var yearHigh: String?
//    var yearLow: String?
//    
//    var dataFields: [[String : String]]
//    
//}

struct ChartPoint {
    var date: Date?
    var volume: Int?
    var open: CGFloat?
    var close: CGFloat?
    var low: CGFloat?
    var high: CGFloat?

}

enum ChartTimeRange {
    case OneDay, FiveDays, TenDays, OneMonth, ThreeMonths, OneYear, FiveYears
}



class SwiftStockKit {
    
    class func fetchStocksFromSearchTerm(term: String, completion:@escaping (_ stockInfoArray: [StockSearchResult]) -> ()) {
        

        DispatchQueue.global(qos: .default).async {
            
            let searchURL = "http://d.yimg.com/aq/autoc"
            
            let params = ["query":term, "region":"US", "lang":"en-US"]
            
            Alamofire.request(searchURL, method: .get, parameters: params, headers : nil).responseJSON { (response) in
           
                if let resultJSON = response.result.value as? [String : AnyObject]  {
                    
                    if let jsonArray1 = resultJSON["ResultSet"] as? [String : AnyObject] {
                        
                        if let jsonArray2 = jsonArray1["Result"] as? [[String : String]]
                        {
                            var stockInfoArray = [StockSearchResult]()
                            for dictionary in jsonArray2 {
                                stockInfoArray.append(StockSearchResult(symbol: dictionary["symbol"], name: dictionary["name"], exchange: dictionary["exchDisp"], assetType: dictionary["typeDisp"]))
                                
                                
                                DispatchQueue.main.async {
                                    completion(stockInfoArray)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    class func fetchCurrentPriceForSymbol(symbol: String, completion:@escaping (_ last: [String : AnyObject]) -> ()) {
        
        var newSymbol = symbol
        DispatchQueue.global(qos: .default).async {
            newSymbol = newSymbol.replacingOccurrences(of: "\"", with: "%22")
            newSymbol = newSymbol.replacingOccurrences(of: " ", with: "")
            
            if (newSymbol.length > 0) {
                newSymbol = newSymbol.substring(to: newSymbol.endIndex)
                newSymbol = newSymbol.substring(from: newSymbol.startIndex)
            }
            let stockURL = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(\(newSymbol))&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&format=json&diagnostics=true"
            
            
            Alamofire.request(stockURL, method: .get, parameters: nil, headers : nil).responseJSON { (response) in
     
                if (response.result.value != nil) {
                    if let resultJSON = response.result.value as? [String : AnyObject]  {
                        
                        if let data1 = resultJSON["query"] as? [String : AnyObject] {
                            
                            if let data2 = data1["results"] as? [String : AnyObject]  {
                                
                                if let stockData = data2["quote"] as? [[String : AnyObject]] {
                                    var answerDict = [String : AnyObject]()
                                    for gettinStock in stockData {
                                        let keytring = gettinStock["symbol"] as! String
                                        let key = keytring
                                        let valueDoule = gettinStock["LastTradePriceOnly"]?.doubleValue
                                        let exch = gettinStock["StockExchange"] as! String
                                        let nKey = key.appending("exch")
                                        answerDict[nKey] = exch as AnyObject?
                                        answerDict[key] = valueDoule as AnyObject?
                                    }
                                    completion(answerDict)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    class func fetchStockForSymbol(symbol: String, completion:@escaping (_ stock: Stock) -> ()) {
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            
            let stockURL = self.chartUrlForStocks(symbols: [symbol])
            
            Alamofire.request(stockURL).responseJSON { response in
                
                if let resultJSON = response.result.value as? [String : AnyObject]  {
                    
                    if let stockDataArray = resultJSON["results"] as? [[String : AnyObject]] {
                        let stockData = stockDataArray.first!
                        // lengthy creation, yeah
                        var newDataFields = [[String : String]]()
                        
                        newDataFields.append(["Symbol" : stockData["symbol"] as? String ?? "N/A"])
                        newDataFields.append(["Percent Change" : String(describing: stockData["percentChange"] as! CGFloat) ?? "N/A"])
                        newDataFields.append(["Stock Exchange" : stockData["exchange"] as? String ?? "N/A"])
                        newDataFields.append(["Net Change" : String(describing: stockData["netChange"] as! CGFloat) ?? "N/A"])
                        newDataFields.append(["Name" : stockData["name"] as? String ?? "N/A"])
                        newDataFields.append(["Unit Code" : stockData["unitCode"] as? String ?? "N/A"])
                        newDataFields.append(["Open price" : String(describing: stockData["open"] as! CGFloat) ?? "N/A"])
                        newDataFields.append(["Last Price" : String(describing: stockData["lastPrice"] as! CGFloat) ?? "N/A"])
                        newDataFields.append(["Volume" : String(describing: stockData["volume"] as! CGFloat) ?? "N/A"])
                        newDataFields.append(["24h Low" : String(describing: stockData["low"] as! CGFloat) ?? "N/A"])
                        newDataFields.append(["24h High" : String(describing: stockData["high"] as! CGFloat) ?? "N/A"])
                        newDataFields.append(["Last close" : String(describing: stockData["close"] as! CGFloat) ?? "N/A"])
                        
                        let stock = Stock()
                            stock.dataFields = newDataFields
                            stock.symbol = symbol
                        
                        // dispatch_async(dispatch_get_main_queue()) {
                        DispatchQueue.main.async { // migration edit
                            // completion(stock: stock)
                            completion(stock) // migration edit
                        }
                    }
                }
            }
        }
    }
   
    class func fetchChartPoints(symbol: String, range: ChartTimeRange, crypto : Bool?, completion:@escaping (_ chartPoints: [ChartPoint]) -> ()) {

        var chartURL = SwiftStockKit.chartUrlForRange(symbol: symbol, range: range)

        if crypto == true {
            chartURL = chartURL.replacingOccurrences(of: "getHistory", with: "getCryptoHistory")
            chartURL = chartURL.replacingOccurrences(of: "marketdata", with: "ondemand")
            chartURL = chartURL.replacingOccurrences(of: "key", with: "apikey")
            
            chartURL = "https://ondemand.websol.barchart.com/getCryptoHistory.json?apikey=\(APIReqests.DMUniqueAPIKey)&symbol=%5EBTCUSD&type=minutes&startDate=20171201&endDate=20171202&maxRecords=10&interval=60&order=asc"
            
        }
        
        Alamofire.request(chartURL, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                if let status = response.response?.statusCode {
                    switch(status){
                    case 201:
                        print("example success")
                    default:
                        print("error with response status: \(response.error.debugDescription)")
                    }
                }
                

                if let result = response.result.value {
                    if let JSON = result as? [String : Any] {
                        if let series = JSON["results"] as? [[String : AnyObject]] {
                            
                            var chartPoints = [ChartPoint]()
                            for dataPoint in series {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-mm-dd"
                                
                                var date = Date()
                                
                                if  dataPoint["tradingDay"] != nil {
                                    let dateString : NSMutableString = NSMutableString.init(string: dataPoint["tradingDay"]!.description)
                        
                                    date =  formatter.date(from: dateString as String)!
                                } else {
                                    date = Date(timeIntervalSince1970: (dataPoint["timestamp"] as? Double ?? dataPoint["tradingDay"] as! Double) - 18000.0) }
                                
                                
                                let lastPrice = dataPoint["lastPrice"] as? CGFloat
                                let close = dataPoint["close"] as? CGFloat
                                
                                chartPoints.append(
                                    ChartPoint(
                                        date:  date,
                                        volume: dataPoint["volume"] as? Int,
                                        open: dataPoint["open"] as? CGFloat,
                                        close: close != 0 ? close : lastPrice,
                                        low: dataPoint["low"] as? CGFloat,
                                        high: dataPoint["high"] as? CGFloat
                                    )
                                )
                            }
                            completion(chartPoints)
                            return
                        }
                    }
                }
    }
    
    }

    class func chartUrlForRange(symbol: String, range: ChartTimeRange) -> String {
    
        var timeString = String()
        
        switch (range) {
        case .OneDay:
            timeString = "daily"
        case .FiveDays:
            timeString = "weekly"
        case .TenDays:
            timeString = "weekly"
        case .OneMonth:
            timeString = "monthly"
        case .ThreeMonths:
            timeString = "quarterly"
        case .OneYear:
            timeString = "yearly"
        case .FiveYears:
            timeString = "yearly"
        }
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let year =  components.year! - 1
        
        let month = components.month! < 10 ? String(format: "0%d", components.month!) : String(format: "%d", components.month!)
        let day = components.day! < 10 ? String(format: "0%d", components.day!) : String(format: "%d", components.day!)
        
        let dateString = String(format : "%d%@%@", year, month, day)
     
        let usl = "https://marketdata.websol.barchart.com/getHistory.json?key=\(APIReqests.DMUniqueAPIKey)&symbol=\(symbol)&type=\(timeString)&startDate=\(dateString)"
        
        //let usl = "https://chartapi.finance.yahoo.com/instrument/1.0/\(symbol)/chartdata;type=quote;range=\(timeString)/json"
        
        return usl
    }
    

    // MARK : For array of stocks from NEW API.
    
    class func fetchDataForStocks(symbols: [String], completion:@escaping (_ chartPoints: [String : ChartPoint]) -> ()) {
        
        if (symbols.count > 0) {
        
        let chartURL = SwiftStockKit.chartUrlForStocks(symbols: symbols)
        
        print("\(chartURL)")
            
        Alamofire.request(chartURL, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                if let status = response.response?.statusCode {
                    switch(status){
                    case 201:
                        print("201 example success")
                    case 200:
                        print("200 example success")
                    default:
                        print("error with response status: \(response.error.debugDescription)")
                    }
                }
                
                
                if let result = response.result.value {
                    if let JSON = result as? [String : Any] {
                        if let series = JSON["results"] as? [[String : AnyObject]] {
                            
                            var chartPoints = [String : ChartPoint]()
                            for dataPoint in series {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-mm-dd"
                                
                                let ticker =  dataPoint["symbol"] as! String
                                let date = Date()
                          
                                let lastPrice = dataPoint["lastPrice"] as? CGFloat
                                let close = dataPoint["close"] as? CGFloat
                                
                                chartPoints[ticker] =
                                    ChartPoint(
                                        date:  date,
                                        volume: dataPoint["volume"] as? Int,
                                        open: dataPoint["open"] as? CGFloat,
                                        close: close != 0 ? close : lastPrice,
                                        low: dataPoint["low"] as? CGFloat,
                                        high: dataPoint["high"] as? CGFloat
                                    )
                                
                            }
                            completion(chartPoints)
                            return
                        }
                        
                        
                    } else {
                        completion([String : ChartPoint]())
                    }
                } else {
                    completion([String : ChartPoint]())
                }
            }
        } else {
            completion([String : ChartPoint]())
        }
    }
    
    class func chartUrlForStocks(symbols: [String]) -> String {
        
        let symbolsString = symbols.joined(separator: ",")
        
        let url = "http://marketdata.websol.barchart.com/getQuote.json?key=\(APIReqests.DMUniqueAPIKey)&symbols=\(symbolsString)"
        
        return url
    }
    
  

    
}


class SwiftStockChart: UIView {
    
    enum ValueLabelPositionType : Int {
        case Left, Right, Mirrored
    }
    
    typealias LabelForIndexGetter = (_ index: NSInteger) -> String
    typealias LabelForValueGetter = (_ value: CGFloat) -> String

    //Index Label Properties
    var labelForIndex: LabelForIndexGetter!
    var indexLabelFont: UIFont?
    var indexLabelTextColor: UIColor?
    var indexLabelBackgroundColor: UIColor?
    
    // Value label properties
    //var labelForIndex
    var labelForValue: LabelForValueGetter!
    var valueLabelFont: UIFont?
    var valueLabelTextColor: UIColor?
    var valueLabelBackgroundColor: UIColor?
    var valueLabelPosition: ValueLabelPositionType?
    
    // Number of visible step in the chart
    var gridStep: Int?
    var verticalGridStep: Int?
    var horizontalGridStep: Int?

    // Margin of the chart
    var margin: CGFloat?
    
    var axisWidth: CGFloat?
    var axisHeight: CGFloat?

    // Decoration parameters, let you pick the color of the line as well as the color of the axis
    var axisColor: UIColor?
    var axisLineWidth: CGFloat?
    
    // Chart parameters
    var color: UIColor = UIColor.red
    var fillColor: UIColor = UIColor.red
    var lineWidth: CGFloat?
    
    // Data points
    var displayDataPoint: Bool?
    var dataPointColor: UIColor?
    var dataPointBackgroundColor: UIColor?
    var dataPointRadius: CGFloat?
    
    // Grid parameters
    var drawInnerGrid: Bool?
    var innerGridColor: UIColor?
    var innerGridLineWidth: CGFloat?
    // Smoothing
    var bezierSmoothing: Bool?
    var bezierSmoothingTension: CGFloat?
    
    // Animations
    var animationDuration: CGFloat?

    var timeRange: ChartTimeRange!
    var dataPoints = [ChartPoint]()
    var layers = [CAShapeLayer]()
    var axisLabels = [UILabel]()
    var minValue: CGFloat?
    var maxValue: CGFloat?
    var initialPath: CGMutablePath?
    var newPath: CGMutablePath?

    
    //Implementation
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        color = UIColor.green
        fillColor = color.withAlphaComponent(0.25)
        verticalGridStep = 3
        horizontalGridStep = 3
        margin = 5.0
        axisWidth = self.frame.size.width - 2 * margin!
        axisHeight = self.frame.size.height - 2 * margin!
        axisColor = UIColor.red//UIColor(white: 0.5, alpha: 1.0)
        innerGridColor = UIColor.red//UIColor(white: 0.9, alpha: 1.0)
        drawInnerGrid = false
        bezierSmoothing = false
        bezierSmoothingTension = 0.2
        lineWidth = 1
        innerGridLineWidth = 0.5
        axisLineWidth = 1
        animationDuration = 0.0
        displayDataPoint = false
        dataPointRadius = 1.0
        dataPointColor = color
        dataPointBackgroundColor = color
        
        indexLabelBackgroundColor = UIColor.clear
        indexLabelTextColor = UIColor(white: 1, alpha: 0.6)
        indexLabelFont = UIFont(name: "HelveticaNeue-Light", size: 10)
        
        valueLabelBackgroundColor = UIColor.clear
        valueLabelTextColor = UIColor(white: 1, alpha: 0.6)
        valueLabelFont = UIFont(name: "HelveticaNeue-Light", size: 11)
        valueLabelPosition = .Right
        

    }
    
    func setChartPoints(points: [ChartPoint]) {
    
        if points.isEmpty { return }
        
        dataPoints = points
    
        computeBounds()
        
        
        if maxValue!.isNaN { maxValue = 1.0 }
        
        for  i in 0 ..< verticalGridStep! {
            
            let yVal = axisHeight! + margin! - CGFloat((i + 1)) * axisHeight! / CGFloat(verticalGridStep!)
            let p = CGPoint(x: (valueLabelPosition! == .Right ? axisWidth! : 0), y: yVal)
            
            let text = labelForValue(minValue! + (maxValue! - minValue!) / CGFloat(verticalGridStep!) * CGFloat((i + 1)))
                            
            let rect = CGRect(x : margin!,  y: p.y + 2, width: self.frame.size.width - margin! * 2 - 4.0, height: 14.0)
            let width = text.boundingRect(with: rect.size,
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes:[NSAttributedStringKey.font : valueLabelFont!],
                context: nil).size.width
            
            let xPadding = 6
            let xOffset = width + CGFloat(xPadding)
            
            let label = UILabel(frame: CGRect(x: p.x - xOffset + 5.0, y:  p.y, width : width + 2, height : 14))
            label.text = text
            label.font = valueLabelFont
            label.textColor = valueLabelTextColor
            label.textAlignment = .center
            label.backgroundColor = valueLabelBackgroundColor!
            
            self.addSubview(label)
            axisLabels.append(label)
        
        }
        
        for i in 0 ..< horizontalGridStep! + 1 {
            
            let text = labelForIndex(i)
            
            let p = CGPoint(x: margin! + CGFloat(i) * (axisWidth! / CGFloat(horizontalGridStep!)) * 1.0, y :  axisHeight! + margin!)
            
        
            let rect = CGRect(x : margin!, y: p.y + 2, width: self.frame.size.width - margin! * 2 - 4.0, height : 14)
            let width = text.boundingRect(with: rect.size,
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes:[NSAttributedStringKey.font : indexLabelFont!],
                context: nil).size.width
            
            let label = UILabel(frame: CGRect(x : p.x - 5.0, y : p.y + 5.0, width : width + 2, height : 14))
            label.text = text
            label.font = indexLabelFont!
            label.textAlignment = .left
            label.textColor = indexLabelTextColor!
            label.backgroundColor = indexLabelBackgroundColor!
            
            self.addSubview(label)
            axisLabels.append(label)
        
        }
        
        self.color = UIColor.red
            //UIColor(red: (127/255), green: (50/255), blue: (198/255), alpha: 1)
        strokeChart()
        self.setNeedsDisplay()
    
    }
    
    override func draw(_ rect: CGRect) {
        if !dataPoints.isEmpty {
            drawGrid()
        }
    }
    
    func drawGrid() {
        
        if drawInnerGrid! {
            
            let ctx = UIGraphicsGetCurrentContext()
            UIGraphicsPushContext(ctx!)
            ctx!.setLineWidth(axisLineWidth!)
            ctx!.setStrokeColor(axisColor!.cgColor)
            
            ctx!.move(to: CGPoint(x: margin!, y: margin!))
            ctx?.addLine(to: CGPoint(x: margin!, y: axisHeight! + margin! + 3))
            ctx!.strokePath()
            
            for i in 0 ..< horizontalGridStep! {
                
                ctx!.setStrokeColor(innerGridColor!.cgColor)
                ctx!.setLineWidth(innerGridLineWidth!)
                
                let point = CGPoint(x: CGFloat((1 + i)) * axisWidth! / CGFloat(horizontalGridStep!) * 1.0 + margin!, y: margin!)
                
                ctx!.move(to: CGPoint(x: point.x, y: point.y))
                ctx?.addLine(to: CGPoint(x: point.x, y: axisHeight! + margin!))
                ctx!.strokePath()
                
                ctx!.setStrokeColor(axisColor!.cgColor)
                ctx!.setLineWidth(axisLineWidth!)
                
                ctx!.move(to: CGPoint(x: point.x - 0.5, y: axisHeight! + margin!))
                ctx?.addLine(to: CGPoint(x: point.x - 0.5, y: axisHeight! + margin! + 3))
               
                ctx!.strokePath()
            
            }
        
            for i in 0 ..< verticalGridStep! + 1 {
                
                let v = maxValue! - (maxValue! - minValue!) / CGFloat(verticalGridStep! * i)
                
                if(v == minValue!) {
                    ctx!.setLineWidth(axisLineWidth!)
                    ctx!.setStrokeColor(axisColor!.cgColor)
                } else {
                    ctx!.setStrokeColor(innerGridColor!.cgColor)
                    ctx!.setLineWidth(innerGridLineWidth!)
                }
                
                let point = CGPoint(x:margin!, y: CGFloat(i) * axisHeight! / CGFloat(verticalGridStep!) + margin!)
                
                ctx!.move(to: CGPoint(x: point.x, y: point.y))
                ctx?.addLine(to: CGPoint(x: axisWidth! + margin!, y: point.y))

                ctx!.strokePath()
                
            }
        }
    
    }
    
    func clearChartData(){
        for layer in layers {
            layer.removeFromSuperlayer()
        }
        layers.removeAll()
        
        for lbl in axisLabels {
            lbl.removeFromSuperview()
        }
        axisLabels.removeAll()
    }
    
    func strokeChart(){
        
        let scale = axisHeight! / (maxValue! - minValue!)
        
        let path = getLinePath(scale: scale, smoothing: bezierSmoothing!, close: false)
        
        let pathLayer = CAShapeLayer()
        pathLayer.frame = CGRect.init(x: self.bounds.origin.x, y: self.bounds.origin.y + (margin! * 1.2), width: self.bounds.size.width, height: self.bounds.size.height)
        pathLayer.bounds = self.bounds
        pathLayer.path = path.cgPath
        pathLayer.fillColor = nil //color.CGColor
        pathLayer.strokeColor = UIColor.init(red: 218/255, green: 19/255, blue: 34/255, alpha: 1).cgColor
        pathLayer.lineWidth = lineWidth!
        pathLayer.lineJoin = kCALineJoinRound
        
        self.layer.addSublayer(pathLayer)
        layers.append(pathLayer)
    
    }
    
    func computeBounds(){
        minValue = CGFloat(MAXFLOAT)
        maxValue = CGFloat(-MAXFLOAT)
        
        for i in 0 ..< dataPoints.count {
            let value = dataPoints[i].close!
         
            if value < minValue! {
                minValue = value
            }
            
            if value > maxValue! {
                maxValue = value
            }

          //  maxValue = getUpperRoundNumber(value: maxValue!, gridStep: verticalGridStep!)
            
            if minValue! < 0 {
            
                var step: CGFloat
                
                if verticalGridStep! > 3 {
                    step = fabs(maxValue! - minValue!) / CGFloat(verticalGridStep! - 1)
                } else {
                    step = max(fabs(maxValue! - minValue!) / 2, max(fabs(minValue!), fabs(maxValue!)))
                }
                
                step = getUpperRoundNumber(value: step, gridStep: verticalGridStep!)
                
                var newMin: CGFloat
                var newMax: CGFloat

                if fabs(minValue!) > fabs(maxValue!) {
                    let m = ceil(fabs(minValue!) / step)
                   
                    newMin = step * m * (minValue! > 0 ? 1 : -1)
                    newMax = step * (CGFloat(verticalGridStep!) - m) * (maxValue! > 0 ? 1 : -1)
                } else {
                    let m = ceil(fabs(maxValue!) / step)
                    
                    newMax = step * m * (maxValue! > 0 ? 1 : -1)
                    newMin = step * (CGFloat(verticalGridStep!) - m) * (minValue! > 0 ? 1 : -1)
                }
                
                if(minValue! < newMin) {
                    newMin -= step
                    newMax -=  step
                }
                
                if(maxValue! > newMax + step) {
                    newMin += step
                    newMax += step
                }
                
                minValue = newMin
                maxValue = newMax
                
                if(maxValue! < minValue!) {
                    let tmp = maxValue!
                    maxValue = minValue
                    minValue = tmp
                }
                
            }
        }
    }
    
    func getUpperRoundNumber(value: CGFloat, gridStep: Int) -> CGFloat {
        if value <= 0.0 {
            return 0.0
        }
        
        let logValue = log10f(Float(value))
        let scale = powf(10.0, floorf(logValue))
        var n = ceil(value / CGFloat(scale * 4))
        
        let tmp = Int(n) % gridStep
        
        if tmp != 0 {
            n += CGFloat(gridStep - tmp)
        }
        
        return n * CGFloat(scale) / 4.0
    }
    
    func setGridStep(gridStep: Int) {
        verticalGridStep = gridStep
        horizontalGridStep = gridStep
    }
    
    func getPointForData(index: Int, scale: CGFloat) -> CGPoint {
        if index < 0 || index >= dataPoints.count{
            return CGPoint.zero
        }
        
        let dataPoint = dataPoints[index].close!
        
        var properWidth = axisWidth!
        if timeRange! == .OneDay {
            properWidth = ((CGFloat(dataPoints.count) / 391.0) * axisWidth!) - margin!
        }
        
        var xDenom = CGFloat(dataPoints.count - 1)
        if xDenom == 0 { xDenom = 1 }
        
        var yDenom = maxValue! - minValue!
        if yDenom == 0 { yDenom = 0 }
        
        let pt = CGPoint(x:
            margin! + CGFloat(index) * ( properWidth / xDenom ), y :
            ( axisHeight! - (( (dataPoint - minValue!) / yDenom ) * axisHeight!) ) + margin!
        
        )
        
        return pt
    }
    
    func getLinePath(scale: CGFloat, smoothing: Bool, close: Bool) -> UIBezierPath {
    
        let path = UIBezierPath()

        for i in 0 ..< dataPoints.count {
            if i > 0 {
                path.addLine(to: getPointForData(index: i, scale: scale))
            } else {
                path.move(to: getPointForData(index: i, scale: scale))
            }
        }
        
        return path
    }
    
    
    func timeLabelsForTimeFrame(range: ChartTimeRange) -> [String] {
    
        switch range {
        case .OneDay:
            return ["9:30am", "10", "11", "12pm", "1", "2", "3", "4"]
        case .FiveDays:
            
           let weekday = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!.components(.weekday, from: Date()).weekday
           
           switch weekday {
           case 1?:
            return ["Mon", "Tues", "Wed", "Thu", "Fri"]
           case 2?:
            return ["Tues", "Wed", "Thu", "Fri", "Mon"]
           case 3?:
             return ["Wed", "Thu", "Fri", "Mon", "Tues"]
           case 4?:
            return ["Thu", "Fri", "Mon", "Tues", "Wed"]
           case 5?:
            return ["Fri", "Mon", "Tues", "Wed", "Thu"]
           case 6?:
            return ["Mon", "Tues", "Wed", "Thu", "Fri"]
           case 7?:
            return ["Mon", "Tues", "Wed", "Thu", "Fri"]
           default: ()
           }
        case .TenDays:
            let weekday = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!.components(.weekday, from: Date()).weekday
            switch weekday {
                //sunday
            case 1?:
                return ["Mon", "Wed", "Fri", "Mon", "Wed", "Fri"]
            case 2?:
                return ["Wed", "Fri", "Mon", "Wed", "Fri", "Mon"]
            case 3?:
                return ["Wed", "Fri", "Mon", "Wed", "Fri", "Tues"]
            case 4?:
                return ["Fri", "Mon", "Wed", "Fri", "Mon", "Wed"]
            case 5?:
                return ["Wed", "Mon", "Wed", "Fri", "Tues", "Thu"]
            case 6?:
                return ["Mon", "Wed", "Fri", "Mon", "Wed", "Fri"]
                //saturday
            case 7?:
                return ["Mon", "Wed", "Fri", "Mon", "Wed", "Fri"]
            default: ()
            }
        case .OneMonth:
            
            let fmt = DateFormatter()
            fmt.dateFormat = "dd MMM"
            let offset = Double(-6*24*60*60)
            let start = Date()
            let fifthString = fmt.string(from:start.addingTimeInterval(offset))
            let fourthString = fmt.string(from:start.addingTimeInterval(offset * 2))
            let thirdString = fmt.string(from:start.addingTimeInterval(offset * 3))
            let secondString = fmt.string(from:start.addingTimeInterval(offset * 4))
            let firstString = fmt.string(from:start.addingTimeInterval(offset * 5))
            
            return[firstString, secondString, thirdString, fourthString, fifthString, ""]
        case .ThreeMonths:
            let fmt = DateFormatter()
            fmt.dateFormat = "dd MMM"
            let offset = Double(-15*24*60*60)
            let start = Date()
            let fifthString = fmt.string(from: start.addingTimeInterval(offset))
            let fourthString = fmt.string(from: start.addingTimeInterval(offset * 2))
            let thirdString = fmt.string(from:start.addingTimeInterval(offset * 3))
            let secondString = fmt.string(from:start.addingTimeInterval(offset * 4))
            let firstString = fmt.string(from:start.addingTimeInterval(offset * 5))
            
            return[firstString, secondString, thirdString, fourthString, fifthString, ""]
        case .OneYear:
            let fmt = DateFormatter()
            fmt.dateFormat = "MMM"
            let offset = Double(-80*24*60*60)
            let start = Date()
            let fifthString = fmt.string(from:start.addingTimeInterval(offset))
            let fourthString = fmt.string(from:start.addingTimeInterval(offset * 2))
            let thirdString = fmt.string(from:start.addingTimeInterval(offset * 3))
            let secondString = fmt.string(from:start.addingTimeInterval(offset * 4))
            let firstString = fmt.string(from:start.addingTimeInterval(offset * 5))
            
            return[firstString, secondString, thirdString, fourthString, fifthString, ""]

        case .FiveYears:
            let fmt = DateFormatter()
            fmt.dateFormat = "yyyy"
            let offset = Double(-365*24*60*60)
            let start = Date()
            let fifthString = fmt.string(from:start.addingTimeInterval(offset))
            let fourthString = fmt.string(from:start.addingTimeInterval(offset * 2))
            let thirdString = fmt.string(from:start.addingTimeInterval(offset * 3))
            let secondString = fmt.string(from:start.addingTimeInterval(offset * 4))
            let firstString = fmt.string(from:start.addingTimeInterval(offset * 5))
            
            return[firstString, secondString, thirdString, fourthString, fifthString, ""]
        }
        return []
    }
}
















