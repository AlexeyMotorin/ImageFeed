//
//  imageFeedCell.swift
//  ImageFeed
//
//  Created by Алексей Моторин on 21.12.2022.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifire = "ImagesListCell"
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
}
