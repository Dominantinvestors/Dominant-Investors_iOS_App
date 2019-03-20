import UIKit

class CompanyChatViewController: ChatViewController {
    
    var company: CompanyModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .lightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func loadFirstMessages() {
        showActivityIndicator()
        CompanyDataProvider.default().comments(company) { messages, error in
            self.dismissActivityIndicator()
            if let messages = messages {
                self.insertMessages(messages)
            } else {
                self.showAlertWith(message: error)
            }
        }
    }
    
    override func create(_ str: String) {
        showActivityIndicator()
        CompanyDataProvider.default().add(str, company) { message, error in
            self.dismissActivityIndicator()
            if let message = message {
                self.insertMessage(message)
            } else {
                self.showAlertWith(message: error)
            }
        }
    }
}
