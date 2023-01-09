import UIKit

final class SharingPresenter {
        
    private weak var delegate: SharingPresenterDelegate?
    
    init(delegate: SharingPresenterDelegate? = nil) {
        self.delegate = delegate
    }
}

extension SharingPresenter: SharingPresenterProtocol {
    func requestSharingImage(for image: UIImage?) {
        
        guard let image = image?.pngData() else {
            fatalError()
        }
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: [])
        delegate?.shareImage(viewController: activityViewController)
    }
}
