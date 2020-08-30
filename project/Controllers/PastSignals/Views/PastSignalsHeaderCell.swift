//
//  PastSignalsHeaderCell.swift
//  DominantInvestors
//
//  Created by Andrew Konovalskiy on 30.08.2020.
//  Copyright © 2020 DS. All rights reserved.
//

import UIKit

protocol PastSignalsHeaderCellDelegate: AnyObject {
    func didSelectChangePeriod(_ period: PastSignalsDateRangesModel)
    func didSelectSubscrube(_ header: PastSignalsHeaderCell)
}

final class PastSignalsHeaderCell: UICollectionReusableView {
    
    // MARK: - IBOutlets
    @IBOutlet private var periodButton: PickerButton!
    @IBOutlet private var totalTransactionsLabel: UILabel!
    @IBOutlet private var avgTradeReturn: UILabel!
    @IBOutlet private var totalReturn: UILabel!
    @IBOutlet private var subscribeButton: UIButton!
    @IBOutlet private var backView: UIView!
    
    // MARK: - Properties
    static let height: CGFloat = 350.0
    weak var delegate: PastSignalsHeaderCellDelegate?
    private var periods = [PastSignalsDateRangesModel]()
    private var selectedPeriodIndex = 0
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
        
        periodButton.delegate = self
        periodButton.dataSource = self
        periodButton.closeHandler = { [weak self] in
            guard let self = self else {
                return
            }
            self.delegate?.didSelectChangePeriod(self.periods[self.selectedPeriodIndex])
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closePicker))
        addGestureRecognizer(tapGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        periodButton.layer.cornerRadius = 6.0
        backView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backView.layer.cornerRadius = 8.0
        subscribeButton.layer.cornerRadius = 8.0
    }
}

private extension PastSignalsHeaderCell {
    
    @IBAction func closePicker() {
        if let closeButton = periodButton.closeButton {
            periodButton.didTapClose(closeButton)
        }
    }
    
    @IBAction func subscribe(_ sender: UIButton) {
        delegate?.didSelectSubscrube(self)
    }
}

extension PastSignalsHeaderCell {
    
    func configure(with title: String, pastSignal: PastSignalModel, periods: [PastSignalsDateRangesModel]) {
        periodButton.setTitle(title, for: .normal)
        totalTransactionsLabel.text = numberFormatter.string(from: NSNumber(value: pastSignal.totalTransactions))
        avgTradeReturn.text = numberFormatter.string(from: NSNumber(value: pastSignal.avg))
        totalReturn.text = percentFormatter.string(from: NSNumber(value: pastSignal.totalProfit))
        self.periods = periods
    }
}

extension PastSignalsHeaderCell: UIPickerViewDelegate, UIPickerViewDataSource {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return periods[row].title
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return periods.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let title = periods[row].title
        selectedPeriodIndex = row
        periodButton.setTitle(title, for: .normal)
    }
}
