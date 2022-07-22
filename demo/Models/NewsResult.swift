import Foundation
 
class NewsResult: Decodable {
  
  enum NewsCodingKeys: String, CodingKey {
    case news = "articles"
  }
    
  var news = [News]()
  
  public init(){}
  required public init(from decoder: Decoder) throws {
    guard let container = try? decoder.container(keyedBy: NewsCodingKeys.self)
    else { throw NSError(domain: "decode news failed", code: 1) }
    
    self.news = try container.decode([News].self, forKey: NewsCodingKeys.news)
  }
}
