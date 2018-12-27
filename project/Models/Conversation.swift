import ObjectMapper

class Conversation: Mappable {
    
    var id: Int = 0
    var unread: Int = 0
    var last: Message!
    var created: String = ""
    var peers: [UserModel]!
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        unread <- map["unread_message_count"]
        last <- map["last_message"]
        created <- map["created_on"]
        peers <- map["peers"]
    }
}
