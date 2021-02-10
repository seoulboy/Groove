//
//  ViewController.swift
//  Groove
//
//  Created by Eric Jang on 2021/02/05.
//

import UIKit

class ViewController: UIViewController {

  enum Section: String, CaseIterable {
    case featuredPlaylists = "Featured Playlists",
         mixtapesForYou = "Mixtapes For You",
         favoritePlaylists = "Favorite Playlists",
         playlistsYouMayLike = "Playlists You May Like",
         djStation = "DJ Station",
         recentlyPlayed = "Recently Played",
         recommendedPlaylists = "VIBE Recommended Playlists",
         chillOut = "Chill Out",
         newSongsYouMayLike = "New Songs You May Like",
         magazine = "Magazine",
         nowReplay = "Replay"
    
    var color: UIColor {
      switch self {
      case .featuredPlaylists: return UIColor.systemRed.withAlphaComponent(0.3)
      case .mixtapesForYou: return UIColor.systemOrange.withAlphaComponent(0.3)
      case .favoritePlaylists: return UIColor.systemPink.withAlphaComponent(0.3)
      case .playlistsYouMayLike: return UIColor.systemBlue.withAlphaComponent(0.3)
      case .djStation: return UIColor.systemTeal.withAlphaComponent(0.3)
      case .recentlyPlayed: return UIColor.systemGreen.withAlphaComponent(0.3)
      case .recommendedPlaylists: return UIColor.systemPurple.withAlphaComponent(0.3)
      case .chillOut: return UIColor.systemYellow.withAlphaComponent(0.3)
      case .newSongsYouMayLike: return UIColor.systemIndigo.withAlphaComponent(0.3)
      case .magazine: return UIColor.systemGray.withAlphaComponent(0.3)
      case .nowReplay: return UIColor.white.withAlphaComponent(0.3)
      }
    }
    
//    var itemFractionalDimension: (CGFloat, CGFloat) {
//      switch self {
//      default: return (width: 1.0, height: 1.0)
//      }
//    }
    
  
  }
  
  @IBOutlet weak var collectionView: UICollectionView!
  private var dataSource: UICollectionViewDiffableDataSource<Section, Playlist>!
  
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
    let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
      let sectionLayoutKind = Section.allCases[sectionIndex]
      
      switch sectionLayoutKind {
      case .featuredPlaylists: return self.generateFeaturedPlaylistLayout()
      case .mixtapesForYou, .favoritePlaylists, .playlistsYouMayLike, .djStation: return self.generateCommonPlaylistLayout()
      default: return self.generateFeaturedPlaylistLayout()
      }
    }
    
    return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
  }
  
  func generateFeaturedPlaylistLayout() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .fractionalHeight(0.33))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging
    section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    return section
  }
  
  func generateCommonPlaylistLayout() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.465), heightDimension: .fractionalHeight(0.33))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
    section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    return section
  }
  
  func configureDataSource() {
    dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView)
    {(
      collectionView: UICollectionView,
       indexPath: IndexPath,
       playlist: Playlist
    ) -> UICollectionViewCell? in
      let sectionType = Section.allCases[indexPath.section]
      
      switch sectionType {
      case .featuredPlaylists:
        guard let featuredPlaylistCell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCell.reuseIdentifier, for: indexPath) as? FeaturedPlaylistCell else { fatalError("Cannot create new cell") }
        
        featuredPlaylistCell.title.text = playlist.title
        featuredPlaylistCell.subtitle.text = playlist.subtitle
        featuredPlaylistCell.themeLabel.text = playlist.theme
        featuredPlaylistCell.thumbnail.backgroundColor = Section.allCases[indexPath.section].color
        
        return featuredPlaylistCell
        
      case .mixtapesForYou, .favoritePlaylists, .playlistsYouMayLike, .djStation:
        guard let commonCell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonPlaylistCell.reuseIdentifier, for: indexPath) as? CommonPlaylistCell else { fatalError("Cannot create new cell")}
        
        commonCell.title.text = playlist.title
        commonCell.subtitle.text = playlist.subtitle
        commonCell.thumbnail.backgroundColor = Section.allCases[indexPath.section].color
        
        return commonCell
      case .recentlyPlayed:
        return nil
      case .recommendedPlaylists:
        return nil
      case .chillOut:
        return nil
      case .newSongsYouMayLike:
        return nil
      case .magazine:
        return nil
      case .nowReplay:
        return nil
      }
      
    }
  }
  
  func configureSnapshot() {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Playlist>()
    
    let playlistCollections = DataSource.shared.playlists
    playlistCollections.enumerated().forEach { (index, playlistCollection) in
      snapshot.appendSections([Section.allCases[index]])
      snapshot.appendItems(playlistCollection.playlists)
    }
    
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}
