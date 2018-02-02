//
//  DMTrialView.swift
//  Dominant Investors
//
//  Created by ios_nikitos on 27.11.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit

class DMTrialView: UIView {
    
    var delegate : DMRotatingViewController?

    open func addTo(superview : UIView) {
        self.alpha = 0
        self.frame = superview.bounds
        superview.addSubview(self)
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
        
        superview.bringSubview(toFront: self)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("kBuyedName"), object: nil, queue: nil) { (notification) in
            self.dissmisTrialView()
        }
    }
    
    open func dissmisTrialView() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        }
        NotificationCenter.default.removeObserver(self)
        self.removeFromSuperview()
    }
    
    //MARK : Action
    
    @IBAction func buyAction(sender : UIButton) {
        self.delegate?.buyApp()
    }
    
    @IBAction func restoreAction(sender : UIButton) {
        self.delegate?.showAlertWith(title: "Info".localized, message: "Nothing to restore".localized, cancelButton: false)
    }
    
    @IBAction func changeAccountAction(sender : UIButton) {
        self.delegate?.changeAccount()
    }

}
