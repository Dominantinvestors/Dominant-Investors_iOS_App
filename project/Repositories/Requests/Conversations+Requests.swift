import UIKit

extension User {
    
    static func conversation() -> RequestProvider {
        return URLEncodingRequestBuilder(path: "/conversations/")
    }
    
    static func messages(for conversationsId: Int) -> RequestProvider {
        return URLEncodingRequestBuilder(path: "/conversations/\(conversationsId)/messages/")
    }
    
    static func unread() -> RequestProvider {
        return URLEncodingRequestBuilder(path: "/messages/unread-count/")
    }
}

extension InvestorModel {

    func messageToExisting(_ text: String) -> RequestProvider {
        let parameters: [String: Any] = ["text": text]
        return URLEncodingRequestBuilder(path: "/conversations/\(coversetionID)/messages/",
            method: .post,
            parameters: parameters)
    }
    
    func messageToNew(_ text: String) -> RequestProvider {
        let parameters: [String: Any] = ["text": text, "receiver_id": id]
        return URLEncodingRequestBuilder(path: "/messages/", method: .post, parameters: parameters)
    }
    
  static func markAsRead(_ conversation: Int) -> RequestProvider {
        return URLEncodingRequestBuilder(path: "/conversations/\(conversation)/mark-as-read/", method: .post)
    }
}
