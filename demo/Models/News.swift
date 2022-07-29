import Foundation
import UIKit

struct News: Codable, Comparable, Equatable {
  
  var title:String
  var publishedAt: String
  var url:String
  
  
  enum NewsDetail: CodingKey {
    case title
    case publishedAt
    case urlToImage
    case url
  }
  
  static func == (lhs: News, rhs: News) -> Bool {
    lhs.publishedAt < rhs.publishedAt
  }
  static func < (lhs: News, rhs: News) -> Bool {
    lhs.publishedAt < rhs.publishedAt
  }
}


