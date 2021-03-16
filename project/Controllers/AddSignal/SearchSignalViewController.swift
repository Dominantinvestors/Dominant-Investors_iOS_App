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
        
        let search = SearchDataSource(data: [NSLocalizedString("Enter the ticker", comment: "")], delegate: self)
        items = SearchControllerDataSource(data: [])
        
        items.selectors[.select] = { [unowned self]  _, _, item in
            if let company = item as? SearchAssetModel {
                self.addCompany(company)
            }
        }
        
        self.dataSource = TableViewDataSourceShim(ComposedDataSource([search, items]))
        self.tableView.reloadData()
    }
    
    fileprivate func addCompany(_ company: Company) {
        let add: AddSignalViewController = storyboard![.AddSignal]
        add.company = company
        self.navigationController?.pushViewController(add, animated: true)
    }
    
    fileprivate func textDidUpdate(_ text: String) {
        showActivityIndicator()
        SignalsDataProvider.default().search(by: text) { [unowned self] items, error in
            self.dismissActivityIndicator()
            
            if let items = items {
                self.items.data = items
                self.tableView.reloadSections([1], with: .fade)
            } else {
                self.showAlertWith(message: error)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool  {
        
        guard text != "\n" else {
            return true
        }
        
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
}
