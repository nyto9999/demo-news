import Foundation
 
struct News: Codable {
  
  enum NewsCodingKeys: String, CodingKey {
    case status, totalResults, articles
  }
  
  var status:String = ""
  var totalResults:Int = 0
  var articles = [Article]()
  
  public init(){}
  public init(from decoder: Decoder) throws {
    
    guard let container = try? decoder.container(keyedBy: NewsCodingKeys.self)
    else { throw URLError(.callIsActive) }
    
    self.status = try container.decode(String.self, forKey: .status)
    self.totalResults = try container.decode(Int.self, forKey: .totalResults)
    self.articles = try container.decode([Article].self, forKey: NewsCodingKeys.articles)
  }
}
