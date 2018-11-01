import UIKit

class TabBarController: UITabBarController {
    
    fileprivate init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, menu: Menu){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        decorate(menu)
    }
    
    fileprivate init?(coder aDecoder: NSCoder, menu: Menu) {
        super.init(coder: aDecoder)
        decorate(menu)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    fileprivate func decorate(_ menu: Menu) {
        self.viewControllers = menu.menuItems.map{
            let controller = $0.storyboard.instantiateInitialViewController()!
            
            controller.tabBarItem = UITabBarItem(title: nil,
                                                 image: $0.image?.withRenderingMode(.alwaysOriginal),
                                                 selectedImage: $0.imageActive?.withRenderingMode(.alwaysOriginal))
            
            
            controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            controller.tabBarItem.title = ""
            return controller
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = 0
    }
}

class MainTabBar: TabBarController {
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil, menu: MainMenu())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, menu: MainMenu())
    }
}

fileprivate protocol MenuItem {
    var title: String { get }
    var image: UIImage? { get }
    var imageActive: UIImage? { get }
    var storyboard: UIStoryboard { get }
}

fileprivate protocol Menu {
    var menuItems: [MenuItem] { get }
}

fileprivate struct MainMenu: Menu {
    var menuItems: [MenuItem] {
        return [InvestmentsIdeas(), Screener(), Portfolio(), Ratings()]
    }
}

fileprivate struct InvestmentsIdeas: MenuItem {
    var title = ""
    var image = UIImage(named: "tab1")
    var imageActive = UIImage(named: "tab1_active")
    var storyboard = UIStoryboard(name: "Analytics", bundle: nil)
}

fileprivate struct Screener: MenuItem {
    var title = ""
    var image = UIImage(named: "tab2")
    var imageActive = UIImage(named: "tab2_active")
    var storyboard =  UIStoryboard(name: "Screener", bundle: nil)
}

fileprivate struct Portfolio: MenuItem {
    var title = ""
    var image = UIImage(named: "tab3")
    var imageActive = UIImage(named: "tab3_active")
    var storyboard =  UIStoryboard(name: "Portfolio", bundle: nil)
}

fileprivate struct Ratings: MenuItem {
    var title = ""
    var image = UIImage(named: "tab4")
    var imageActive = UIImage(named: "tab4_active")
    var storyboard =  UIStoryboard(name: "Ratings", bundle: nil)
}
