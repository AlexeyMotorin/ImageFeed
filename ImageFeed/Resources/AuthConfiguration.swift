import Foundation

/// Константы из Unsplash Developers

let accessKeyStandart = "SGi5ZAA5esYPvml5pRn2f_1PB4nAOA9QXClBcTJMuLk"
let secretKeyStandart = "LHOcBamu-VC4n8_AnQj3Nc4kUI5XHb14cUWanFrV-YM"
let redirectURIStandart = "urn:ietf:wg:oauth:2.0:oob"
let accessScopeStandart = "public+read_user+write_likes"
let defaultBaseURLStandart =  URL(string: "https://unsplash.com")!
let apiBaseURLStandart = URL(string: "https://api.unsplash.com")!
let unsplashAuthorizeURLStringStandart = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    
    static var standart: AuthConfiguration {
        return AuthConfiguration(
            accessKey: accessKeyStandart,
            secretKey: secretKeyStandart,
            redirectURI: redirectURIStandart,
            accessScope: accessScopeStandart,
            defaultBaseURL: defaultBaseURLStandart,
            apiBaseURL: apiBaseURLStandart,
            unsplashAuthorizeURLString: unsplashAuthorizeURLStringStandart
        )
    }
    
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let apiBaseURL: URL
    let unsplashAuthorizeURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, apiBaseURL: URL, unsplashAuthorizeURLString: String ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.apiBaseURL = apiBaseURL
        self.unsplashAuthorizeURLString = unsplashAuthorizeURLString
    }
}
