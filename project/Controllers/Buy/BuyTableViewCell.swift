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
