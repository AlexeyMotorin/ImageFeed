import Foundation
@testable import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    var profileImageServiceObserver: NSObjectProtocol?
    var view: ImageFeed.ProfileViewProtocol?
    
    var viewDidLoadCalled = false
 
    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func creatLogoutAlert() -> ImageFeed.LogoutAlertModel {
        return LogoutAlertModel(title: "test", message: "test", buttonText: "test", completion: nil)
    }
    
    func creatLoadImageErrorAlert() -> ImageFeed.ErrorAlertModel {
        return ErrorAlertModel(title: "test", message: "test", buttonText: "test", completion: nil)
    }
    
}
