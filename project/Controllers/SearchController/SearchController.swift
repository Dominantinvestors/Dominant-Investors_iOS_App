import UIKit

protocol SearchItem {
    var title: String { get }
}

extension AssetsModel: SearchItem {
    var title: String { return ticker}
}

extension CompanyModel: SearchItem {
    var title: String { return ticker}
}

extension String: SearchItem {
    var title: String { return self}
}

class SearchController: UIView {
    
    var textDidUpdate: ((String) -> Void)?
    var selectedItem: ((SearchItem) -> Void)?

    var data: [SearchItem] {
        didSet {
            dataSource.data = data
            tableView.reloadData()
        }
    }
    
    fileprivate let dataSource: SearchControllerDataSource

    private var shim: TableViewDataSourceShim? = nil {
        didSet {
            tableView.dataSource = shim
            tableView.delegate = shim
        }
    }
    
    private var searchBar: UISearchBar!
    
    fileprivate let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), style: .plain)
    
    init() {
        self.data = []
        self.dataSource = SearchControllerDataSource(data: data)
        
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        addSubview(tableView)

        setUpTableDataSource()
        decorate()
        decorateTableView()
        addGestureRecognizer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnView))
        addGestureRecognizer(tap)
    }
    
    @objc private func tapOnView() {
        hide()
    }
    
    private func decorateTableView() {
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 20
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func decorate() {
        backgroundColor = .clear
    }
    
    private func setUpTableDataSource() {
        tableView.register(cell: StringTableViewCell.self)

        shim = TableViewDataSourceShim(self.dataSource)
        
        self.dataSource.selectors[.highlight] = { _, _, item in
            self.selectedItem?(item)
        }
    }
    
    fileprivate func present(on searchBar: UISearchBar) {
        self.searchBar = searchBar
        
        let window = UIApplication.shared.keyWindow!
        let view = (window.rootViewController?.view)!
        let convertFrame = searchBar.superview?.convert(searchBar.frame.origin, to: view)
        
        tableView.frame = CGRect(x: convertFrame!.x,
                                 y: convertFrame!.y + searchBar.frame.size.height,
                                 width: searchBar.frame.size.width,
                                 height: 0)
        frame = view.frame
        
        view.addSubview(self)
    }
    
    fileprivate func hide() {
        searchBar.text = nil
        searchBar.endEditing(true)
        removeFromSuperview()
    }
        
    fileprivate func showTableView() {
        let convertFrame = searchBar.superview?.convert(searchBar.frame.origin, to: self)
        
        tableView.frame = CGRect(x: convertFrame!.x,
                                      y: convertFrame!.y + searchBar.frame.size.height,
                                      width: searchBar.frame.size.width,
                                      height: 135)
    }
    
    fileprivate func hideTableView() {
        data = []
        tableView.frame.size.height = 0
    }
}

extension SearchController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        present(on: searchBar)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        hide()
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool  {
        let currentString: NSString = searchBar.text! as NSString
        let searchText = currentString.replacingCharacters(in: range, with: text)
        
        if searchText.count > 0 {
            showTableView()
            self.textDidUpdate?(searchText)
        } else {
            hideTableView()
        }
        
        return true
    }
}

class SearchControllerDataSource:
    TableViewDataSource,
    DataContainable,
    CellContainable,
    CellConfigurator,
    CellSelectable
{
    var data: [SearchItem]
    
    var selectors: [DataSource.Action: (StringTableViewCell, IndexPath, SearchItem) -> ()] = [:]
    
    init(data: [SearchItem]) {
        self.data = data
    }
    
    func reuseIdentifier() -> String {
        return "StringTableViewCell"
    }
    
    func configurateCell(_ cell: StringTableViewCell, item: SearchItem, at indexPath: IndexPath) {
        cell.titleLabel.text = item.title
    }
}
