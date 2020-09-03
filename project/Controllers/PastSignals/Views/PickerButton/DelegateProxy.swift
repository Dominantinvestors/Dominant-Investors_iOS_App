//
//  DelegateProxy.swift
//  DominantInvestors
//
//  Created by Andrew Konovalskiy on 30.08.2020.
//  Copyright © 2020 DS. All rights reserved.
//

import UIKit

class DelegateProxy<Delegate: NSObjectProtocol>: NSObject {

    var delegate: Delegate? {
        return _delegate
    }
    private weak var _delegate: Delegate?

    init(_ delegate: Delegate?) {
        self._delegate = delegate
    }

    override func responds(to aSelector: Selector!) -> Bool {
        return super.responds(to: aSelector) || _delegate?.responds(to: aSelector) == true
    }

    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if _delegate?.responds(to: aSelector) == true {
            return _delegate
        } else {
            return super.forwardingTarget(for: aSelector)
        }
    }
}
