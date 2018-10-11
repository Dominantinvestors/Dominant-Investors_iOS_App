import Alamofire

public enum RequestError: Error {
    case notAutorised(Int, String)// StatusCode = 401
    case error(Int, String)
    
    var localizedDescription: String {
        switch self {
        case .notAutorised(_ , let value):
            return value
        case .error(_ , let value):
            return value
        }
    }
}

public enum Response<Value> {
    case success(Value)
    case error(RequestError)
    
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }
    
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        default:
            return nil
        }
    }
    
    public var error: RequestError? {
        switch self {
        case .error(let value):
            return value
        default:
            return nil
        }
    }
}

public protocol CompletionHandler {
    func handle<T>(_ response: DataResponse<T>) -> Response<T>
}

public struct BaseHandler: CompletionHandler {

    public func handle<T>(_ response: DataResponse<T>) -> Response<T> {
        print("Method:", response.request?.httpMethod ?? "____", separator: " ")
        print("URL:", response.request?.url?.absoluteString ?? "____", separator: " ")
        print("StatusCode:", response.response?.statusCode ?? "____", separator: " ")
        print("StartTime:", Date(timeIntervalSinceReferenceDate: response.timeline.requestStartTime), separator: " ")
        print("RequestDuration:", response.timeline.requestDuration, separator: " ")
        print("JSON:", String(data: response.data!, encoding: .utf8) ?? "")

        switch response.result {
        case .success(let value):
            
            print("Success:", value, separator: " ", terminator: "\n\n")

            return .success(value)
            
        case .failure(let error):

            print("Failure:", error, separator: " ", terminator: "\n\n")
            
            let code = response.response?.statusCode ?? 500
            
            switch code {
            case 401:
                return .error(.notAutorised(code, NSLocalizedString("User authorization failed !!!", comment: "")))
            case 400, 402..<500:
                
                if let data = response.data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                {
                    switch json {
                    case let array as [String]:
                        return .error(.error(code, array[0]))
                    case let dict as [String: [String]]:
                        let s = dict.randomElement()
                        return .error(.error(code, s?.value[0] ?? error.localizedDescription))

                    default:
                        return .error(.error(code, error.localizedDescription))
                    }
                } else {
                    return .error(.error(code, error.localizedDescription))
                }
            default:
                return .error(.error(code, NSLocalizedString("Connection issues. Please try again later or check your internet settings", comment: "")))

            }
        }
    }
}

