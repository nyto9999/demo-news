import Foundation

extension URLRequest {
  mutating func setHeader(for httpHeaderField: String, with value: String) {
    setValue(value, forHTTPHeaderField: httpHeaderField)
  }
}
