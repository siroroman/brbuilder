import Foundation


enum APIClientError: Error {
    case noToken
    
    var localizedDescription: String {
        switch self {
        case .noToken: return "No valid token provided. Set Bitrise token with token command."
        }
    }
}


struct APIClient {
    
    private let tokenProvider: TokenProvider
    
    private let semaphore = DispatchSemaphore(value: 0)
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
        case patch = "PATCH"
    }
    
    init(tokenProvider: TokenProvider) {
        self.tokenProvider = tokenProvider
    }
        
    func call(endPoint: Endpoint,
              method: HTTPMethod = .get,
              body: Data? = nil ,
              completionHandler: @escaping(Data?, URLResponse?, Error?) -> ()) {
       
        guard let token = tokenProvider.load() else {
           return completionHandler(nil, nil, APIClientError.noToken)
        }
        
        var request = URLRequest(url: endPoint.url)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        print("Calling \(request)...")
        print(body?.toString() ?? "")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            print(response.debugDescription)
            print(data?.toString() ?? "")
            print(error?.localizedDescription ?? "")
            
            completionHandler(data, response, error)
            self.semaphore.signal()
        })
        task.resume()
        
        semaphore.wait()
    }
    
}
