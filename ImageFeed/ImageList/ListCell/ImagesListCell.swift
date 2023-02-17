
import UIKit

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    
    private lazy var cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .ypBlack
       // contentView.backgroundColor = .ypBlack
        contentView.addSubviews(cellImageView, likeButton, dateLabel)
        
        NSLayoutConstraint.activate([
            cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            cellImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            likeButton.rightAnchor.constraint(equalTo: cellImageView.rightAnchor, constant: -10),
            likeButton.topAnchor.constraint(equalTo: cellImageView.topAnchor, constant: 12),
            
            dateLabel.leftAnchor.constraint(equalTo: cellImageView.leftAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: cellImageView.bottomAnchor, constant: -4),
        ])
    }
    
    
    func config(date: String, image: String, likeImage: String) {
        dateLabel.text = date
        cellImageView.image = UIImage(named: image)
        likeButton.setImage(UIImage(named: likeImage), for: .normal)
    }
    
    override func prepareForReuse() {
        cellImageView.image = nil
        dateLabel.text = nil
        likeButton.imageView?.image = nil
    }
    
    @objc private func likeButtonTapped() {
        // TODO: поставить лайк
    }
}
