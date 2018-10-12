import UIKit

class TermsAndConditionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onIAgree() {
        self.dismiss(animated: false, completion: nil)
    }
}
