//
//  ReplayCell.swift
//  Groove
//
//  Created by Eric Jang on 2021/02/12.
//

import UIKit

class ReplayCell: UICollectionViewCell {
  static let reuseIdentifier = String(describing: ReplayCell.self)
  @IBOutlet weak var thumbnail: UIView!
  @IBOutlet weak var title: UILabel!
}
