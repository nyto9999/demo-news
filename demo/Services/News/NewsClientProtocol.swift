import Foundation
import UIKit

protocol NewsClientProtocol {
  
  
  func receiveData(type: NewsType) async throws -> [News]
  
  
  
  
  
  
  
  
  //MARK: Concurrent dowload News&Images
//  typealias newsFeed = (news: [News], images: [Int:UIImage?])
//
//  func receiveData(type: NewsType) async throws -> newsFeed
//
//  func cImgsDownloader(for news: [News]) async throws -> newsFeed
//
//  func imgDownloader(urlString: String?) async -> UIImage?

}

