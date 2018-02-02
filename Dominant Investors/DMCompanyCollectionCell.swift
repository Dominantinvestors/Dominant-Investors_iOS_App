//
//  DMCompanyCollectionCell.swift
//  Dominant Investors
//
//  Created by Nekit on 18.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//


import Foundation
import UIKit

class DMCompanyCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var companyImage : UIImageView!
    @IBOutlet weak var companyNameLabel : UILabel!
    @IBOutlet weak var activity : UIActivityIndicatorView!
    
    var model : DMCompanyModel!
    
    override func awakeFromNib() {
        self.activity.hidesWhenStopped = true
        self.activity.startAnimating()
        super.awakeFromNib()
    }
    
    open func setupWith(model : DMCompanyModel) {
    
        self.model = model
        
        if (self.model.companyPictureURL != nil) {
            self.companyImage.image = self.model.companyPictureURL
            self.activity.stopAnimating()
            return
        }
        
        let image = DMFileManager.sharedInstance.getImageFromDocuments(filename: self.model.id)
        if (image != nil) {
            self.model.companyPictureURL = image
            self.companyImage.image = image
            self.activity.stopAnimating()
            return
        }
        
        DMAPIService.sharedInstance.downloadCompanyImageWith(ID: self.model.id) { (image, id) in
                    DispatchQueue.main.async {
                        if (id == self.model.id) {
                            self.model.companyPictureURL = image
                            self.companyImage.image = image
                            _ = DMFileManager.sharedInstance.saveToDocuments(obj: image, fileName: self.model.id)
                            self.activity.stopAnimating()
                        }
                    }
        }
    }
    
    open func cancelOperations() {
        self.model = nil
        self.companyImage.image = nil
        self.activity.startAnimating()
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancelOperations()
    }
}

