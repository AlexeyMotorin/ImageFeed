
import UIKit

final class SingleImageViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    private var sharingPresenter: SharingPresenterProtocol!
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sharingPresenter = SharingPresenter(delegate: self)
        
        imageView.image = image
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func didTabSharingButton(_ sender: UIButton) {
        sharingPresenter.requestSharingImage(for: imageView.image)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

extension SingleImageViewController: SharingPresenterDelegate {
    func shareImage(viewController: UIActivityViewController?) {
        guard let viewController else { return }
        present(viewController, animated: true)
    }
}


