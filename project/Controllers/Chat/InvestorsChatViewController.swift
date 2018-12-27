import UIKit

class InvestorsChatViewController: ChatViewController {

    var investor: InvestorModel!
    
    override func loadFirstMessages() {
        if investor.coversetionID != 0 {
            showActivityIndicator()
            ConversationsDataProvider.default().getMessages(for: investor.coversetionID) { messages, error in
                self.dismissActivityIndicator()
                if let messages = messages {
                    self.insertMessages(messages)
                } else {
                    self.showAlertWith(message: error)
                }
            }
        }
    }
    
    override func create(_ str: String) {
        showActivityIndicator()
        ConversationsDataProvider.default().new(message: str, for: investor) { message, error in
            self.dismissActivityIndicator()
            if let message = message {
                self.insertMessage(message)
            } else {
                self.showAlertWith(message: error)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if investor.coversetionID != 0 {
            ConversationsDataProvider.default().markAsRead(conversation: investor.coversetionID) {_,_ in }
        }
    }
}
