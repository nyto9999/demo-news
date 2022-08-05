import Foundation

protocol APIClient {}

extension APIClient {
  
  func fetch(for request: URLRequest) async throws -> Data {
    let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
    guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
    return data
  }
  
  func decoder<T: Decodable>(for data: Data, type: T) throws -> T {
      return try JSONDecoder().decode(T.self, from: data)
  }
  
  //MARK: Fetching NewsAPI & Save File in Memory for Background Tasks
  func storeData(for request: URLRequest) async throws {
    let data = try await self.fetch(for: request)
    guard let file = FileManager().backupFilePath() else { throw MyError.fileNil }
    try FileManager.default.removeItem(at: file)
    try data.write(to: file, options: [.atomic])
    print(file)
  }
}


