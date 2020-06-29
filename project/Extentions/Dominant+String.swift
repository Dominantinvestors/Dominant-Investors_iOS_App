import UIKit

extension String {
    
    func toMoneyStyle(intSize: CGFloat = 44, coinSize: CGFloat = 20) -> NSAttributedString {
        let price = NSMutableAttributedString()

        let st = self.split(separator: ".")
        
        let intAttribute = [NSAttributedString.Key.font: Fonts.regular(intSize)]
        let int = NSAttributedString(string:String(st[0]), attributes: intAttribute)
        price.append(int)
        
        if st.count >= 2 {
            let coinAttribute = [NSAttributedString.Key.font: Fonts.regular(coinSize)]
            let coinStr = ".\(String(st[1]))\(Values.Currency)"
            let coin = NSAttributedString(string: coinStr, attributes: coinAttribute)
            price.append(coin)
        }
        return price
    }
}
