import UIKit
import Combine
import Resolver

enum NewsType {
  case search(searchText: String)
  case `default`
  case backup
  case loadBackup
  case category(type: String)
}

final class NewsClient: APIClient, NewsClientProtocol {
  var request = NewsProvider.newsPath.reuqest
  
  func receiveData(type: NewsType) async throws -> [News] {
    switch type {
      case .default, .backup, .loadBackup:
        break
      case .search(let searchText):
        request = NewsProvider.searchPath(searchText: searchText).reuqest
      case .category(type: let type):
        request = NewsProvider.category(type: type).reuqest
    }
    
    let data = try await fetch(for: request)
    return try decoder(for: data, type: NewsResult()).news.sorted(by: {$0 > $1})
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  //MARK: Concurrent download News&Images
  //  func receiveData(type: NewsType) async throws -> newsFeed {
  //
  //    switch type {
  //      case .default, .backup, .loadBackup:
  //        break
  //      case .search(let searchText):
  //        request = NewsProvider.searchPath(searchText: searchText).reuqest
  //    }
  //
  //    let data = try await fetch(for: request)
  //    let news = try decoder(for: data, type: NewsResult()).news.sorted(by: {$0 > $1})
  //
  //    if case .backup = type {
  //      try await self.storeData(for: request)
  //    }
  //    if case .loadBackup = type {
  //      let backupNews = try self._loadBackup()
  //      return try await self.cImgsDownloader(for: backupNews)
  //    }
  //
  //    return try await self.cImgsDownloader(for: news)
  //  }
  //
  //  func cImgsDownloader(for news: [News]) async throws -> newsFeed {
  //
  //    var images = [Int:UIImage?]()
  //    let taskResult = (index: Int, image: UIImage?).self
  //
  //    try await withThrowingTaskGroup(of: taskResult) { [unowned self] group in
  //      //con
  //      for index in 0..<news.count {
  //        group.addTask {
  //          let img = await self.imgDownloader(urlString: news[index].urlToImage)
  //          return (index, img)
  //        }
  //      }
  //
  //      //wait for groupTasks
  //      for try await imageDownloader in group {
  //        images[imageDownloader.index] = imageDownloader.image
  //      }
  //    }
  //    return (news, images)
  //  }
  //
  //  func imgDownloader(urlString: String?) async -> UIImage? {
  //    guard let urlString = urlString,
  //          let url = URL(string: urlString),
  //          let data = try? await URLSession.shared.data(from: url).0
  //    else { return UIImage() }
  //    return UIImage(data: data)
  //  }
  //
  private func _loadBackup() throws -> [News] {
    guard let data = try? Data(contentsOf: URL(fileURLWithPath: FileManager().backupFilePath()!.path)) else { throw MyError.dataNil }
    return try JSONDecoder().decode(NewsResult.self, from: data).news
  }
}

enum MyError: Error {
  case dataNil
  case fileNil
  case httpResponseFailed(url: URL)
  case decodingFailed(error: Swift.DecodingError)
  case networkFailed(error: URLError, url: URL)
  case unknown
}

