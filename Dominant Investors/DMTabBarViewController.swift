//
//  DMTabBarViewController.swift
//  Dominant Investors
//
//  Created by Nekit on 19.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

// TIP : NOT WORKS (LOOK DMRotatingVewController) !!!

import UIKit

class DMTabBarViewController: DMViewController {

    var viewControllers : [DMViewController]!
    var buttons         = [UIButton]()
    var containers      = [UIView]()
    var loaded          = false

    let tabIcons    = [UIImage(named: "analytic"), UIImage(named: "folio"), UIImage(named: "ideas")]
    let activeIcons = [UIImage(named: "analytic_active"), UIImage(named: "folio_active"), UIImage(named: "ideas_active")]
    
    // MARK: Outlets
    @IBOutlet weak var loadImage    : UIImageView!
    @IBOutlet weak var tabContainer : UIView!
    @IBOutlet weak var stackView    : UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadImage.alpha = 1
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (!loaded) {
            setupChildControllers()
            setupTabButtons()
            showDefaultPage()
            loaded = true
            UIView.animate(withDuration: 1) {
                self.loadImage.alpha = 0
            }
        }
    }
    
    // MARK: Private
    
    private func setupTabButtons() {
        for index in 0...self.viewControllers.count - 1 {
            let newButton = UIButton()
            newButton.setImage(tabIcons[index], for: .normal)
            newButton.imageView?.contentMode = .scaleAspectFill
            newButton.tag = index
            newButton.addTarget(self, action: #selector(showTab(_:)), for: .touchUpInside)
            buttons.append(newButton)
            stackView.addArrangedSubview(newButton)
        }
    }
    
    private func setupChildControllers() {
        
        let analytics = UIStoryboard(name: "Analytics", bundle: nil).instantiateInitialViewController()!
        let portfolio = UIStoryboard(name: "Portfolio", bundle: nil).instantiateInitialViewController()!
        let ratings   = UIStoryboard(name: "Ratings"  , bundle: nil).instantiateInitialViewController()!
        
        self.viewControllers = [analytics as! DMViewController,portfolio as! DMViewController,ratings as! DMViewController]
        setupContainers()
    }
    
    private func setupContainers() {
        for index in 0...2 {
            createContainer(index: index)
            addTab(tabIndex: index, controller: self.viewControllers[index])
        }
    }
    
    private func addTab(tabIndex : Int, controller : UIViewController) {
        
        let container = containers[tabIndex]
        addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(controller.view)
        
        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            controller.view.topAnchor.constraint(equalTo: container.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        controller.didMove(toParentViewController: self)
    }
    
    private func createContainer(index : Int) {
        let container = UIView(frame: self.tabContainer.frame)
        
        self.view.addSubview(container)
        self.view.bringSubview(toFront: container)
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: self.tabContainer.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: self.tabContainer.trailingAnchor),
            container.topAnchor.constraint(equalTo: self.tabContainer.topAnchor),
            container.bottomAnchor.constraint(equalTo: self.tabContainer.bottomAnchor)
        ])
        
        containers.append(container)
    }
    
    private func showTab(index : Int) {
        self.view.bringSubview(toFront: containers[index])
    }
    
    private func showDefaultPage() {
        self.showTab(index: Values.DMDefaultScreen)
    }

    // MARK: Actions
    
    @objc private func showTab(_ sender : UIButton) {
        showTab(index: sender.tag)
        for button in buttons { button.setImage(tabIcons[button.tag], for: .normal) }
        sender.setImage(activeIcons[sender.tag], for: .normal)
    }
    
}
