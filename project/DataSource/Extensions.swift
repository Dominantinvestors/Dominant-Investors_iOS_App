import UIKit

public protocol ReuseIdentifier {
    static var identifier: String { get }
}

public extension ReuseIdentifier where Self: UIView {
    
    static var identifier: String {
        let type = String(describing: self)
        return type
    }
}

public extension UITableView {
    
    func register<T: ReuseIdentifier>(_ headerFooterView: T.Type)  {
        let identifier = headerFooterView.identifier
        self.register(UINib(nibName: identifier , bundle: nil), forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func register<T: ReuseIdentifier>(cell: T.Type)  {
        let identifier = cell.identifier
        self.register(UINib(nibName: identifier , bundle: nil), forCellReuseIdentifier: identifier)
    }
}

public class EmptyView : UIView, ReuseIdentifier {
    
}

public class ActionHandleButton : UIButton {
    
    private var action: (() -> Void)?
    
    @objc internal func triggerActionHandleBlock() {
        self.action?()
    }
    
    public func actionHandle(_ control :UIControlEvents, ForAction action:@escaping () -> Void) {
        self.action = action
        self.addTarget(self, action: #selector(ActionHandleButton.triggerActionHandleBlock), for: control)
    }
}

public extension UITableView {
    
    func collapse<T: Collapsible>(_ dataSource: T, at section: Int = 0) {
        let indexPaths = (0..<dataSource.numberOfItems()).map {
            IndexPath(row: $0, section: section)
        }
        
        dataSource.open = false
        
        self.deleteRows(at: indexPaths, with: .fade)
    }
    
    func expand<T: Collapsible>(_ dataSource: T, at section: Int = 0) {
        let indexPaths = (0..<dataSource.numberOfItems()).map {
            IndexPath(row: $0, section: section)
        }
        
        dataSource.open = true
        
        self.insertRows(at: indexPaths, with: .fade)
    }
}

public extension UITableView {
    
    func show(_ emptyView: UIView) {
        if self.backgroundView != emptyView {
            self.backgroundView = emptyView
        }
    }
    
    func hideEmptyView() {
        self.backgroundView = nil
    }
}

