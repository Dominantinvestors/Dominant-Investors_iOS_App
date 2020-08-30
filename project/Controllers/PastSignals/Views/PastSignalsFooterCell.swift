//
//  PastSignalsFooterCell.swift
//  DominantInvestors
//
//  Created by Andrew Konovalskiy on 30.08.2020.
//  Copyright © 2020 DS. All rights reserved.
//

import UIKit

final class PastSignalsFooterCell: UICollectionReusableView {
    
    // MARK: - IBOutlets
    @IBOutlet private var avgReturnLabel: UILabel!
    @IBOutlet private var totalReturnLabel: UILabel!
    
    // MARK: - Properties
    static let height: CGFloat = 120.0
    private let percentFormatter = NumberFormatter()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let locale = Locale(identifier: "en_US")
        percentFormatter.locale = locale
        percentFormatter.maximumFractionDigits = 2
        percentFormatter.positiveSuffix = "%"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = 8.0
    }
}

extension PastSignalsFooterCell {
    
    func configure(pastSignal: PastSignalModel) {
        avgReturnLabel.text = percentFormatter.string(from: NSNumber(value: pastSignal.avg))
        totalReturnLabel.text = percentFormatter.string(from: NSNumber(value: pastSignal.totalProfit))
    }
}
