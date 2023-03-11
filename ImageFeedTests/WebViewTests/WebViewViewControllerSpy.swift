import Foundation
@testable import ImageFeed

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var webviewScreen: ImageFeed.WebViewViewProtocol?
    
    init(webviewScreen: ImageFeed.WebViewViewProtocol? = WebViewViewSpy()) {
        self.webviewScreen = webviewScreen
    }
    
    func dismissViewController() {}
    
    func getCode(code: String?) {}
}
