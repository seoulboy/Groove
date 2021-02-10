//
//  TrackCell.swift
//  Groove
//
//  Created by Eric Jang on 2021/02/10.
//

import UIKit

class TrackCell: UICollectionViewCell {
  static let reuseIdentifier = String(describing: TrackCell.self)
  @IBOutlet weak var thumbnail: UIView!
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var artist: UILabel!
}
