import UIKit

class SegmentControll: UIView {

    var selector: ((_ index: Int) -> ())?
    
    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var rightButton: UIButton!

    override func awakeFromNib() {
        setUp()
    }
    
    func setLeft(_ title: String) {
        leftButton.setTitle(title, for: .normal)
    }
    
    func setRight(_ title: String) {
        rightButton.setTitle(title, for: .normal)
    }
    
    private func setUp() {
        decorateButtons()
        addSelectors()
        onLeft()
    }
    
    private func decorateButtons() {
        leftButton.decorate()
        rightButton.decorate()
    }
    
    private func addSelectors() {
        leftButton.addTarget(self, action: #selector(onLeft), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(onRight), for: .touchUpInside)
    }
    
    @objc private func onLeft() {
        leftButton.select()
        rightButton.unSelect()
        selector?(0)
    }
    
    @objc func onRight() {
        leftButton.unSelect()
        rightButton.select()
        selector?(1)
    }
}

fileprivate extension UIButton {
    
    func decorate() {
        setTitleColor(UIColor(red: 138.0 / 255, green: 138.0 / 255, blue: 138.0 / 255, alpha: 1), for: .normal)
        titleLabel?.font = Fonts.bolt(15)
    }
    
    func select() {
        backgroundColor = .white
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 1
    }
    
    func unSelect() {
        layer.borderColor = UIColor.clear.cgColor
        backgroundColor = UIColor(red: 226.0 / 255, green: 226.0 / 255, blue: 226.0 / 255, alpha: 1)
    }
}
