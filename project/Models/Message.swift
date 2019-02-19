import MessageKit
import ObjectMapper
import AFDateHelper

class Message: Mappable, MessageType {
    
    var id: Int = 0
    var date: String = ""
    var text: String = ""
    
    var author: UserModel?

    var messageId: String { return String(id) }
    var sender: Sender { return Sender(id: String(author?.id ?? 0), displayName: author?.fullName() ?? "") }
    var kind: MessageKind { return .text(text) }
    var sentDate: Date { return Date(fromString: date, format: .custom("MM/dd/yyyy HH:mm")) ?? Date()}
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        date <- map["sent_at"]
        text <- map["text"]
        author <- map["sender"]
    }
}

class Unread: Mappable {
    
    var count: Int = 0
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        count <- map["unread"]
    }
}
