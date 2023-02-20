import Foundation

protocol ErrorAlertPresenterProtocol: AnyObject {
    func requestShowResultAlert(alertModel: ErrorAlertModel?)
}
