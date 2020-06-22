import UIKit
//import MBProgressHUD
import Inapps

class DMAnalyticsViewController: DMViewController, UICollectionViewDelegate, UICollectionViewDataSource, DMContainerDelegate {

    @IBOutlet weak var collectionView   : UICollectionView!
    @IBOutlet weak var subscriptionContainer : UIView!
    
    var companies = [CompanyModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.hideContainer()
        
        self.showActivityIndicator()
        
        CompanyDataProvider.default().get{ items, error in
            if let items = items {
                self.companies = items
                self.collectionView?.reloadData()
            }
            self.dismissActivityIndicator()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
        
        self.navigationController?.navigationBar.isHidden = false
//        setStatusBarBackgroundColor(.clear)
        
        let isSubscribed = StoreKitManager.default.isSubscribed(productId: ProductId.monthly.rawValue) ?? false
        if isSubscribed == false {
            
            let controller = UIStoryboard(name: "Subscription", bundle: nil).instantiateInitialViewController()!
            controller.modalPresentationStyle = .overFullScreen
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
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
  
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            layout.invalidateLayout()
            self.collectionView?.setCollectionViewLayout(layout, animated: true)
        }
    }
    
    private func setupUI() {
        let screenWidth = self.view.frame.size.width
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
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
    
    private func showCompanyDetail(company : CompanyModel) {
        let companyDetail = UIStoryboard(name: "Analytics", bundle: nil).instantiateViewController(withIdentifier: "DMCompanyDetailViewController") as! DMCompanyDetailViewController
        companyDetail.company = company
        self.navigationController?.pushViewController(companyDetail, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showCompanyDetail(company: companies[indexPath.row])
    }
    
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
