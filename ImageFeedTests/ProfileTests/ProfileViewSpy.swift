import UIKit
@testable import ImageFeed

final class ProfileViewSpy: ProfileViewProtocol {
    
    var presenter: ImageFeed.ProfilePresenterProtocol?
    
    var updateProfileCalled = false
    var updateAvatarCalled = false
    
    func updateProfile(from profile: ImageFeed.Profile?) {
        updateProfileCalled = true
    }
    
    func updateAvatar(_ image: UIImage) {
        updateAvatarCalled = true
    }

    func requestShowAlertGetAvatarError(alertModel: ImageFeed.ErrorAlertModel) {}
}

