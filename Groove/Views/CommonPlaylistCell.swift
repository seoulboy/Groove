//
//  CommonPlaylistCell.swift
//  Groove
//
//  Created by Eric Jang on 2021/02/10.
//

import UIKit

class CommonPlaylistCell: UICollectionViewCell {
  static let reuseIdentifier = String(describing: CommonPlaylistCell.self)
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var subtitle: UILabel!
  @IBOutlet weak var thumbnail: UIView!
  @IBOutlet weak var caption: UILabel!
  
}
