import UIKit
import Alamofire

class DMCompanyCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var companyImage : UIImageView!
    @IBOutlet weak var companyNameLabel : UILabel!
    @IBOutlet weak var activity : UIActivityIndicatorView!
    
    var model : CompanyModel!
    
    open func setupWith(model : CompanyModel) {
        self.model = model
        
        self.companyNameLabel.text = model.name
        
        if let logo = model.logo {
            self.activity.startAnimating()
            Alamofire.request(logo).responseImage { response in
                self.activity.stopAnimating()
                if let image = response.result.value {
                    self.companyImage.image = image
                }
            }
        }
    }
}

