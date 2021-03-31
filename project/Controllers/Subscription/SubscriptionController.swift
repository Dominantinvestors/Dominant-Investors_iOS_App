//
//  SubscriptionController.swift
//  Inapps
//
//  Created by Andrew Konovalskiy on 18.06.2020.
//  Copyright © 2020 DS. All rights reserved.
//

import UIKit
import Inapps
import QuickLook
import AppsFlyerLib
import StoreKit

final class SubscriptionController: DMViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var monthlySubscriptionButton: UIButton!
    @IBOutlet private var annuallySubscriptionButton: UIButton!
    @IBOutlet private var pastResultButton: UIButton!
    @IBOutlet private var pageControl: UIPageControl!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var discountView: UIView!
    @IBOutlet private var tryFreeView: UIView!
    @IBOutlet private var logoImageView: UIImageView!
    @IBOutlet private var buttonHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var discountLabel: UILabel!
    
    // MARK: - Properties
    private let storeKit = StoreKitManager.default
    private var previewUrl: URL?
    private var isSubscribed: Bool = false
    private let eventName = "successfullySubscribed"
    var closeCompletion: ((_ isSubscribed: Bool) -> Void)?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let nib = UINib(nibName: "SubscriptionCell", bundle: .main)
        collectionView.register(nib, forCellWithReuseIdentifier: "SubscriptionCell")
        pageControl.numberOfPages = SubscriptionItem.allCases.count

        checkInapps()
        setupButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discountView.layer.cornerRadius = discountView.bounds.midY
        tryFreeView.layer.cornerRadius = tryFreeView.bounds.midY
        monthlySubscriptionButton.layer.cornerRadius = 8.0
        annuallySubscriptionButton.layer.cornerRadius = 8.0
        pastResultButton.layer.cornerRadius = pastResultButton.bounds.midY
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

// MARK: - Private methods
private extension SubscriptionController {
    
    func checkInapps() {
        guard storeKit.isSubscribed(productId: ProductId.monthly.rawValue) == false ||
            storeKit.isSubscribed(productId: ProductId.annually.rawValue) == false else {
                isSubscribed = true
                close(self)
            return
        }

        if (storeKit.products?.isEmpty == true ||
            storeKit.products == nil), storeKit.isLoadingProducts {
            startLoading()
            storeKit.productsLoadCompletion = { [weak self] error in
                if let error = error {
                    self?.handleError(error)
                }
                
                self?.endLoading()
                self?.setupButtons()
            }
        }
    }
    
    func setupButtons() {
        let monthlyProduct = storeKit.products?.first { $0.id == ProductId.monthly.rawValue }
        if let monthlyPrice = monthlyProduct?.localizedPrice {
            let monthlyPriceString = ("\(monthlyPrice)/Month")
            monthlySubscriptionButton.setTitle(monthlyPriceString, for: .normal)
            monthlySubscriptionButton.isEnabled = true
        }
        
        if let annuallyProduct = storeKit.products?
            .first(where: { $0.id == ProductId.annually.rawValue }),
           let annuallyPrice = annuallyProduct.localizedPrice {
            let annuallyPriceString = ("\(annuallyPrice)/Year")
            annuallySubscriptionButton.setTitle(annuallyPriceString, for: .normal)
            annuallySubscriptionButton.isEnabled = true
            
            let monthlyPrice = monthlyProduct?.price ?? 0
            let discountValue = (monthlyPrice as Decimal * 12) - (annuallyProduct.price as Decimal)
            
            let formatter = NumberFormatter()
            formatter.locale = annuallyProduct.priceLocale
            formatter.numberStyle = .currency
            formatter.roundingMode = .halfUp
            formatter.generatesDecimalNumbers = false
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 0
        
            if let formattedValue = formatter.string(from: NSDecimalNumber(decimal: discountValue)) {
                
                discountLabel.text = "Save \(formattedValue)"
                discountView.isHidden = false
            } else {
                discountView.isHidden = true
            }
        } else {
            discountView.isHidden = true
        }
        pastResultButton.layer.borderWidth = 1.5
        pastResultButton.layer.borderColor = UIColor.red.cgColor
        
        /* tryFreeView.isHidden = false */ // Temporary hidden forever
    }
    
    func handleError(_ error: Error?) {
        if let error = error {
            showAlert(with: error.localizedDescription)
        }
    }
    
    func showAlert(with message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: "Ok", style: .default) { _ in }
        alertController.addAction(button)
        present(alertController, animated: false, completion: nil)
    }
    
    func startLoading() {
        monthlySubscriptionButton.isEnabled = false
        monthlySubscriptionButton.setTitle(nil, for: .normal)
        annuallySubscriptionButton.isEnabled = false
        annuallySubscriptionButton.setTitle(nil, for: .normal)
        discountView.isHidden = true
        tryFreeView.isHidden = true
        activityIndicator.startAnimating()
    }
    
    func endLoading() {
        setupButtons()
        activityIndicator.stopAnimating()
    }
}

// MARK: - Actions
private extension SubscriptionController {
    
    @IBAction func close(_ sender: Any) {
        closeCompletion?(isSubscribed)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showInfo(_ sender: UIButton) {
        let id = String(describing: SubscriptionInfoController.self)
        guard let controller = storyboard?
            .instantiateViewController(withIdentifier: id) else {
            return
        }
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func showPrivacy(_ sender: UIButton) {
        previewUrl = Bundle.main
            .url(forResource: "Privacy Policy", withExtension: "rtf")
        let previewController = QLPreviewController()
        previewController.dataSource = self
        previewController.currentPreviewItemIndex = 0
        present(previewController, animated: true)
    }
    
    @IBAction func showTerms(_ sender: UIButton) {
        previewUrl = Bundle.main
            .url(forResource: "Terms of Service", withExtension: "rtf")
        let previewController = QLPreviewController()
        previewController.dataSource = self
        previewController.currentPreviewItemIndex = 0
        present(previewController, animated: true)
    }
    
    @IBAction func subscribeMonthly(_ sender: UIButton) {
        let monthlyId = ProductId.monthly.rawValue
        startLoading()
        StoreKitManager.default.buy(productId: monthlyId,
                                    source: String(describing: self)) { [weak self] result in
            
            guard let self = self else {
                return
            }
            
            self.endLoading()
            switch result {
            case .success:
                self.isSubscribed = true
                var values: [String: Any] = ["type": "monthly"]
                if let email = UserDefaults.standard.string(forKey: ConstantsUserDefaults.userEmail) {
                    values["email"] = email
                }
                AppsFlyerTracker.shared().trackEvent(AFEventPurchase, withValues: values)
                AppsFlyerTracker.shared().trackEvent(self.eventName,
                                                     withValues: values)
                self.close(self)
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
    
    @IBAction func subscribeAnnually(_ sender: UIButton) {
        let monthlyId = ProductId.annually.rawValue
        startLoading()
        StoreKitManager.default.buy(productId: monthlyId,
                                    source: String(describing: self)) { [weak self] result in
            
            guard let self = self else {
                return
            }
            
            self.endLoading()
            switch result {
            case .success:
                self.isSubscribed = true
                
                var values: [String: Any] = ["type": "annually"]
                if let email = UserDefaults.standard.string(forKey: ConstantsUserDefaults.userEmail) {
                    values["email"] = email
                }
                AppsFlyerTracker.shared().trackEvent(AFEventPurchase, withValues: values)
                AppsFlyerTracker.shared().trackEvent(self.eventName,
                                                     withValues: values)
                self.close(self)
            case .failure(let error):
                if let error = error as? SKError,
                   error.code == .paymentCancelled {
                    return
                }
                self.handleError(error)
            }
        }
    }
    
    @IBAction func restorePurchases(_ sender: UIButton) {
        startLoading()
        sender.isEnabled = false
        StoreKitManager.default.restore { [unowned self] subscribtion, error in
            endLoading()
            sender.isEnabled = true
            if let error = error {
                self.handleError(error)
                return
            } else {
                self.close(self)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension SubscriptionController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SubscriptionItem.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "SubscriptionCell",
            for: indexPath) as? SubscriptionCell else {
                fatalError("Can't init SubscriptionCell")
        }
        
        let item = SubscriptionItem.allCases[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SubscriptionController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SubscriptionController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.size.width
        return CGSize(width: width, height: SubscriptionCell.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}

// MARK: - UIScrollViewDelegate
extension SubscriptionController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

// MARK: - QLPreviewControllerDataSource
extension SubscriptionController: QLPreviewControllerDataSource {
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        
        guard let url = previewUrl else {
            fatalError("Could not load \(index).pdf")
        }

        return url as QLPreviewItem
    }
}
