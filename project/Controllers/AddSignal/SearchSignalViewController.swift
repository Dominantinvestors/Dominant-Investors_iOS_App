import UIKit

class SearchSignalViewController: KeyboardObservableViewController, UISearchBarDelegate {

    private var items: SearchControllerDataSource!
    
    private var dataSource: TableViewDataSourceShim? = nil {
        didSet {
            tableView.dataSource = dataSource
            tableView.delegate = dataSource
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("CREATE SIGNAL", comment: "")
    
        tableView.register(cell: SearchTableViewCell.self)
        tableView.register(cell: StringTableViewCell.self)
        
        let search = SearchDataSource(data: [NSLocalizedString("Enter the ticket", comment: "")], delegate: self)
        items = SearchControllerDataSource(data: [])
        
        items.selectors[.highlight] = { _, _, item in
            if let company = item as? Company {
                let add: AddSignalViewController = UIStoryboard(name: "Portfolio", bundle: nil)[.AddSignal]
                add.company = company
                self.navigationController?.pushViewController(add, animated: true)
            }
        }
        
        self.dataSource = TableViewDataSourceShim(ComposedDataSource([search, items]))
        self.tableView.reloadData()
    }
    
    fileprivate func textDidUpdate(_ text: String) {
        showActivityIndicator()
        DrivewealthDataProvider.default().search(by: text) { items, error in
            self.dismissActivityIndicator()
            //        SignalsDataProvider.default().companies() { items, error in
            
            //        SignalsDataProvider.default().search(by: text) { items, error in
            if let items = items {
                self.items.data = items
                self.tableView.reloadData()
            } else {
                self.showAlertWith(message: error)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool  {
        let currentString: NSString = searchBar.text! as NSString
        let searchText = currentString.replacingCharacters(in: range, with: text)
        
        if searchText.count > 1 {
            self.textDidUpdate(searchText)
        } else {
            self.items.data = []
            self.tableView.reloadSections([1], with: .top)
        }
        return true
    }
}
