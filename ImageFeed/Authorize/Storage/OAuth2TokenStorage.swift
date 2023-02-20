import Foundation
import SwiftKeychainWrapper

/// Класс отвечает за хранение bearer token
final class OAuth2TokenStorage {
    
    // MARK: Private enum
    private enum Keys: String {
        case authToken = "Auth token"
    }
    
    // MARK: Private properties
    private let keyChainWrapper = KeychainWrapper.standard
    
    // MARK: Public properties
    var token: String? {
        get { keyChainWrapper.string(forKey: Keys.authToken.rawValue) }
        set {
            guard let newValue else { return }
            let isSucces = keyChainWrapper.set(newValue, forKey: Keys.authToken.rawValue)
            guard isSucces else {
                assertionFailure("Ошибка записи токена")
                return
            }
        }
    }
}
