import UIKit

class AnalitycalInfoViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scroll: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        modalPresentationStyle = .overCurrentContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let horizontalConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraint)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            imageView.contentMode = .scaleAspectFit
        } else {
            imageView.contentMode = .scaleAspectFill
        }
    }
    
    @IBAction func onViewResult() {
//        self.dismiss(animated: false, completion: nil)
        
        userAuthorized()
    }
    
    private func userAuthorized() {
        let tabBar = UIStoryboard(name: "TabBar", bundle: nil).instantiateInitialViewController()!
        UIApplication.shared.delegate?.window!!.rootViewController = animate(tabBar)
    }
}
