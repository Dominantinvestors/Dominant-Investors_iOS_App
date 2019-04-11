import UIKit

class InvestorsChatViewController: ChatViewController {
    
    var coversetionID: Int!
    
    override func loadFirstMessages(_ needToShowActivity: Bool = true) {
        if needToShowActivity {
            showActivityIndicator()
        }
        ConversationsDataProvider.default().getMessages(for: coversetionID) { messages, error in
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
        ConversationsDataProvider.default().new(message: str, for: coversetionID) { message, error in
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
        ConversationsDataProvider.default().markAsRead(conversation: coversetionID) {_,_ in }
    }
}
