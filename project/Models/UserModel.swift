import Foundation
import ObjectMapper

class UserModel: Mappable {

    var id: Int = 0
    var avatar: String?
    var email: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var followers: Int = 0
    var rating: Int = 0

    required init?(map: Map) { }

    func mapping(map: Map) {
        id <- map["id"]
        avatar <- map["avatar"]
        email <- map["email"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        followers <- map["followers_count"]
        rating <- map["last_name"]
    }
}
