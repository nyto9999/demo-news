import UIKit
import Combine
import Resolver

final class NewsViewModel {
  @Injected private var client: NewsClient
}

extension NewsViewModel: NewsViewModelProtocol {
  
  //publisher way
  typealias newsPublisher = AnyPublisher<[News], MyError>
  
  func newsTopHeadlines() -> newsPublisher {
    return client.getTopheadlines().map { $0.news.sorted { $0 > $1 } }
      .eraseToAnyPublisher()
  }
  
  func search(searchText: String) -> newsPublisher {
    
    return client.search(searchText: searchText).map { $0.news.sorted { $0 > $1 } }
      .eraseToAnyPublisher()
  }
  
  func loadBackupNews() async throws -> [News] {
    try await client.fetchAndSave()
    return try self._decodeBackupData()
  }
  
  private func _decodeBackupData() throws -> [News] {
    let data = try? Data(contentsOf: URL(fileURLWithPath: FileManager().backupFilePath()!.path))
    guard let data = data else { throw MyError.dataNil }
    let newsResult = try JSONDecoder().decode(NewsResult.self, from: data)
    return newsResult.news
  }
}


