//
//  ChartView.swift
//  Dominant Investors
//
//  Created by Nekit on 19.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit

protocol ChartViewDelegate {
    func didChangeTimeRange(range: ChartTimeRange)
}

class ChartView: UIView {
    
    @IBOutlet weak var btnIndicatorView : UIView!
    @IBOutlet weak var stackView        : UIStackView!
    var delegate: ChartViewDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnIndicatorView.backgroundColor = UIColor.clear
    }
    
    class func create() -> ChartView {
        let chartView = UINib(nibName: "ChartView", bundle:nil).instantiate(withOwner: nil, options: nil)[0] as! ChartView
        chartView.btnIndicatorView.layer.cornerRadius = 15
        
        return chartView
    }
    
    @IBAction func timeRangeBtnTapped(sender: AnyObject) {
        
        let btn = sender as! UIButton
       
        btnIndicatorView.frame = btn.frame

        var range: ChartTimeRange = .OneDay
        
        switch btn.tag {
        case 1:
            range = .OneDay
        case 2:
            range = .FiveDays
        case 3:
            range = .TenDays
        case 4:
            range = .OneMonth
        case 5:
            range = .ThreeMonths
        case 6:
            range = .OneYear
        case 7:
            range = .FiveYears
        default:
            range = .OneDay
        }
        
        delegate.didChangeTimeRange(range: range)
        
        for view in self.stackView.subviews {
            
            if view is UIButton {
                let subBtn = view as! UIButton
                if btn.tag == subBtn.tag {
                    subBtn.setTitleColor(UIColor.red, for: .normal)
                    subBtn.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
                } else {
                    subBtn.setTitleColor(UIColor.white, for: .normal)
                    subBtn.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 14)
                }
                
            }
        
        }
    }
}
