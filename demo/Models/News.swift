import Foundation

struct News: Codable, Comparable, Equatable {
  
  var title:String
  var publishedAt: String
  var urlToImage: String?
  var url:String
  
  
  static func == (lhs: News, rhs: News) -> Bool {
    lhs.publishedAt < rhs.publishedAt
  }
  static func < (lhs: News, rhs: News) -> Bool {
    lhs.publishedAt < rhs.publishedAt
  }
}
