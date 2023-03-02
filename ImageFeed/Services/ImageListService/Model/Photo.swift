import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

extension Photo: Equatable {
    static func == (lrh: Photo, rhs: Photo) -> Bool {
        lrh.id == rhs.id ? true : false
    }
}
