import Foundation

struct Strings {
    static let search = getLocalizedString(key: "Search")
    
    private static func getLocalizedString(key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}
