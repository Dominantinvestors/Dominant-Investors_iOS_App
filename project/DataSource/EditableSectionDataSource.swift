import UIKit

public protocol EditebaleSection: class {
    var editing: Bool { get set }
    
    func startEditing(_ section: EditebaleSectionView)
    func endEditing(_ section: EditebaleSectionView)
    func setupObserving(_ section: EditebaleSectionView)
}

public protocol EditebaleSectionView: class {
    var observer: EditebaleSection? { get set }
    
    func open()
    func close()
}

public extension TableViewDataSource where Self: EditebaleSection {
    
    func startEditing(_ section: EditebaleSectionView) {
        editing = true
        section.open()
    }
    
    func endEditing(_ section: EditebaleSectionView) {
        editing = false
        section.close()
    }
    
    func setupObserving(_ section: EditebaleSectionView) {
        if editing {
            startEditing(section)
        } else {
            endEditing(section)
        }
        section.observer = self
    }
}
