import Foundation

enum NewsProvider {
  case getTopheadlines
  case search(searchText: String)
  case searchCountry(code: String)
}
 
// MARK: Endpoint
extension NewsProvider: Endpoint {
  
  var scheme: String {
    "https"
  }
  
  var host: String {
    "newsapi.org"
  }
  
  var path: String {
    switch self {
      case .getTopheadlines:
        return "/v2/top-headlines"
      case .search(searchText:):
        return "/v2/everything"
      case .searchCountry(code:):
        return "/v2/top-headlines"
    }
  }
  
  var headers: [String : String]? {
    return nil
  }
  
  var params: [String : Any]? {
    switch self {
      case .getTopheadlines:
        return ["country": RegionCodeHelper.getCurrentCountryCode()]
      case .search(searchText: let searchText):
        return ["q" : searchText]
      case .searchCountry(code: let code):
        return ["country": code]
    }
  }
 
  var method: HTTPMethod {
    switch self {
      case .getTopheadlines,.search(searchText:), .searchCountry(code:):
        return .get
    }
  }
}


