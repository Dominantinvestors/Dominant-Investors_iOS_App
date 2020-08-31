//
//  PastSignalsController.swift
//  DominantInvestors
//
//  Created by Andrew Konovalskiy on 30.08.2020.
//  Copyright © 2020 DS. All rights reserved.
//

import UIKit
import PromiseKit

final class PastSignalsController: UIViewController {
    
    var pastSignal: PastSignalModel?
    var periods = [PastSignalsDateRangesModel]()
    var selectedPeriod: PastSignalsDateRangesModel?
    
    // MARK: - IBOutlets
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var collectionViewWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    var topViewHeight: CGFloat = .zero

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "PastSignalsCell", bundle: .main),
                                forCellWithReuseIdentifier: "PastSignalsCell")
        collectionView.register(UINib(nibName: "PastSignalsHeaderCell", bundle: .main),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "PastSignalsHeaderCell")
        collectionView.register(UINib(nibName: "PastSignalsFooterCell", bundle: .main),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: "PastSignalsFooterCell")
        
        if DeviceManager.device() == .iPhone40 {
            collectionViewWidthConstraint.constant = view.frame.width - 10
        }
        
        reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
}

private extension PastSignalsController {
    
    private func reloadData(_ needToShowIndecator: Bool = true) {
        if needToShowIndecator {
            showActivityIndicator()
        }
        firstly{ when(fulfilled: SignalsDataProvider.default().getPastSignal(),
                      SignalsDataProvider.default().getPastSignalsPeriods()) }
            .done { [weak self] pastSignal, periods in
                self?.pastSignal = pastSignal
                self?.periods = periods
                self?.collectionView.contentSize.height += PastSignalsFooterCell.height + PastSignalsHeaderCell.height
                
                if let period = periods.first(where: { $0.isDefault }) {
                    // Select default period in response as default
                    self?.didSelectChangePeriod(period)
                } else if let period = periods.first {
                    // Select first period in response as default
                    self?.didSelectChangePeriod(period)
                } else {
                    // If impossible to handle periods, we will show data for all time
                    self?.reloadData()
                }
            }.ensure {
                self.dismissActivityIndicator()
            }.catch {
                self.showAlertWith($0)
        }
    }
}

private extension PastSignalsController {
    
    @IBAction private func close(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension PastSignalsController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pastSignal?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PastSignalsCell",
                                                      for: indexPath) as? PastSignalsCell
        if let data = pastSignal?.data[indexPath.row] {
            cell?.configure(with: data)
        }
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PastSignalsHeaderCell", for: indexPath) as? PastSignalsHeaderCell
            if let selectedPeriod = self.selectedPeriod, let signal = self.pastSignal {
                header?.configure(with: selectedPeriod.title, pastSignal: signal, periods: periods)
                header?.delegate = self
            }
            return header ?? UICollectionReusableView()
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PastSignalsFooterCell", for: indexPath) as? PastSignalsFooterCell
            if let signal = self.pastSignal {
                footer?.configure(pastSignal: signal)
            }
            return footer ?? UICollectionReusableView()
        default:
            return UICollectionReusableView()
        }
    }
}


extension PastSignalsController: UICollectionViewDelegate {
    
}

extension PastSignalsController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: PastSignalsCell.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: PastSignalsHeaderCell.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: PastSignalsFooterCell.height)
    }
}

extension PastSignalsController: PastSignalsHeaderCellDelegate {
    
    func didSelectChangePeriod(_ period: PastSignalsDateRangesModel) {
        
        guard selectedPeriod != period else {
            return
        }
        
        selectedPeriod = period
        
        showActivityIndicator()
        firstly{ when(fulfilled: [SignalsDataProvider.default().getPastSignal(startDate: period.startDate, endDate: period.endDate)]) }
            .done { [weak self] result in
                
                if let pastSignal = result.first {
                    self?.pastSignal = pastSignal
                    self?.collectionView.reloadData()
                }
            }.ensure { [weak self] in
                self?.dismissActivityIndicator()
            }.catch { [weak self] in
                self?.showAlertWith($0)
            }
    }
    
    func didSelectSubscrube(_ header: PastSignalsHeaderCell) {
        close(self)
    }
}
