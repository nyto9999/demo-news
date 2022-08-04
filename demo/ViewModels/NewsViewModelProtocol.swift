import Foundation
import Combine
import UIKit

protocol NewsViewModelProtocol {
  //publisher way
  typealias newsFeed = (news: [News], images: [Int:UIImage?])
  typealias newsPublisher = AnyPublisher<[News], MyError>
  
  func search(searchText: String) -> newsPublisher
  
  
  // 1 called by view
  func fetchingNewsAndImageData() async throws -> newsFeed
  
  // 2 publisher fetching news
  func _fetchingNewsData() async -> [News]
  
  // 3 convert feteched news imgString to img data
  func _convertUrlToImage(for news: [News]) async throws -> newsFeed
  
  // 4
  func imageDownloader(urlString: String?) async throws -> UIImage?
}
