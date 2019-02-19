import UIKit
import Alamofire

class DMCompanyCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var companyImage : UIImageView!
    @IBOutlet weak var logoImage : UIImageView!
    @IBOutlet weak var activity : UIActivityIndicatorView!
    
    var model : CompanyModel!
    
    open func setupWith(model : CompanyModel) {
        self.model = model
        
        self.logoImage.image = nil
        
        self.companyImage.image = UIImage(named: "Ellipse 4")

        if let imageUrl = model.image {
            self.activity.startAnimating()
            self.companyImage.loadImage(imageUrl, done: { image in
                self.companyImage.image = image
                self.activity.stopAnimating()
            }, error: {
                self.activity.stopAnimating()
            })
        }
    }
}

