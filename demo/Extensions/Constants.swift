import Foundation

enum Constants {
  static let backgroundTaskIdentifier = "yuhsuan.demo.task.refresh"
  
  enum NewsType: String {
    case everything = "everything"
    case headlines = "headlines"
  }
  
  enum UserDefaultsKeys {
    static let lastRefreshDateKey = "lastRefreshDate"
  }
  
  enum Country: String {
    case taiwan = "tw"
  }
}




