//
//  TopSectionHeaderView.swift
//  Groove
//
//  Created by Eric Jang on 2021/02/12.
//

import UIKit

class TopSectionHeaderView: UICollectionReusableView {
  static let reuseIdentifier = String(describing: TopSectionHeaderView.self)
  let title = UILabel()
  let profileView = UIView()
  let horizontalStackView = UIStackView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) not implemented")
  }
  
  func configure() {
    addSubview(horizontalStackView)
    horizontalStackView.addArrangedSubview(title)
    horizontalStackView.addArrangedSubview(profileView)
    
    title.font = UIFont.systemFont(ofSize: CGFloat(32), weight: .bold)
    
    let sideInset = CGFloat(10)
    
    horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: sideInset),
      horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -sideInset),
      horizontalStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
    
    profileView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      profileView.widthAnchor.constraint(equalToConstant: CGFloat(33)),
      profileView.widthAnchor.constraint(equalTo: profileView.heightAnchor, multiplier: 1),
    ])
    profileView.layoutIfNeeded()
    profileView.layer.cornerRadius = profileView.bounds.width / 2
    profileView.backgroundColor = UIColor.systemPurple.withAlphaComponent(1.0)
  }
  
}
