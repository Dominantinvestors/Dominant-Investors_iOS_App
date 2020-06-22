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

final class SubscriptionController: DMViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var monthlySubscription: UIButton!
    @IBOutlet private var annuallySubscription: UIButton!
    @IBOutlet private var pageControl: UIPageControl!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var discountView: UIView!
    
    // MARK: - Properties
    private let storeKit = StoreKitManager.default
    private let previewController = QLPreviewController()
    private var previewUrl: URL?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "SubscriptionCell", bundle: .main)
        collectionView.register(nib, forCellWithReuseIdentifier: "SubscriptionCell")
        
        previewController.dataSource = self

        checkInapps()
        setupButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discountView.layer.cornerRadius = discountView.bounds.midY
    }
}

// MARK: - Private methods
private extension SubscriptionController {
    
    func checkInapps() {
        guard storeKit.isSubscribed(productId: ProductId.monthly.rawValue) == true ||
            storeKit.isSubscribed(productId: ProductId.annually.rawValue) == true else {
                close(self)
                return
        }
        
        if storeKit.products?.isEmpty == true {
            let productIds = ProductId.allCases.map { $0.rawValue }
            storeKit.configure(productIds: productIds)
        }
    }
    
    func setupButtons() {
        var monthlyProduct = storeKit.products?.first { $0.id == ProductId.monthly.rawValue }
        monthlySubscription.setTitle(monthlyProduct?.localizedPrice, for: .normal)
        monthlySubscription.isEnabled = true
        
        var annuallyProduct = storeKit.products?.first { $0.id == ProductId.annually.rawValue }
        annuallySubscription.setTitle(annuallyProduct?.localizedPrice, for: .normal)
        annuallySubscription.isEnabled = true
        
        activityIndicator.stopAnimating()
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
}

// MARK: - Actions
private extension SubscriptionController {
    
    @IBAction func close(_ sender: Any) {
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
            .url(forResource: "Terms of Service", withExtension: "rtf")
        present(previewController, animated: true)
    }
    
    @IBAction func showTerms(_ sender: UIButton) {
        previewUrl = Bundle.main
            .url(forResource: "Privacy Policy", withExtension: "rtf")
        present(previewController, animated: true)
    }
    
    @IBAction func subscribeMonthly(_ sender: UIButton) {
        let monthlyId = ProductId.monthly.rawValue
        StoreKitManager.default.buy(productId: monthlyId,
                                    source: String(describing: self)) { [weak self] error in
                                        self?.handleError(error)
        }
    }
    
    @IBAction func subscribeAnnually(_ sender: UIButton) {
        let monthlyId = ProductId.annually.rawValue
        StoreKitManager.default.buy(productId: monthlyId,
                                    source: String(describing: self)) { [weak self] error in
                                        self?.handleError(error)
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
        
        let width = collectionView.bounds.width
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
