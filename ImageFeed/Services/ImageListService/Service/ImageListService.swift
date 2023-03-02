import Foundation

final class ImageListService {
    // MARK: - Singleton
    static let shared = ImageListService()
    private init() {}
    
    // MARK: - Static properties
    static let didChangeNotification = Notification.Name(rawValue: "ImageListServiceDidChange")
   
    // MARK: - Private enum
    private enum HttpMethods: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
    }
    
    // MARK: - Private properties
    private let urlSession = URLSession.shared
    private var lastLoadedPage: Int?
    
    //указатель на активную задачу, если задач нет, значение = nil. Значение присваивается до task.resume(), при успешном выполнении обнуляется
    private var task: URLSessionTask?
    private(set) var photos: [Photo] = []
    
    // MARK: - Public properties
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        task?.cancel()
        
        var nextPage: Int
        
        if let lastLoadedPage = lastLoadedPage {
            nextPage = lastLoadedPage + 1
            self.lastLoadedPage = nextPage
        } else {
            nextPage = 1
            self.lastLoadedPage = nextPage
        }
        
        guard let token = OAuth2TokenStorage.shared.token else { return }
        let request = imageListRequest(numberPage: nextPage, token: token)
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let photoResult):
                    photoResult.forEach { result in
                        let photo = self.getPhoto(from: result)
                        // API c багом, первые две картинки следующей страницы это две последние картинки предыдущей, поэтому проверяем содержит ли массив такие картинки
                        if !self.photos.contains(photo) {
                            self.photos.append(photo)
                        }
                    }
                    NotificationCenter.default.post(
                        name: ImageListService.didChangeNotification,
                        object: self,
                        userInfo: ["photos" : self.photos])
                case .failure(let error):
                    print(error)
                }
                self.task = nil
            }
        }
        
        self.task = task
        task.resume()
    }
    
    // MARK: - Private methods
    private func imageListRequest(numberPage: Int, token: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/photos" + "?page=\(numberPage)",
            httpMethod: HttpMethods.get.rawValue,
            baseURL: Constants.apiBaseURL)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func getPhoto(from result: PhotoResult) -> Photo {
        let imageSize = CGSize(width: CGFloat(result.width), height: CGFloat(result.height))
        
        var createdDate: Date?
        
        if let dateString = result.createdAt {
            createdDate = ISO8601DateFormatter().date(from: dateString)
        } 
        
        let photo = Photo(id: result.id,
                          size: imageSize,
                          createdAt: createdDate,
                          welcomeDescription: result.description,
                          thumbImageURL: result.urls.thumb,
                          largeImageURL: result.urls.full,
                          isLiked: result.likedByUser)
        return photo
    }
    
}

// MARK: - Change like
extension ImageListService {
    // MARK: - Public properties
    func changeLike(idPhoto: String, isLike: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        guard let token = OAuth2TokenStorage.shared.token else { return }
        
        let httpMethod = isLike ? HttpMethods.post.rawValue : HttpMethods.delete.rawValue
        let request = likeRequest(id: idPhoto, httpMethod: httpMethod, token: token)
        
        let task = urlSession.dataTask(with: request) { [weak self] _, response, error in
            if let error = error {
                print(error)
                completion(.failure(error))
                return
            }
            guard
                let response = response,
                let statusCode = (response as? HTTPURLResponse)?.statusCode,
                statusCode == 201 || statusCode == 200,
                let self = self else { return }
            
            self.changePhoto(photoId: idPhoto)
            completion(.success(Void()))
        }
        
        self.task = task
        task.resume()
    }
    
    private func likeRequest(id: String, httpMethod: String, token: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/photos" + "/\(id)/like",
            httpMethod: httpMethod,
            baseURL: Constants.apiBaseURL)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func changePhoto(photoId: String) {
        if let index = self.photos.firstIndex(where: { $0.id == photoId}) {
            let photo = self.photos[index]
            let newPhoto = Photo(id: photo.id,
                                 size: photo.size,
                                 createdAt: photo.createdAt,
                                 welcomeDescription: photo.welcomeDescription,
                                 thumbImageURL: photo.thumbImageURL,
                                 largeImageURL: photo.largeImageURL,
                                 isLiked: !photo.isLiked
            )
            
            self.photos[index] = newPhoto
        }
    }
}
