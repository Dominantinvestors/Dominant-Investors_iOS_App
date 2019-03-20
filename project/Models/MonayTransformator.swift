import ObjectMapper

open class MonayTransformator: TransformType {

    open func transformFromJSON(_ value: Any?) -> String? {
        if let str = value as? String {
            return str
        }
        
        if let int = value as? Int {
            return String(int)
        }
        
        if let int = value as? Double {
            return String(int)
        }
        
        return "0.0"
    }
    
    open func transformToJSON(_ value: String?) -> String? {
        return value
    }
}

class DateTransformator: TransformType {
    public typealias Object = Date
    public typealias JSON = String
    
    public init() {}
    
    open func transformFromJSON(_ value: Any?) -> Date? {
        
        if let dateStr = value as? String {
            return Date(fromString: dateStr, format: .isoDateTimeMilliSec)
        }
        
        return nil
    }
    
    open func transformToJSON(_ value: Date?) -> String? {
        if let date = value {
            return date.toString(format: .isoDateTimeMilliSec)
        }
        return nil
    }
}
