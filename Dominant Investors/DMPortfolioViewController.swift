//
//  DMPortfolioViewController.swift
//  Dominant Investors
//
//  Created by Nekit on 19.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit
import MBProgressHUD


class DMPortfolioViewController: DMViewController, DMDropdownListDelegate, DMPortfolioUserInterface, UITextFieldDelegate {

    var refreshControl         : UIRefreshControl!
    var dropdownViewController : DMDropdownViewController!
    
    var searchResults = [StockSearchResult]()
    var total = 0.0

    var formatter = DateFormatter()
    var loaded = false
    
    var portfolioType  = DMPortfolioType.DMPersonalPortfolio
    var actionType     = DMActionType.DMAddNewStockAction
    
    // MARK: Outlets
    @IBOutlet  weak var tickerField              : UITextField!
    
    @IBOutlet  weak var firstHeaderHeight        : NSLayoutConstraint!
    @IBOutlet  weak var secondHeaderHeight       : NSLayoutConstraint!
    @IBOutlet  weak var dropdownListHeight       : NSLayoutConstraint!
    
    @IBOutlet  weak var portfolioTypeSwitcher    : UISegmentedControl!
    
    @IBOutlet  weak var searchDropdown         : UIView!
    @IBOutlet  weak var firstContainer         : UIView!
    @IBOutlet  weak var secondContainer        : UIView!
    @IBOutlet  weak var dominantImageContainer : UIView!
    @IBOutlet  weak var searchBarContainer     : UIView!
    @IBOutlet  weak var dropShadowView         : UIView!
    
    @IBOutlet  weak var fisrtColumnTitle    : UILabel!
    @IBOutlet  weak var secondColumnTitle   : UILabel!
    @IBOutlet  weak var thirdColumnTitle    : UILabel!
    @IBOutlet  weak var fourthColumnTitle   : UILabel!
//  @IBOutlet  weak var userNickNameLabel   : UILabel!
    
    @IBOutlet  weak var dominantButton      : UIView!
    @IBOutlet  weak var personalButton      : UIView!
    
    @IBOutlet  weak var tableView           : UITableView!
    @IBOutlet  weak var scrollView          : UIScrollView!
    @IBOutlet  weak var tableViewHeight     : NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.switchToSignalsHistory), name: NSNotification.Name(rawValue: "kShowHSignalsHistory"), object: nil)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshData()
        if (!loaded) {
            showPersonal()
            
        }
    }
    
    override func refreshData() {
        if (self.loaded) {
            self.showActivityIndicator()
            showPersonal()
            DMPersonalPortfolioService.sharedInstance.reloadEmptyData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if (segue.identifier == "containerSegue") {
            self.dropdownViewController = segue.destination as! DMDropdownViewController
            self.dropdownViewController.portfolioController = self
        }
    }

    // MARK: Private
    
    private func setupUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tableView.register(UINib(nibName: "DMStockCell", bundle: Bundle.main), forCellReuseIdentifier: "DMStockCell")
        self.tableView.register(UINib(nibName: "DMPortfolioTotalCell", bundle: Bundle.main), forCellReuseIdentifier: "DMPortfolioTotalCell")
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
        self.refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
        
    
        self.personalButton.layer.borderWidth = 1
        self.dominantButton.layer.borderWidth = 1
        
        self.firstContainer.layer.borderWidth = 1
        self.firstContainer.layer.borderColor = UIColor.lightGray.cgColor
        
        self.searchDropdown.layer.borderWidth = 1
        self.searchDropdown.layer.borderColor = UIColor.lightGray.cgColor
        
        self.searchBarContainer.layer.borderWidth = 1
        self.searchBarContainer.layer.borderColor = UIColor.init(white: 0.3, alpha: 1).cgColor
        
        self.tableView.tableFooterView = UIView()
        
//      self.userNickNameLabel.text = DMAuthorizationManager.sharedInstance.userProfile.userName
        
        self.tickerField.delegate = self
    }
    
    @objc private func refresh(sender : UIRefreshControl) {
        if (self.portfolioType == .DMPersonalPortfolio) {
            DMPersonalPortfolioService.sharedInstance.renewPersonalData()
        } else {
            self.refreshControl.endRefreshing()
        }
    }
    
    private func showPersonal() {
        
        self.tableView.delegate   = DMPersonalPortfolioService.sharedInstance
        self.tableView.dataSource = DMPersonalPortfolioService.sharedInstance
        
        DMPersonalPortfolioService.sharedInstance.userInterface = self
        
        self.reloadData()
        
        UIView.animate(withDuration: 1) {
            self.firstHeaderHeight.constant  = 80
            self.secondHeaderHeight.constant = 0 //175
            self.firstContainer.alpha = 1
            self.dominantImageContainer.alpha = 0 //1
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
       
        self.dominantButton.layer.borderColor = UIColor.clear.cgColor
        self.personalButton.layer.borderColor = UIColor.red.cgColor
        
        self.setColumnTitles(titles: ["TICKER","BUY\nPOINT $","CURRENT PRICE $","PROFITABILITY"])
        self.scrollView.addSubview(self.refreshControl)
        self.portfolioTypeSwitcher.selectedSegmentIndex = 1
        self.portfolioType = .DMPersonalPortfolio
    }
    
    private func showDominant() { // NOW DEPRECATED, NOW APP SHOWS SignalHistory 
        
        self.tableView.delegate   = DMDominantPortfolioService.sharedInstance
        self.tableView.dataSource = DMDominantPortfolioService.sharedInstance
        
        DMDominantPortfolioService.sharedInstance.userInterface = self
        
        self.reloadData()
        
        UIView.animate(withDuration: 1) {
            self.firstHeaderHeight.constant  = 0
            self.dominantImageContainer.alpha = 0
            self.firstContainer.alpha = 0
            self.secondHeaderHeight.constant = 0
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
        
        hideDropdownList()
        
        self.dominantButton.layer.borderColor = UIColor.red.cgColor
        self.personalButton.layer.borderColor = UIColor.clear.cgColor
  
        self.setColumnTitles(titles: ["TICKER","EXCHANGE","CURRENT PRICE $","PROFITABILITY"])
        self.refreshControl.removeFromSuperview()
        //self.portfolioType = .DMDominantPortfolio
    }
    
    @objc private func showSignalsHistory() {
        
        self.tableView.delegate   = DMSignalsHistoryService.sharedInstance
        self.tableView.dataSource = DMSignalsHistoryService.sharedInstance
        
        DMDominantPortfolioService.sharedInstance.userInterface = self
        self.showActivityIndicator()
        
        self.reloadData()
        
        UIView.animate(withDuration: 1) {
            self.firstHeaderHeight.constant  = 0
            self.dominantImageContainer.alpha = 1
            self.firstContainer.alpha = 0
            self.secondHeaderHeight.constant = 155
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
        
        hideDropdownList()
        
        self.dominantButton.layer.borderColor = UIColor.red.cgColor
        self.personalButton.layer.borderColor = UIColor.clear.cgColor
        
        self.setColumnTitles(titles: ["TICKER","BUY POINT $","SELL POINT $","PROFITABILITY"])
        self.refreshControl.removeFromSuperview()
        self.portfolioTypeSwitcher.selectedSegmentIndex = 0
        self.portfolioType = .DMSignalsHistory
    }
    
    @objc private func switchToSignalsHistory() {
        self.showSignalsHistory()
        DMSignalsHistoryService.sharedInstance.refresh {
            self.showSignalsHistory()
        }
    }
    
    private func setColumnTitles(titles : [String]) {
        self.fisrtColumnTitle.text  = titles[0]
        self.secondColumnTitle.text = titles[1]
        self.thirdColumnTitle.text  = titles[2]
        self.fourthColumnTitle.text = titles[3]
    }
    
    private func resizeTableView() {
        self.tableViewHeight.constant = self.tableView.contentSize.height >= scrollView.frame.height ? self.tableView.contentSize.height : scrollView.frame.height+20
        self.dismissActivityIndicator()
    }

    // MARK: Actions
    
    @IBAction func logOutButtonPressed(sender : UIButton) {
        DMAuthorizationManager.sharedInstance.signOut()
        DMPersonalPortfolioService.sharedInstance.changeUser()
        
        let auth = UIStoryboard(name: "Authorization", bundle: nil).instantiateInitialViewController()
        let navigation = UINavigationController.init(rootViewController: auth!)
        navigation.setNavigationBarHidden(true, animated: false)
        self.present(navigation, animated: true, completion: nil)
    }
    
    @IBAction func portfolioTypeChanged(sender : UISegmentedControl) {
        self.portfolioType == .DMPersonalPortfolio ? showSignalsHistory() : showPersonal()
        
        //TIP #1 : For Dominant portfolio feature.
        
        //self.portfolioType == .DMPersonalPortfolio ? showDominant() : showPersonal()
    }
    
    @IBAction func addTickerAction(sender : UIButton) {
        self.view.isUserInteractionEnabled = false
        self.actionType = DMActionType.DMAddNewStockAction
        if (DMPersonalPortfolioService.sharedInstance.selectedTicker == nil) {
            self.showAlertWith(title:   NSLocalizedString("Empty ticker", comment: ""),
                               message: NSLocalizedString("Please type and select new ticker!", comment: ""),
                               cancelButton: false)
            self.view.isUserInteractionEnabled = true
                               return
        }
        
        self.showActivityIndicator()
        DMPersonalPortfolioService.sharedInstance.addNew()
        
        self.tickerField.text = ""
    }
    
    @IBAction func createNewPortfolio(sender : UIButton) {
        self.actionType = DMActionType.DMClearPortfolioAction
        self.showAlertWith(title:   NSLocalizedString("Clear current portfolio", comment: ""),
                           message: NSLocalizedString("Do you want to clear your portfolio?", comment: ""),
                           cancelButton: true)
    }
    
    @IBAction func goToSignals(sender : UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kShowSignals"), object: nil)
    }
    
    private func showDropdownList(listHeight : Int, tickers : [StockSearchResult]) {
        self.dropdownViewController.dataSource = tickers
        self.dropdownViewController.tableView.reloadData()
        
        UIView.animate(withDuration: 0.4) {
            self.dropdownListHeight.constant = CGFloat(30 * listHeight)
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideDropdownList() {
        UIView.animate(withDuration: 0.4) {
            self.dropdownListHeight.constant = 0
            self.tickerField.resignFirstResponder()
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: UITextFieldDelegate (Actions)
    
    @IBAction func tickerInputHandler(sender : UITextField) {
        if (sender.text?.length == 0) {
            DMPersonalPortfolioService.sharedInstance.selectedTicker = nil
            hideDropdownList()
        } else {
            SwiftStockKit.fetchStocksFromSearchTerm(term: sender.text!) { (stockInfoArray) -> () in
                DispatchQueue.main.async {
                    self.showDropdownList(listHeight: stockInfoArray.count, tickers: stockInfoArray)
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (DMPersonalPortfolioService.sharedInstance.selectedTicker == nil) {
            self.hideDropdownList()
            textField.text = ""
            textField.resignFirstResponder()
        } else {
            self.addTickerAction(sender: UIButton())
        }
        return false
    }
    
    // MARK: DMDropdownListDelegate
    
    func tickerDidSelected(stock : StockSearchResult) {
        self.hideDropdownList()
        self.tickerField.text = stock.symbol
        DMPersonalPortfolioService.sharedInstance.selectedTicker = stock
        self.tickerField.resignFirstResponder()
    }
    
    // MARK: DMPortfolioUserInterface 
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.resizeTableView()
            self.dismissActivityIndicator()
        }
    }
    
    func didReloaded() {
        DispatchQueue.main.async {
            self.loaded = true
            self.view.isUserInteractionEnabled = true
            self.dismissActivityIndicator()
            self.refreshControl.endRefreshing()
        }
    }
    
    func showStockDetail(controller : DMStockDetailViewController) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showStockChart(vc : DMTradingViewChartViewController) {
       
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.white
        ]
        navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 16/255, green: 18/255, blue: 26/255, alpha: 1)
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showError(message: String) {
        self.showAlertWith(title: "Error".localized, message: message, cancelButton: false)
    }

    // MARK: UIAlertViewController action
    
    override func okAction() {
        if (self.actionType == .DMClearPortfolioAction) {
            DMPersonalPortfolioService.sharedInstance.clearPortfolio()
        }
    }
}
