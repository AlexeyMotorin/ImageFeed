import Foundation

protocol AuthErrorAlertPresenterProtocol: AnyObject {
    func requestShowResultAlert(alertModel: AuthErrorAlertModel?)
}
