
import UIKit

final class ImagesListViewController: UIViewController {
    
    // MARK: - @IBOutlet
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    // MARK: - Private properties
    private var photos: [Photo] = []
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let imageListService = ImageListService.shared
    private var imageListServiceObserver: NSObjectProtocol?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
//        imageListService.fetchPhotosNextPage()
        
        imageListServiceObserver = NotificationCenter.default
            .addObserver(forName: ImageListService.didChangeNotification,
                         object: nil,
                         queue: .main,
                         using: { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            })
    }
    
    // MARK: - Override methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func setupView() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func updateTableViewAnimated() {
        let oldPhotoCount = photos.count
        let newPhotoCount = imageListService.photos.count
        photos = imageListService.photos
        
        if oldPhotoCount != newPhotoCount {
            tableView.performBatchUpdates {
                let indexPath = (oldPhotoCount..<newPhotoCount).map { IndexPath(row: $0, section: 0)}
                tableView.insertRows(at: indexPath, with: .automatic)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let imagesListCell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell else { return UITableViewCell() }
        let photo = photos[indexPath.row]
        
        var dateString: String
        
        if let date = photo.createdAt {
            dateString = dateFormatter.string(from: date)
        } else {
            dateString = ""
        }
        
        let image = photo.thumbImageURL
        let isLikedImage: String = photo.isLiked ? "IsLike" : "NoLike"
        imagesListCell.delegate = self
        imagesListCell.config(date: dateString, imageURL: image, likeImage: isLikedImage, numberRow: indexPath.row)
        imagesListCell.selectionStyle = .none
        return imagesListCell
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        let singleImageViewController = SingleImageViewController()
        singleImageViewController.imageURL = photo.largeImageURL
        singleImageViewController.modalPresentationStyle = .fullScreen
        present(singleImageViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photos.count-1 {
            imageListService.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func reloadCellHeight(numberRow: Int) {
        let indexPath = IndexPath(item: numberRow, section: 0)

        tableView.performBatchUpdates {
            tableView.reloadRows(at: [indexPath], with: .automatic )
        }
    }
    
    func imageListCellDidTapeLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        imageListService.changeLike(idPhoto: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.photos = self.imageListService.photos
                cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(let failure):
                print(failure)
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}
