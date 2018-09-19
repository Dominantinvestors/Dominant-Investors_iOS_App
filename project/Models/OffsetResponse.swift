import UIKit
import ObjectMapper

class OffsetResponse<T:Mappable>: Mappable {
    
    var count: Int = 0
    var next: Int = 0
    var previous: Int = 0
    var items: [T] = []
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        count <- map["count"]
        next <- map["next"]
        previous <- map["previous"]
        items <- map["results"]
    }
}
