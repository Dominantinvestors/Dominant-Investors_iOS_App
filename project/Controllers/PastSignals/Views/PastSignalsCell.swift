//
//  PastSignalsCell.swift
//  DominantInvestors
//
//  Created by Andrew Konovalskiy on 30.08.2020.
//  Copyright © 2020 DS. All rights reserved.
//

import UIKit

final class PastSignalsCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private var tickerLabel: UILabel!
    @IBOutlet private var buyPointLabel: UILabel!
    @IBOutlet private var sellPointLabel: UILabel!
    @IBOutlet private var profitabilityLabel: UILabel!
    
    // MARK: - Properties
    static let height: CGFloat = 28.0
    private let numberFormatter = NumberFormatter()
    private let percentFormatter = NumberFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let locale = Locale(identifier: "en_US")
        numberFormatter.locale = locale
        numberFormatter.maximumFractionDigits = 1
        
        percentFormatter.locale = locale
        percentFormatter.maximumFractionDigits = 2
        percentFormatter.positiveSuffix = "%"
        percentFormatter.negativeSuffix = "%"
    }
}

extension PastSignalsCell {
    
    func configure(with data: PastSignalData) {
        tickerLabel.text = data.ticker
        buyPointLabel.text = numberFormatter.string(from: NSNumber(value: data.buyPoint))
        sellPointLabel.text = numberFormatter.string(from: NSNumber(value: data.sellPoint))
        profitabilityLabel.text = percentFormatter.string(from: NSNumber(value: data.profitability))
        
        profitabilityLabel.textColor = data.profitability >= 0 ? #colorLiteral(red: 0, green: 1, blue: 0.09803921569, alpha: 1) : #colorLiteral(red: 0.9176470588, green: 0.2980392157, blue: 0.2980392157, alpha: 1)
    }
}
