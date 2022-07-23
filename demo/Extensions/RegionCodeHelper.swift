import Foundation


enum Country: String {
  case taiwan = "tw"
}

struct RegionCodeHelper {
  static let defaultRegionCode: Country = .taiwan
  
  static func getCurrentCountryCode() -> String {
    guard let regionCode = Locale.current.regionCode else {
      return defaultRegionCode.rawValue
    }
    return Country.init(rawValue: regionCode)?.rawValue ?? defaultRegionCode.rawValue
  }
}
