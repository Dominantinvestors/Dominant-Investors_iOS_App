import UIKit

class ServiceLocator {
    static let shared = ServiceLocator()
 
    private var registry: [String: Any] = [:]
    
    func registerService<T>(service: T) {
        let key = "\(T.self)"
        registry[key] = service
    }
    
    func tryGetService<T>() -> T? {
        let key = "\(T.self)"
        return registry[key] as? T
    }
    
    func getService<T>() -> T {
        return tryGetService()!
    }
    
    func unRegisterService<T>(service: T) {
        let key = "\(T.self)"
        registry.removeValue(forKey: key)
    }
}
