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
   
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func config(cell: ImagesListCell) {}
    
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifire, for: indexPath)
        
        guard let imagesListCell = cell as? ImagesListCell else { return UITableViewCell() }

        config(cell: imagesListCell)
        return imagesListCell
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
