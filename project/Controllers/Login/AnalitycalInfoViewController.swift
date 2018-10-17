import UIKit

class AnalitycalInfoViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scroll: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let horizontalConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraint)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            imageView.contentMode = .scaleAspectFit
        } else {
            imageView.contentMode = .scaleAspectFill
        }
    }
    
    @IBAction func onViewResult() {
        self.dismiss(animated: false, completion: nil)
    }
}
