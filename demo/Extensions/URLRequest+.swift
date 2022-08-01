import Foundation
import UIKit

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

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
