//
//  DMInfoIntroView.swift
//  Dominant Investors
//
//  Created by ios_nikitos on 03.12.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit

class DMInfoIntroView: UIView {

    open func addTo(superview : UIView) {
        self.alpha = 0
        self.frame = superview.bounds
        superview.addSubview(self)
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
        superview.bringSubview(toFront: self)
    }
    
    open func dissmisTrialView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }) { (completed) in
                self.removeFromSuperview()
            }
        }
    }
    
    @IBAction func closePopUp(sender : UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("kShowHSignalsHistory"), object: nil)
        self.dissmisTrialView()
    }

}
