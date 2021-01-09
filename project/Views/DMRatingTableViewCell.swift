import UIKit

class DMRatingTableViewCell: UITableViewCell {

    @IBOutlet weak var  positionLabel : UILabel!
    @IBOutlet weak var  investorLabel : UILabel!
    @IBOutlet weak var  overallLabel  : UILabel!
    @IBOutlet weak var  portfolio  : UIImageView!
    @IBOutlet weak var  overallView  : UIView!
    @IBOutlet weak var proImage : UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        proImage.isHidden = true
    }

    open func setupWith(model : InvestorModel, isProHidden : Bool) {
        
        overallView.layer.cornerRadius = 5
        
        self.portfolio.setProfileImage(for: model)
        
        self.investorLabel.text = model.fullName()
        
        self.overallLabel.text = String(format : "%d", model.rating).appending("%")
        
        if model.rating >= 0 {
            overallView.backgroundColor = Colors.green
        } else {
            overallView.backgroundColor = Colors.red
        }
        
        let user: UserModel = ServiceLocator.shared.getService()
        if (model.id == user.id) {
            self.backgroundColor = UIColor(red: 0, green: 255, blue: 0, alpha: 0.25)
        } else {
            self.backgroundColor = UIColor.clear
        }
        
        self.positionLabel.text = "\(model.index)"
        
        proImage.isHidden = isProHidden
    }

}
