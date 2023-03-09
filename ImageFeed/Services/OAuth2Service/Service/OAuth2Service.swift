import Foundation

/// Класс отвечает за получение и за сохранение bearer token
final class OAuth2Service {
    
    // MARK: - Singleton
    static let shared = OAuth2Service()
    private init() {}
    
    // MARK: - Private properties
    private let urlSession = URLSession.shared
    
    //указатель на активную задачу, если задач нет, значение = nil. Значение присваивается до task.resume(), при успешном выполнении обнуляется
    private var task: URLSessionTask?
    // значение code которое передается в последнем созданном запросе
    private var lastCode: String?
    
    private (set) var authToken: String? {
        get { OAuth2TokenStorage.shared.token }
        set { OAuth2TokenStorage.shared.token = newValue }
    }
    
    // MARK: - Public methods
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void ) {
        // проверяем что код выполняетс из главного потока, так как при обращении к task и lastCode не из главного потока случится гонка
        assert(Thread.isMainThread)
        
        if lastCode == code { return } // если true, то значит по этому коду мы ранее получили bearer token и сохранили его, делать новый запрос не нужно
        task?.cancel() // если значение не nil, тогда мы останавливаем задачу, присваиваем новый code в lastCode и запускаем новую задачу
        lastCode = code
        
        let request = authTokenRequest(code: code)
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let body):
                    let authToken = body.accessToken
                    self.authToken = authToken
                    completion(.success(authToken))
                    self.task = nil // после выполнения задачи обнуляем активную задачу
                case .failure(let error):
                    self.lastCode = nil // если пришла ошибка удалим lastCode чтобы повторить запрос с темже кодом
                    completion(.failure(error))
                }
            }
        }
                
        self.task = task // так как задача выполняется асинхронно на главном потоке после ее запуска мы присваиваем ее значение в указатель для активной задачи, после успешного выполнения таска, указатель станет nil
        task.resume() // запускаем задачу
    }
}

extension OAuth2Service {
   private func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(AuthConfiguration.standart.accessKey)"
            + "&&client_secret=\(AuthConfiguration.standart.secretKey)"
            + "&&redirect_uri=\(AuthConfiguration.standart.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST")
    }
}
