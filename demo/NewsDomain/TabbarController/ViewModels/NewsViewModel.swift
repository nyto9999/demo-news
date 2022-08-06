import UIKit
import Resolver

protocol NewsViewModelProtocol {
  
  //  func fetchingNewsFeed(type: NewsType) async throws -> Constants.newsFeed
  
  func fetchingNewsFeed(type: NewsType) async throws -> [News]
}

final class NewsViewModel {
  //MARK: Properties
  @Injected private var newsClient: NewsClient
}

extension NewsViewModel: NewsViewModelProtocol {
  
  func fetchingNewsFeed(type: NewsType) async throws -> [News] {
    return try await newsClient.receiveData(type: type)
  }
  
  //MARK: concurrent
  //  func fetchingNewsFeed(type: NewsType) async throws -> Constants.newsFeed {
  //    return try await newsClient.receiveData(type: type)
  //  }
}


