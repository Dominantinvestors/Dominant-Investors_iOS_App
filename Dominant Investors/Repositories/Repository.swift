//import RealmSwift
import ObjectMapper
import Alamofire

public protocol Repository {
    associatedtype Item
    
    static func `default`() -> Self
}

//public protocol LocaleStorable {
//    associatedtype Item: Object
//
//    var context: Realm { get }
//
//    func getAll() -> [Item]
//    func getOnes() -> Item?
//    func get(with id: Int) -> Item?
//    func get(with id: String) -> Item?
//    func add(_ item: Item) -> Item
//    func add(_ items: [Item]) -> [Item]
//    func remove(_ item: Item)
//    func remove(_ items: [Item])
//}

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

//public extension Repository where Self: LocaleStorable {
//
//    func getAll() -> [Item] {
//        return context.objects(Item.self).compactMap{ $0 }
//    }
//
//    func get(with id: Int) -> Item? {
//        let predicate = NSPredicate(format: "%K = %d", Item.primaryKey()! , id)
//        return context.objects(Item.self).filter(predicate).first
//    }
//
//    func get(with id: String) -> Item? {
//        let predicate = NSPredicate(format: "%K = %@", Item.primaryKey()!, id)
//        return context.objects(Item.self).filter(predicate).first
//    }
//
//    func getOnes() -> Item? {
//        return context.objects(Item.self).first
//    }
//
//    @discardableResult
//    func add(_ item: Item) -> Item {
//        try! context.write {
//            context.add(item, update: true)
//        }
//        return item
//    }
//
//    @discardableResult
//    func add(_ items: [Item]) -> [Item] {
//        try! context.write {
//            context.add(items, update: true)
//        }
//        return items
//    }
//
//    func remove(_ item: Item) {
//        try! context.write {
//            context.delete(item)
//        }
//    }
//
//    func remove(_ items: [Item]) {
//        try! context.write {
//            context.delete(items)
//        }
//    }
//}
//
//public extension Repository where Self: LocaleStorable & SyncableItems {
//
//    @discardableResult
//    func sync(_ items: [Item]) -> [Item] {
//        try! context.write {
//            let ids = items.map { $0.value(forKey: Item.primaryKey()!) }
//            let predicate = NSPredicate(format: "NOT (%K IN %@)", Item.primaryKey()!, ids)
//            let objectsToDelete = context.objects(Item.self).filter(predicate)
//            context.delete(objectsToDelete)
//            context.add(items, update: true)
//        }
//        return items
//    }
//
//    @discardableResult
//    func sync(_ item: Item) -> Item {
//        return sync([item]).last!
//    }
//}

public extension Repository where Self: Syncable {
    
    func send(request: RequestProvider) -> DataRequest {
        return session.request(request).validate()
    }
}
