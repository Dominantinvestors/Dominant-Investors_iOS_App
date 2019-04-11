//import RealmSwift
import ObjectMapper
import Alamofire
import PromiseKit

public protocol Repository {
    associatedtype Item
    
    static func `default`() -> Self
}

public protocol Syncable {
    associatedtype Item

    var session: SessionManager { get }
    var handler: CompletionHandler { get }
    
    func send(request: RequestProvider) -> DataRequest
}

public protocol SyncableItems {
    associatedtype Item: Mappable
    
    func sync(_ items: [Item]) -> [Item]
    func sync(_ item: Item) -> Item
}

public extension Repository where Self: Syncable {
    
    func send(request: RequestProvider) -> DataRequest {
        return session.request(request).validate()
    }
}

protocol PromiseRepository: Repository {
    
}

extension PromiseRepository where Self: Syncable {
    
    func send<T: BaseMappable>(request: RequestProvider) -> Promise<[T]> {
        return Promise { resolver in
            send(request: request).responseArray(keyPath: request.keyPath) { (response: DataResponse<[T]>) -> Void  in
                switch self.handler.handle(response) {
                case .success(let value):
                    resolver.fulfill(value)
                case .error(let error):
                    resolver.reject(error)
                }
            }
        }
    }
    
    func send<T: BaseMappable>(request: RequestProvider) -> Promise<T> {
        return Promise { resolver in
            send(request: request).responseObject(keyPath: request.keyPath) { (response: DataResponse<T>) -> Void  in
                switch self.handler.handle(response) {
                case .success(let value):
                    resolver.fulfill(value)
                case .error(let error):
                    resolver.reject(error)
                }
            }
        }
    }
    
    func send(request: RequestProvider) -> Promise<String> {
        return Promise { resolver in
            send(request: request).responseString { (response: DataResponse<String>) -> Void  in
                switch self.handler.handle(response) {
                case .success(let value):
                    resolver.fulfill(value)
                case .error(let error):
                    resolver.reject(error)
                }
            }
        }
    }
    
    func send(request: RequestProvider) -> Promise<UIImage> {
        return Promise { resolver in
            send(request: request).responseImage { (response: DataResponse<UIImage>) -> Void  in
                switch self.handler.handle(response) {
                case .success(let value):
                    resolver.fulfill(value)
                case .error(let error):
                    resolver.reject(error)
                }
            }
        }
    }
}



