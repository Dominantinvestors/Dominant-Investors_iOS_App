import UIKit

class BuyTableViewCell: UITableViewCell, ReuseIdentifier {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var textField: UITextField!

    func editStyle() {
        title.textColor = .red
        textField.textColor = .red
    }
    
    func normalStyle() {
        title.textColor = .lightGray
        textField.textColor = .black
    }
}

extension UITextField {
    
    func setRight(_ text: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        label.text = text
        label.font = Fonts.bolt(25)
        label.textAlignment = .center
        rightViewMode = .always
        rightView = label
    }
}
