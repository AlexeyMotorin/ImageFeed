import Foundation

/// Класс отвечает за хранение bearer token
final class OAuth2TokenStorage {
    
    private enum Keys: String {
        case token
    }
    
    private let userDefault = UserDefaults.standard
    
    var token: String? {
        get { userDefault.string(forKey: Keys.token.rawValue)}
        set { userDefault.set(newValue, forKey: Keys.token.rawValue)}
    }
}
