import Foundation

enum UriProvider {
  case newsPath
  case searchPath(searchText: String)
  case countryPath(code: String)
  case category(type: String)
}
 
// MARK: Endpoint
extension UriProvider: Endpoint {
  
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
      case .category(type:):
        return "/v2/top-headlines"
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
      case .category(type: let type):
        print(type)
        return ["category" : type]
    }
  }
 
  var method: HTTPMethod {
    switch self {
      case .newsPath,.searchPath(searchText:), .countryPath(code:), .category(type:):
        return .get
    }
  }
}


