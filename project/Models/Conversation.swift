import ObjectMapper

class Conversation: Mappable {
    
    var id: Int = 0
    var unread: Int = 0
    var last: Message?
    var created: Date = Date()
    var peers: [UserModel]!
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        unread <- map["unread_message_count"]
        last <- map["last_message"]
        created <- (map["created_on"], DateTransformator())
        peers <- map["peers"]
    }
}

class NewConversation: Mappable {
    
    var id: Int = 0
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["conversation_id"]
    }
}