import UIKit
import Alamofire

class DMCompanyCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var companyImage : UIImageView!
    @IBOutlet weak var logoImage : UIImageView!
    @IBOutlet weak var activity : UIActivityIndicatorView!
    
    var model : CompanyModel!
    
    open func setupWith(model : CompanyModel) {
        self.model = model
        
        self.companyImage.image = UIImage(named: "Ellipse 4")
        self.logoImage.image = nil

        if let imageUrl = model.image {
            self.activity.startAnimating()
            
            Alamofire.request(imageUrl).responseImage { response in
                if let image = response.result.value {
                    self.companyImage.image = image
                }
                self.activity.stopAnimating()
            }
        }
    }
}

