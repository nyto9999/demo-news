import Foundation

enum NewsProvider {
  case getTopheadlines
  case search(searchText: String)
}
 
// MARK: Endpoint
extension NewsProvider: Endpoint {
  
  var scheme: String {
    "https"
  }
  
  var host: String {
    "newsapi.org"
  }
  
  var base: String {
    return "https/newsapi.org"
  }
  
  var path: String {
    switch self {
      case .getTopheadlines:
        return "/v2/top-headlines"
      case .search(searchText:):
        return "/v2/everything"
    }
  }
  
  var headers: [String : String]? {
    return nil
  }
  
  var params: [String : Any]? {
    switch self {
      case .getTopheadlines:
        return nil
      case .search(searchText: let searchText):
        return ["q" : searchText]
    }
  }
 
  var method: HTTPMethod {
    switch self {
      case .getTopheadlines,.search(searchText:):
        return .get
    }
  }
}


