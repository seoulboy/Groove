//
//  ViewController.swift
//  Groove
//
//  Created by Eric Jang on 2021/02/05.
//

import UIKit

class ViewController: UIViewController {

  enum Section {
    case main
  }
  
  @IBOutlet weak var collectionView: UICollectionView!
  private var dataSource: UICollectionViewDiffableDataSource<PlaylistCollection, Playlist>!
  
  override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

  func setupCollectionView() {
    collectionView.collectionViewLayout = configureLayout()
    configureDataSource()
    configureSnapshot()
  }

}

// MARK: - CollectionView -
extension ViewController {
  func configureLayout() -> UICollectionViewLayout {
    
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.96), heightDimension: .fractionalHeight(0.3))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
    
    return UICollectionViewCompositionalLayout(section: section)
  }
  
  func configureDataSource() {
    dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView: UICollectionView, indexPath: IndexPath, playlist: Playlist) -> UICollectionViewCell? in
      guard let featuredPlaylistCell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCell.reuseIdentifier, for: indexPath) as? FeaturedPlaylistCell else { fatalError("Cannot create cell") }
      
      featuredPlaylistCell.titleLabel.text = playlist.title
      featuredPlaylistCell.subtitleLabel.text = playlist.subtitle
      featuredPlaylistCell.themeLabel.text = playlist.theme
      featuredPlaylistCell.thumbnailView.backgroundColor = UIColor.systemRed.withAlphaComponent(0.3)
      
      return featuredPlaylistCell
    })
  }
  
  func configureSnapshot() {
    var snapshot = NSDiffableDataSourceSnapshot<PlaylistCollection, Playlist>()
    
    let playlistCollections = DataSource.shared.playlists
    playlistCollections.forEach { playlistCollection in
      snapshot.appendSections([playlistCollection])
      snapshot.appendItems(playlistCollection.playlists)
    }
    
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}
