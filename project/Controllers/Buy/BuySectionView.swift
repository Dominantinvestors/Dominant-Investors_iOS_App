import UIKit

class BuySectionView: UITableViewHeaderFooterView, ReuseIdentifier {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var submit: ActionHandleButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        title.text = NSLocalizedString("Order Summary", comment: "")
        submit.setTitle(NSLocalizedString("SUBMIT", comment: ""), for: .normal)
    }
    
}

