import UIKit

final class SharingPresenter {
        
    // MARK: - Private properties
    private weak var delegate: SharingPresenterDelegate?
    
    // MARK: - Initializers
    init(delegate: SharingPresenterDelegate? = nil) {
        self.delegate = delegate
    }
}

// MARK: - SharingPresenterProtocol
extension SharingPresenter: SharingPresenterProtocol {
    func requestSharingImage(for image: UIImage?) {
        
        guard let image = image?.pngData() else {
            fatalError()
        }
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: [])
        delegate?.shareImage(viewController: activityViewController)
    }
}
