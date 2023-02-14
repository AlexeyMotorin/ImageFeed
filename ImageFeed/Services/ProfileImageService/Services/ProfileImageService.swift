import Foundation

final class ProfileImageService {
    
    // MARK: - Singleton
    static let shared = ProfileImageService()
    private init() {}
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    // MARK: - Private properties
    private let urlSession = URLSession.shared
    private let token = OAuth2TokenStorage().token
    
    
    //указатель на активную задачу, если задач нет, значение = nil. Значение присваивается до task.resume(), при успешном выполнении обнуляется
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
    
    func fetchProfile(_ userName: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = profileImageRequest(with: userName) else { return }
                
        let task = object(for: request) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let userResult):
                    let smallImageURLString = userResult.profileImage.small
                    self.avatarURL = smallImageURLString
                    completion(.success(smallImageURLString))
                    self.task = nil
                case .failure(let error):
                    completion(.failure(error))
                    self.task = nil
                }
            }
        }
        
        self.task = task
        task.resume()
    }
    
    private func profileImageRequest(with username: String) -> URLRequest? {
        guard let token else { return nil }
        var request = URLRequest.makeHTTPRequest(
            path: "/users"
            + "/\(username)",
            httpMethod: "GET",
            baseURL: Constants.apiBaseURL)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func object(for request: URLRequest, completion: @escaping (Result<UserResult, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<UserResult, Error> in
                Result {
                   try decoder.decode(UserResult.self, from: data)
                }
            }
            completion(response)
        }
    }
}


