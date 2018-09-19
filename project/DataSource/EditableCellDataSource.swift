import UIKit

public struct EditAction {
    let action: DataSource.Action
    let title: String
    let color: UIColor
}

public protocol EditableCellDataSource {
    func editActions() -> [EditAction]
}

public extension TableViewDataSource where
    Self: EditableCellDataSource & DataContainable & CellContainable,
    Self.Configurator: CellSelectable,
    Self.Configurator.Item == Self.Item
{
    
    func canEditRow(for tableView: UITableView, at  indexPath: IndexPath) -> Bool {
        return true
    }
    
    func editActions(for tableView: UITableView, at indexPath: IndexPath) -> [UITableViewRowAction]? {
        return self.editActions().map { retrive($0, tableView) }
    }
    
    private func retrive(_ editAction: EditAction,_ tableView: UITableView) -> UITableViewRowAction {
        let action = UITableViewRowAction(style: .normal, title: editAction.title)
        { (action, indexPath) in
            let attributes = self.attributes(in: tableView, at: indexPath)
            if let selector = self.cellConfigurator?.selectors[editAction.action] {
                selector(attributes.cell, indexPath, attributes.item)
            }
        }
        action.backgroundColor = editAction.color
        return action
    }
    
    private func attributes(in tableView: UITableView, at indexPath: IndexPath) -> (cell: Cell, item: Item) {
        let item = self.item(at: indexPath.row)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? Cell else {
            fatalError("cell no found")
        }
        return (cell, item)
    }
}
