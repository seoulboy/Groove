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
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var subtitle: UILabel!
  @IBOutlet weak var thumbnail: UIView!
}
