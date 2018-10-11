import UIKit

class DMRatingTableViewCell: UITableViewCell {

    @IBOutlet weak var  positionLabel : UILabel!
    @IBOutlet weak var  investorLabel : UILabel!
    @IBOutlet weak var  overallLabel  : UILabel!
    @IBOutlet weak var  portfolio  : UIImageView!

    open func setupWith(model : InvestorModel) {
        
        self.portfolio.setProfileImage(for: model)
        
        self.investorLabel.text = model.fullName()
        
        self.overallLabel.text = String(format : "%d", model.rating).appending("%")
        
        let user: UserModel = ServiceLocator.shared.getService()
        if (model.id == user.id) {
            self.backgroundColor = UIColor(red: 0, green: 255, blue: 0, alpha: 0.25)
        } else {
            self.backgroundColor = UIColor.clear
        }
    }

}
