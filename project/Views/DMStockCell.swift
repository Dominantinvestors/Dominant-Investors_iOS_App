import UIKit

class DMStockCell: UITableViewCell {

    @IBOutlet weak var ticker             : UILabel!
    @IBOutlet weak var exchangeOrBuyPoint : UILabel!
    @IBOutlet weak var currentPrice       : UILabel!
    @IBOutlet weak var profitability      : UILabel!
    @IBOutlet weak var investmentPeriod   : UILabel!
    
    public func setupWithHistorySignal(stock: SignalModel) {
        
        ticker.text = stock.ticker
        exchangeOrBuyPoint.text = ""
        currentPrice.text = stock.buyPoint
        profitability.text = stock.targetPrice
        investmentPeriod.text = stock.stopLoss
    }
}


