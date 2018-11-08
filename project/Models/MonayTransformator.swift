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
