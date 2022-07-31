import Foundation

extension URLRequest {
  mutating func setHeader(for httpHeaderField: String, with value: String) {
    setValue(value, forHTTPHeaderField: httpHeaderField)
  }
}

extension FileManager {
  func backupFilePath() -> URL? {
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    return documentDirectory?.appendingPathComponent("news").appendingPathExtension("json")
  }
}
