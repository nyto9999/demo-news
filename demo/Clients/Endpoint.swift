import Foundation
 
protocol Endpoint {
  var scheme: String { get }
  var host: String { get }
  var path: String { get }
  var headers: [String: String]? { get }
  var params: [String: Any]? { get }
  var method: HTTPMethod { get }
}

extension Endpoint {
  
//  var apiKey: String {
//    "402d3a3e2bb44751b9d8b9618c6a6fca"
//  }
  
  var urlComponents: URLComponents {
    var components = URLComponents()
    components.scheme = scheme
    components.host = host
    components.path = path
    
    
    var queryItems = [
      URLQueryItem(name: "pagesize", value: "10")
    ]
    
    if let params = params, method == .get {
      queryItems.append(contentsOf: params.map {
        URLQueryItem(name: "\($0)", value: "\($1)")
      })
    }
     
    components.queryItems = queryItems
    return components
  }
  
  var reuqest: URLRequest {
    let url = urlComponents.url!
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    
    if let headers = headers {
      for (key, value) in headers {
        request.setValue(value, forHTTPHeaderField: key)
      }
    }
    return request
  }
}

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
}
