import UIKit

public protocol Collapsible:
    class,
    DataContainable,
    CellContainable
{
    var open: Bool { get set }
}

public extension TableViewDataSource where
    Self.Item == Self.Configurator.Item,
    Self: Collapsible
{
    func numberOfRows(for tableView: UITableView, in section: Int) -> Int {
        if self.open {
            return self.numberOfItems()
        } else {
            return 0
        }
    }
}
