import UIKit

class PriceTableViewCell: UITableViewCell {

    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var isGrowingIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.priceView.layer.cornerRadius = 25.0
    } 
}
