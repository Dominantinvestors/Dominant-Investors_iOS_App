//
//  SubscriptionInfoController.swift
//  DominantInvestors
//
//  Created by Andrew Konovalskiy on 22.06.2020.
//  Copyright © 2020 DS. All rights reserved.
//

import UIKit

final class SubscriptionInfoController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var closeButton: UIButton!
    @IBOutlet private var backContainerView: UIView!

    // MARK: - Lifecylce
    override func awakeFromNib() {
        super.awakeFromNib()
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backContainerView.clipsToBounds = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backContainerView.layer.cornerRadius = 8.0
    }
}

private extension SubscriptionInfoController {
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
