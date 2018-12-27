import Alamofire

struct ConversationsDataProvider: Repository, Syncable {
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

    func new(message: String, for investor: InvestorModel, completion: @escaping (Message?, String?) -> Void) {
        let request = investor.coversetionID == 0 ?
            investor.messageToNew(message) :
            investor.messageToExisting(message)
        
        send(request: request).responseObject { (response: DataResponse<Message>) -> Void in
            switch self.handler.handle(response) {
            case .success(let result):
                completion(result, nil)
            case .error(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func markAsRead(conversation: Int, completion: @escaping (Bool, String?) -> Void) {
        send(request: InvestorModel.markAsRead(conversation)).responseJSON { response in
            switch self.handler.handle(response) {
            case .success( _ ):
                completion(true, nil)
            case .error(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func unread(completion: @escaping (Int, String?) -> Void) {
        send(request: UserModel.unread()).responseObject { (response: DataResponse<Unread>) -> Void in
            switch self.handler.handle(response) {
            case .success(let result):
                completion(result.count, nil)
            case .error(let error):
                completion(0, error.localizedDescription)
            }
        }
    }
}

