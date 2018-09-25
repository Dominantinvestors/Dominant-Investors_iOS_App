import UIKit

extension String {
    
    func toMoneyStyle(intSize: Int = 40, coinSize: Int = 17) -> NSAttributedString {
        let st = self.split(separator: ".")
        let coinAttribute = [ NSAttributedStringKey.font: Fonts.regular(17)]
        
        let coinStr = ".\(String(st[1]))\(Values.Currency)"
        let coin = NSAttributedString(string: coinStr, attributes: coinAttribute)
        
        let intAttribute = [ NSAttributedStringKey.font: Fonts.regular(40)]
        let int = NSAttributedString(string:String(st[0]), attributes: intAttribute)
        
        let price = NSMutableAttributedString()
        price.append(int)
        price.append(coin)
        return price
    }
}
