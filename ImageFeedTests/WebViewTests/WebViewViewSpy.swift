import Foundation
@testable import ImageFeed

final class WebViewViewSpy: WebViewViewProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    
    var loadRequestCalled = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {}
    
    func setProgressHiden(_ isHidden: Bool) {}
}

