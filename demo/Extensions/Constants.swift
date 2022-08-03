import Foundation

enum Constants {
  
  static let backgroundTaskIdentifier = "yuhsuan.demo.task.refresh"
  
  static var dateFormatter: DateFormatter {
    let df = DateFormatter()
    df.locale = Locale(identifier: "UTC")
    df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
    return df
  }
  
  /// Auto-search at least this frequently while typing
  public static let longAutoSearchDelay: TimeInterval = 2.0
  /// Trigger automatically after a pause of this length
  public static let shortAutoSearchDelay: TimeInterval = 0.75
  
  enum NewsType: String {
    case everything = "everything"
    case headlines = "headlines"
  }
  
  enum UserDefaultsKeys {
    static let lastRefreshDateKey = "lastRefreshDate"
  }
  
  enum Country: String {
    case taiwan = "tw"
  }
  
  enum Category:String, CaseIterable {
    case 財經 = "business"
    case 娛樂 = "entertainment"
    case 大眾 = "general"
    case 醫療 = "health"
    case 自然 = "science"
    case 體育 = "sports"
    case 科技 = "technology"
  }
  
  enum isoCountryCode:String, CaseIterable {
    case ae = "ae"
    case ar = "ar"
    case at = "at"
    case au = "au"
    case be = "be"
    case bg = "bg"
    case br = "br"
    case ca = "ca"
    case ch = "ch"
    case cn = "cn"
    case co = "co"
    case cu = "cu"
    case cz = "cz"
    case de = "de"
    case eg = "eg"
    case fr = "fr"
    case gb = "gb"
    case gr = "gr"
    case hk = "hk"
    case hu = "hu"
    case id = "id"
    case ie = "ie"
    case il = "il"
    case `in` = "in"
    case it = "it"
    case jp = "jp"
    case kr = "kr"
    case lt = "lt"
    case lv = "lv"
    case ma = "ma"
    case mx = "mx"
    case my = "my"
    case ng = "ng"
    case nl = "nl"
    case no = "no"
    case nz = "nz"
    case ph = "ph"
    case pl = "pl"
    case pt = "pt"
    case ro = "ro"
    case rs = "rs"
    case ru = "ru"
    case sa = "sa"
    case se = "se"
    case sg = "sg"
    case si = "si"
    case sk = "sk"
    case th = "th"
    case tr = "tr"
    case ua = "ua"
    case us = "us"
    case za = "za"
  }
  

}




