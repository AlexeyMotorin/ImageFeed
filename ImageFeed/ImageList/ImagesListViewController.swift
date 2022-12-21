//
//  ViewController.swift
//  ImageFeed
//
//  Created by Алексей Моторин on 19.12.2022.
//

import UIKit

final class ImagesListViewController: UIViewController {

    // MARK: - @IBOutlet
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Private properties
    private let photosName = Array(0..<20).map { "\($0)" }
    
    private lazy var dateForrmater: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
   
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func config(cell: ImagesListCell, for indexPath: IndexPath) {
       
        guard let image = UIImage(named: photosName[indexPath.row]) else { return }
        cell.cellImageView.image = image
        cell.dateLabel.text = dateForrmater.string(from: Date())
        
        print("\(indexPath.row % 2)")
        
        let isLikedImage: UIImage? = indexPath.row % 2 == 0 ? UIImage(named: "NoLike") : UIImage(named: "IsLike")
        cell.likeButton.setImage(isLikedImage, for: .normal)
    
    }
    
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photosName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifire, for: indexPath)
        
        guard let imagesListCell = cell as? ImagesListCell else { return UITableViewCell() }

        config(cell: imagesListCell, for: indexPath)
        return imagesListCell
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
