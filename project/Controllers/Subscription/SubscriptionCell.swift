//
//  SubscriptionCell.swift
//  Inapps
//
//  Created by Andrew Konovalskiy on 18.06.2020.
//  Copyright © 2020 DS. All rights reserved.
//

import UIKit

final class SubscriptionCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var descriptionLabel: UILabel!
    
    // MARK: - Properties
    static let height: CGFloat = 295.0

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with item: SubscriptionItem) {
        titleLabel.text = item.title
        imageView.image = item.image
        descriptionLabel.text = item.description
    }
}
