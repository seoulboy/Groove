//
//  FeaturedPlaylistCell.swift
//  Groove
//
//  Created by Eric Jang on 2021/02/09.
//

import UIKit

class FeaturedPlaylistCell: UICollectionViewCell {
  static let reuseIdentifier = String(describing: FeaturedPlaylistCell.self)
  @IBOutlet weak var themeLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var thumbnailView: UIView!
}
