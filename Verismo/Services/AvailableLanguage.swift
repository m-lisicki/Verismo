

import Foundation

struct AvailableLanguage: Comparable {
    let locale: Locale.Language
    
    var localizedName: String {
        let locale = Locale.current
        
        guard let localizedName = locale.localizedString(forLanguageCode: shortName) else {
            return "Unknown language code"
        }
        
        return "\(localizedName) (\(shortName))"
    }
    
    var shortName: String {
        "\(locale.languageCode ?? "")-\(locale.region ?? "")"
    }
    
    static func <(lhs: AvailableLanguage, rhs: AvailableLanguage) -> Bool {
        lhs.localizedName < rhs.localizedName
    }
}
