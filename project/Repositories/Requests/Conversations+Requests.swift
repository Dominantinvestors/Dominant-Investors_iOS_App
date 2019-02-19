import UIKit

extension User {
    
    static func conversation() -> RequestProvider {
        return URLEncodingRequestBuilder(path: "/conversations/")
    }
    
    static func newConversation(with investor: Int) -> RequestProvider {
        return URLEncodingRequestBuilder(path: "/conversations/id-for-investor/\(investor)/")
    }
    
    static func messages(for conversationsId: Int) -> RequestProvider {
        return URLEncodingRequestBuilder(path: "/conversations/\(conversationsId)/messages/?ordering=-sent_at")
    }
    
    static func unread() -> RequestProvider {
        return URLEncodingRequestBuilder(path: "/messages/unread-count/")
    }
    
   static func message(_ text: String, for conversation: Int ) -> RequestProvider {
        let parameters: [String: Any] = ["text": text]
        return JSONEncodingRequestBuilder(path: "/conversations/\(conversation)/messages/",
            method: .post,
            parameters: parameters)
    }
    
    static func markAsRead(_ conversation: Int) -> RequestProvider {
        return URLEncodingRequestBuilder(path: "/conversations/\(conversation)/mark-as-read/", method: .post)
    }
}
