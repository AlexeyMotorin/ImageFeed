import Foundation

protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

/// WebView presenter
final class WebViewPresenter {
    var view: WebViewViewControllerProtocol?
    let helper: AuthHelper
    
    init(helper: AuthHelper) {
        self.helper = helper
    }
}

// MARK: WebViewPresenterProtocol, viewDidLoad
extension WebViewPresenter: WebViewPresenterProtocol {
    func viewDidLoad() {
        guard let request = helper.authRequest() else {
            assertionFailure("Ошибка запроса для авторизации")
            return
        }
        didUpdateProgressValue(0)
        view?.load(request: request)
    }
}

// MARK: WebViewPresenterProtocol, UpdateProgress
extension WebViewPresenter {
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHiden(shouldHideProgress)
    }
    
    private func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}

// MARK: WebViewPresenterProtocol, code
extension WebViewPresenter {
    func code(from url: URL) -> String? {
        helper.code(from: url)
    }
}
