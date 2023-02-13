import Foundation

/// Константы из Unsplash Developers
struct Constants {
    static let accessKey = "SGi5ZAA5esYPvml5pRn2f_1PB4nAOA9QXClBcTJMuLk"
    static let secretKey = "LHOcBamu-VC4n8_AnQj3Nc4kUI5XHb14cUWanFrV-YM"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL =  URL(string: "https://unsplash.com")!
    static let apiBaseURL = URL(string: "https://api.unsplash.com")!
}
