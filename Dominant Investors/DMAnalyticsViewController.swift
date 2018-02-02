//
//  DMAnalyticsViewController.swift
//  Dominant Investors
//
//  Created by Nekit on 19.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit
import MBProgressHUD

class DMAnalyticsViewController: DMViewController, UICollectionViewDelegate, UICollectionViewDataSource, DMContainerDelegate {

    @IBOutlet weak var collectionView   : UICollectionView!
    @IBOutlet weak var subscriptionContainer : UIView!
    
    
    var companies = [DMCompanyModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.hideContainer()
        
        self.showActivityIndicator()
        DMAPIService.sharedInstance.getAnalyticsCompanies { (companies) in
            DispatchQueue.main.async {
                self.companies = companies.reversed()
                self.collectionView?.reloadData()
                self.dismissActivityIndicator()
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "contanerSegue" {
            let description = segue.destination as! DMSubscriptionViewController
            description.delegate = self
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        updateCollectionViewLayout(with: size)
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    private func updateCollectionViewLayout(with size: CGSize) {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
           
            layout.itemSize = (size.width < size.height) ?
                CGSize(width: size.width/2, height: size.width/2) :
                CGSize(width: size.width/3, height: size.width/3)
  
            layout.sectionInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            layout.invalidateLayout()
            self.collectionView?.setCollectionViewLayout(layout, animated: true)
        }
    }
    
    // MARK: Private
    
    private func setupUI() {
        let screenWidth = self.view.frame.size.width
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        var inlineCellsCount : CGFloat = 3
        
        if (UIDevice.current.orientation.isPortrait || UIApplication.shared.statusBarOrientation == .portrait) {
            inlineCellsCount = 2
        }
    
        layout.itemSize = CGSize(width: screenWidth/inlineCellsCount, height: screenWidth/inlineCellsCount)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        self.collectionView?.setCollectionViewLayout(layout, animated: false)
        
        let cellNib = UINib.init(nibName: "DMCompanyCollectionCell", bundle: Bundle.main)
        self.collectionView?.register(cellNib, forCellWithReuseIdentifier:"DMCompanyCollectionCell")
    }
    
    private func showCompanyDetail(company : DMCompanyModel) {
        let companyDetail = UIStoryboard(name: "Analytics", bundle: nil).instantiateViewController(withIdentifier: "DMCompanyDetailViewController") as! DMCompanyDetailViewController
        companyDetail.company = company
        self.navigationController?.pushViewController(companyDetail, animated: true)
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showCompanyDetail(company: companies[indexPath.row])
    }

    // MARK: UICollectonViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return companies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DMCompanyCollectionCell", for: indexPath) as! DMCompanyCollectionCell
        let company = self.companies[indexPath.row]
        cell.setupWith(model: company)
        return cell
    }
    
    // MARK: DMContainerDelegate
    
    internal func hideContainer() {
        self.subscriptionContainer.isHidden = true

    }
    
    internal func showContainer() {
        self.subscriptionContainer.isHidden = false
        
    }
    
    internal func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
 
}
