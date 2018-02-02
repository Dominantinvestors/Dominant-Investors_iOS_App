//
//  DMDateService.swift
//  Dominant Investors
//
//  Created by Nekit on 22.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit

class DMDateService: NSObject {
    
    static let sharedInstance = DMDateService()

    var dateFormatter : DateFormatter!
    
    override init() {
        super.init()
        self.dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    open func dominantDateFrom(string : String) -> Date {
        return self.dateFormatter.date(from: string)!
    }
    
    open func dominantStringFrom(date : Date) -> String {
        return self.dateFormatter.string(from: date)
    }
    
    open func differenceBetweenDates(dateOne : Date, dateTwo : Date) -> String {
        
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day], from: dateOne, to: dateTwo)
        
        var answer = String(format: "(%d days)" ,components.day!)
        
        if (components.day! >= 30) {
            let month = components.day! / 30
            answer = String(format: "(%d month %d days)" ,month, components.day! % 30)
        }
        
        return answer
    }
}
