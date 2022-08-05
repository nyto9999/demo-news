import Foundation
import UIKit

protocol NewsClientProtocol {
  
  typealias newsFeed = (news: [News], images: [Int:UIImage?])
  
  func receiveData(type: NewsType) async throws -> newsFeed
  
  func cImgsDownloader(for news: [News]) async throws -> newsFeed
  
  func imgDownloader(urlString: String?) async -> UIImage?

}

