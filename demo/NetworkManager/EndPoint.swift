import Foundation

protocol Endpoint {
  func path(keywords: [String: String]) -> URL?
}

struct NewsUrl: Endpoint {
  
  func path(keywords: [String : String]) -> URL? {
    let apiKey = "402d3a3e2bb44751b9d8b9618c6a6fca"
    var components = URLComponents()
    components.scheme = "https"
    components.host   = "newsapi.org"
    components.path   = "/v2/top-headlines"
    
    keywords.isEmpty ?
    components.queryItems = [URLQueryItem(name: "country", value: "us")]:
    components.setQueryItems(with: keywords)
    
    components.queryItems?.append(URLQueryItem(name: "apiKey", value: apiKey))
    return components.url
  }
}

extension URLComponents {
  mutating func setQueryItems(with parameters: [String: String]) {
   self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
 }
}
