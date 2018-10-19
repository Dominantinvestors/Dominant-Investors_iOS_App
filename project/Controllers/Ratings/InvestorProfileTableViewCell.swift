import UIKit

class InvestorProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var secondName: UILabel!

    @IBOutlet weak var follow: ActionHandleButton!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var message: ActionHandleButton!
}
