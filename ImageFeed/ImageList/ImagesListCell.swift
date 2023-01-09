
import UIKit

final class ImagesListCell: UITableViewCell {
    // MARK: - Static properties
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - @IBOutlet
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var cellImageView: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    
    // MARK: - Public methods
    func config(date: String, image: String, likeImage: String) {
        dateLabel.text = date
        cellImageView.image = UIImage(named: image)
        likeButton.setImage(UIImage(named: likeImage), for: .normal)
    }
}
