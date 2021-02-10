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
  }
  
  @IBOutlet weak var collectionView: UICollectionView!
  private var dataSource: UICollectionViewDiffableDataSource<Section, Playlist>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
  }
  
  func setupCollectionView() {
    collectionView.showsVerticalScrollIndicator = false
    collectionView.collectionViewLayout = configureLayout()
    configureDataSource()
    configureSnapshot()
  }
  
}

// MARK: - Collection View Layout-
extension ViewController {
  func configureLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout {
      (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in

      let sectionLayoutKind = Section.allCases[sectionIndex]
      
      switch sectionLayoutKind {
      case .featuredPlaylists:
        return self.generateFeaturedPlaylistLayout()
      case .mixtapesForYou, .favoritePlaylists, .playlistsYouMayLike:
        return self.generateCommonPlaylistLayout(section: sectionLayoutKind)
      case .djStation:
        return self.generateDJStationLayout()
      case .recentlyPlayed, .newSongsYouMayLike:
        return self.generateTracksLayout()
      case .recommendedPlaylists:
        return self.generateVIBErecommendedPlaylistLayout()
      default:
        return self.generateDJStationLayout()
      }
    }
    
    let layoutConfiguration = UICollectionViewCompositionalLayoutConfiguration()
    layoutConfiguration.interSectionSpacing = 40
    layout.configuration = layoutConfiguration
    
    return layout
  }
  
  func generateFeaturedPlaylistLayout() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 6, bottom: 10, trailing: 6)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.96), heightDimension: .fractionalHeight(0.33))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging
    section.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 0, bottom: 10, trailing: 12)
    
    return section
  }
  
  func generateCommonPlaylistLayout(section: Section) -> NSCollectionLayoutSection {
    var groupHeightDimension: NSCollectionLayoutDimension {
      switch section {
      case .mixtapesForYou:
        return .fractionalHeight(0.33)
      case .favoritePlaylists, .playlistsYouMayLike:
        return .fractionalHeight(0.3)
      default:
        return .fractionalHeight(0.1)
      }
    }
    
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 4)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.48), heightDimension: groupHeightDimension)
//    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.48), heightDimension: .estimated(250))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 12)
    
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(23))
    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
    section.boundarySupplementaryItems = [header]
    
    return section
  }
  
  func generateDJStationLayout() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 8, bottom: 0, trailing: 4)
    
    let groupDimension = NSCollectionLayoutDimension.fractionalWidth(0.48)
    let groupSize = NSCollectionLayoutSize(widthDimension: groupDimension, heightDimension: groupDimension)
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 12)
    
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(23))
    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
    section.boundarySupplementaryItems = [header]
    
    return section
  }
  
  func generateVIBErecommendedPlaylistLayout() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 6, bottom: 10, trailing: 6)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.927), heightDimension: .fractionalHeight(0.6))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPagingCentered
    section.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 12)
    
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(23))
    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
    section.boundarySupplementaryItems = [header]
    
    return section
  }
  
  func generateTracksLayout() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 4)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.96), heightDimension: .fractionalHeight(0.4))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .paging
    section.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 12)
    
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(23))
    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
    section.boundarySupplementaryItems = [header]
    
    return section
  }
}

// MARK: - Collection View Data Source -
extension ViewController {
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
        
        commonCell.title.text = sectionType != Section.djStation ? playlist.title : ""
        commonCell.subtitle.text = playlist.subtitle
        commonCell.thumbnail.backgroundColor = Section.allCases[indexPath.section].color
        
        return commonCell
        
      case .recentlyPlayed:
        guard let trackCell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCell.reuseIdentifier, for: indexPath) as? TrackCell, let track = playlist.tracks?[indexPath.item] else { fatalError("Cannot create new cell") }
        
        trackCell.title.text = track.title
        trackCell.artist.text = track.artists.joined(separator: ", ")
        trackCell.thumbnail.backgroundColor = Section.allCases[indexPath.section].color
        
        return trackCell
        
      case .recommendedPlaylists:
        guard let commonCell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonPlaylistCell.reuseIdentifier, for: indexPath) as? CommonPlaylistCell else { fatalError("Cannot create new cell")}
        
        commonCell.title.text = playlist.title
        commonCell.subtitle.text = playlist.subtitle
        commonCell.thumbnail.backgroundColor = Section.allCases[indexPath.section].color
        commonCell.caption.text = playlist.caption
        
        return commonCell
        
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
    
    dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
      guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderView.reuseIdentifier, for: indexPath) as? PlaylistHeaderView else { fatalError("Cannot create new supplementary view") }
      
      headerView.header.text = Section.allCases[indexPath.section].rawValue
      return headerView
    }
  }
}

// MARK: - Collection View Snapshot -
extension ViewController {
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
