import Foundation



struct RegionCodeHelper {
  static let defaultRegionCode: Constants.Country = .taiwan
  
  static func getCurrentCountryCode() -> String {
    guard let regionCode = Locale.current.regionCode else {
      return defaultRegionCode.rawValue
    }
    return Constants.Country.init(rawValue: regionCode)?.rawValue ?? defaultRegionCode.rawValue
  }
}





