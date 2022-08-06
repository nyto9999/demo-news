import Foundation

enum NewsProvider {
  case newsPath
  case searchPath(searchText: String)
  case countryPath(code: String)
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
      case .newsPath:
        return "/v2/top-headlines"
      case .countryPath(code:):
        return "/v2/top-headlines"
      case .searchPath(searchText:):
        return "/v2/everything"
    }
  }
  
  var headers: [String : String]? {
    return nil
  }
  
  var params: [String : Any]? {
    switch self {
      case .newsPath:
        return ["country": RegionCodeHelper.getCurrentCountryCode()]
      case .searchPath(searchText: let searchText):
        return ["q" : searchText]
      case .countryPath(code: let code):
        return ["country": code]
    }
  }
 
  var method: HTTPMethod {
    switch self {
      case .newsPath,.searchPath(searchText:), .countryPath(code:):
        return .get
    }
  }
}


