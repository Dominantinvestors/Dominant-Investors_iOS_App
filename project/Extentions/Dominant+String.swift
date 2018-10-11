import UIKit

extension String {
    
    func toMoneyStyle(intSize: CGFloat = 44, coinSize: CGFloat = 20) -> NSAttributedString {
        let st = self.split(separator: ".")
        let coinAttribute = [ NSAttributedStringKey.font: Fonts.regular(coinSize)]
        
        let coinStr = ".\(String(st[1]))\(Values.Currency)"
        let coin = NSAttributedString(string: coinStr, attributes: coinAttribute)
        
        let intAttribute = [ NSAttributedStringKey.font: Fonts.regular(intSize)]
        let int = NSAttributedString(string:String(st[0]), attributes: intAttribute)
        
        let price = NSMutableAttributedString()
        price.append(int)
        price.append(coin)
        return price
    }
}
