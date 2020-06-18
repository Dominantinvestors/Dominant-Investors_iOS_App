import UIKit

extension UITextField {
    
    func setRight(_ text: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        label.text = text
        label.font = Fonts.bolt(22)
        label.textAlignment = .center
        rightViewMode = .always
        rightView = label
    }
    
    func setPlaceholder(_ placeholder: String) {
        self.attributedPlaceholder =
            NSAttributedString(string:placeholder,
                               attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
    }
}
