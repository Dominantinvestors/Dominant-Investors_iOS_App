//
//  DMTrialUsageView.swift
//  Dominant Investors
//
//  Created by ios_nikitos on 29.11.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit

class DMTrialUsageView: UIView {
    
    var delegate : DMViewController?

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
                let introView = Bundle.main.loadNibNamed("DMInfoIntroView", owner: nil, options: nil)![0] as! DMInfoIntroView
                introView.addTo(superview: self.superview!)
                self.removeFromSuperview()
            }
        }
    }
    
    //MARK : Action
    
    @IBAction func startTrialAction(sender : UIButton) {
        DMAPIService.sharedInstance.startTrialPeriod(date: Date()) { (trialObject) in
                self.dissmisTrialView()
        }
    }

}
