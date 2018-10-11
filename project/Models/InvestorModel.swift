import ObjectMapper

class InvestorModel: Mappable, User {
    
    var id: Int = 0

    var avatar: String?
    var firstName: String = ""
    var lastName: String = ""
    var followers: Int = 0
    var rating: Int = 0
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        avatar <- map["avatar_thumbs.medium"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        followers <- map["followers_count"]
        rating <- map["rating"]
    }
}
