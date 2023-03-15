import Foundation
@testable import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    
    var profileScreenView: ImageFeed.ProfileViewProtocol?
    
    init(profileScreenView: ImageFeed.ProfileViewProtocol? = ProfileViewSpy()) {
        self.profileScreenView = profileScreenView
    }
    
    func showAlertGetAvatarError(alertModel: ImageFeed.ErrorAlertModel) {}
    
    func logoutProfile(alertModel: ImageFeed.LogoutAlertModel) {}
}
