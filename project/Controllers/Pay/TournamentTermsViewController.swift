import UIKit

class TournamentTermsViewController: UIViewController {

    @IBOutlet weak var conteiner: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.alignLeft(conteiner)
        view.alignRight(conteiner)
    }
    
     @IBAction func onGotIt(_ sender: Any) {
        navigationController?.popViewController(animated: true)
     }
}
