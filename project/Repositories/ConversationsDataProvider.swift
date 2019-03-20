import Alamofire
import PromiseKit

struct ConversationsDataProvider: PromiseRepository, Syncable {
    typealias Item = Conversation
    
    let session: SessionManager
    let handler: CompletionHandler
    
    static func `default`() -> ConversationsDataProvider {
        let session: MainSessionManager = ServiceLocator.shared.getService()
        return ConversationsDataProvider(session: session, handler: BaseHandler())
    }
    
    func get(completion: @escaping ([Conversation]?, String?) -> Void) {
        send(request: UserModel.conversation()).responseObject { (response: DataResponse<OffsetResponse<Conversation>>) -> Void in
            switch self.handler.handle(response) {
            case .success(let result):
                completion(result.items, nil)
            case .error(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func getMessages(for conversationsId: Int, completion: @escaping ([Message]?, String?) -> Void) {
        send(request: UserModel.messages(for: conversationsId)).responseObject { (response: DataResponse<OffsetResponse<Message>>) -> Void in
            switch self.handler.handle(response) {
            case .success(let result):
                completion(result.items, nil)
            case .error(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }

    func new(message: String, for conversationsId: Int, completion: @escaping (Message?, String?) -> Void) {
        send(request: UserModel.message(message, for: conversationsId)).responseObject { (response: DataResponse<Message>) -> Void in
            switch self.handler.handle(response) {
            case .success(let result):
                completion(result, nil)
            case .error(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func newConversation(with investor: Int, completion: @escaping (NewConversation?, String?) -> Void) {
        send(request: UserModel.newConversation(with: investor)).responseObject { (response: DataResponse<NewConversation>) -> Void in
            switch self.handler.handle(response) {
            case .success(let result):
                completion(result, nil)
            case .error(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func markAsRead(conversation: Int, completion: @escaping (Bool, String?) -> Void) {
        send(request: UserModel.markAsRead(conversation)).responseJSON { response in
            switch self.handler.handle(response) {
            case .success( _ ):
                completion(true, nil)
            case .error(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func unread() -> Promise<Unread> {
        return send(request: UserModel.unread())
    }
}

