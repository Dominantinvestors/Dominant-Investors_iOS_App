import UIKit

class SearchTableViewCell: UITableViewCell, ReuseIdentifier {
 
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var background: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        searchBar.setImage(UIImage(named: "searchIcon"), for: .bookmark, state: .normal)
        searchBar.setImage(UIImage(named: "clear"), for: .resultsList, state: .normal)

        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as! UITextField
        textFieldInsideSearchBar.leftViewMode = .never
        textFieldInsideSearchBar.borderStyle = .none
        
        background.layer.cornerRadius = background.frame.size.height / 2
    }
}
