//
//  UIPickerViewDelegateProxy.swift
//  DominantInvestors
//
//  Created by Andrew Konovalskiy on 30.08.2020.
//  Copyright © 2020 DS. All rights reserved.
//

import UIKit

final class UIPickerViewDelegateProxy: DelegateProxy<UIPickerViewDelegate>, UIPickerViewDelegate {

    var titleChanged: ((TitleChangedInfo) -> Void)?

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let title = delegate?.pickerView?(pickerView, titleForRow: row, forComponent: component) {
            titleChanged?(TitleChangedInfo(title: title,
                                           row: row,
                                           component: component) )
        }
        delegate?.pickerView?(pickerView, didSelectRow: row, inComponent: component)
    }
}

extension UIPickerViewDelegateProxy {
    struct TitleChangedInfo {
        let title: String
        let row: Int
        let component: Int
    }
}
