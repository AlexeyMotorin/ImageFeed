
import UIKit

protocol ImageListViewControllerProtocol: AnyObject {
    var presenter: ImageListPresenterProtocol? { get set }
    func updateTableViewAnimated(oldPhotoCount: Int, newPhotoCount: Int)
    func presentSingleImageViewController(vc: UIViewController?)
    func updateCellHeght(indexPath: IndexPath)
    func getCellIndexPath(cell: UITableViewCell) -> IndexPath?
}

final class ImagesListViewController: UIViewController {
    
    var presenter: ImageListPresenterProtocol?
    
    // MARK: - @IBOutlet
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter = ImageListPresenter()
        presenter?.view = self
        tableView.dataSource = presenter as? ImageListPresenter
        tableView.delegate = presenter as? ImageListPresenter
        presenter?.viewDidLoad()
    }
    
    // MARK: - Override methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Private methods
    private func setupView() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}

// MARK: ImageListViewControllerProtocol
extension ImagesListViewController: ImageListViewControllerProtocol {
    
    func getCellIndexPath(cell: UITableViewCell) -> IndexPath? {
        guard let indexPath = tableView.indexPath(for: cell) else { return nil }
        return indexPath
    }
    
    func updateTableViewAnimated(oldPhotoCount: Int, newPhotoCount: Int) {
        if oldPhotoCount != newPhotoCount {
            tableView.performBatchUpdates {
                let indexPath = (oldPhotoCount..<newPhotoCount).map { IndexPath(row: $0, section: 0)}
                tableView.insertRows(at: indexPath, with: .automatic)
            }
        }
    }
    
    func presentSingleImageViewController(vc: UIViewController?) {
        guard let vc = vc else { return }
        present(vc, animated: true)
    }
    
    
    func updateCellHeght(indexPath: IndexPath) {
        tableView.performBatchUpdates {
            tableView.reloadRows(at: [indexPath], with: .automatic )
        }
    }
}
