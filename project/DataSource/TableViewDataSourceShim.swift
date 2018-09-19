import UIKit

fileprivate enum Section: Int {
    case header, footer
}

open class TableViewDataSourceShim: NSObject {
    
    public weak var tableView: UITableView?

    public var dataSource: TableViewDataSource {
        didSet {
            tableView?.reloadData()
            
            rowCache.removeAll()
            headerCache.removeAll()
            footerCache.removeAll()
        }
    }
    
    private var rowCache = [IndexPath: CGFloat]()
    
    private var headerCache = [Int: CGFloat]()
    private var footerCache = [Int: CGFloat]()
    
    public init(_ dataSource: TableViewDataSource, tableView: UITableView? = nil) {
        self.dataSource = dataSource
        self.tableView = tableView
    }
    
    internal func emptyView(for numberOfSections: Int) {
        if numberOfSections == 0 {
            tableView?.show(dataSource.emptyView())
        } else {
            tableView?.hideEmptyView()
        }
    }
    
    fileprivate subscript (i: Int, section: Section) -> CGFloat? {
        get {
            return (section == .header) ? headerCache[i] : footerCache[i]
        }
        set {
            if section == .header { headerCache[i] = newValue } else { footerCache[i] = newValue }
        }
    }
    
    fileprivate subscript (cell: IndexPath) -> CGFloat? {
        get {
            return rowCache[cell]
        }
        set {
            rowCache[cell] = newValue
        }
    }
}

open class SegmentDataSourceShim: TableViewDataSourceShim {

    public var selectIndex: Int {
        get {
            return _selectedIndex
        }
        set {
            selectIndex(newValue)
        }
    }
    
    public var dataSources: [TableViewDataSource] {
        didSet {
            selectIndex(0)
        }
    }
    
    private var _selectedIndex = 0
    
    public init(_ dataSources: [TableViewDataSource], tableView: UITableView? = nil) {
        guard let dataSource = dataSources.last else {
            fatalError("DataSeources can't be empty please use EmptyDataSource!")
        }
        self.dataSources = dataSources
        super.init(dataSource)
        self.tableView = tableView
        selectIndex(0)
    }
    
    private func selectIndex(_ index: Int) {
        _selectedIndex = index
        if index >= 0 && index < dataSources.count {
            dataSource = dataSources[index]
            tableView?.reloadData()
        }
    }
}

extension TableViewDataSourceShim: UITableViewDataSource {
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSections = dataSource.numberOfSections(for: tableView)
        emptyView(for: numberOfSections)
        return numberOfSections
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfRows(for: tableView, in: section)
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataSource.cell(for: tableView, at: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource.headerTitle(for: tableView, in: section)
    }
    
    open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return dataSource.footerTitle(for: tableView, in: section)
    }
    
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return dataSource.canEditRow(for: tableView, at: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return dataSource.editActions(for: tableView, at: indexPath)
    }
}

extension TableViewDataSourceShim: UITableViewDelegate {
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return dataSource.headerView(for: tableView, in: section)
    }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return dataSource.footerView(for: tableView, in: section)
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSource.didSelectRow(in: tableView, at: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        dataSource.didHighlightRow(in: tableView, at: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        dataSource.didUnhighlightRow(in: tableView, at: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        dataSource.willDisplay(row: cell, in: tableView, at: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        dataSource.willDisplay(header: view, for: tableView, in: section)
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self[indexPath] ?? dataSource.cellHeight(for: tableView, at: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self[section, .header] ?? dataSource.headerHeight(for: tableView, in: section)
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self[section, .footer] ?? dataSource.footerHeight(for: tableView, in: section)
    }
    
    open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self[indexPath] = cell.bounds.height
    }
    
    open func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if view.bounds.height >= 1 {
             self[section, .header] = view.bounds.height
        }
    }
    
    open func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        if view.bounds.height >= 1 {
            self[section, .footer] = view.bounds.height
        }
    }
}

public struct EmptyDataSource: TableViewDataSource {
    
    public func numberOfRows(for tableView: UITableView, in section: Int) -> Int {
        return 0
    }
    
    public func cell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
