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
      let colors: [UIColor] = [.systemRed, .systemOrange, .systemPink, .systemBlue, .systemTeal, .systemGreen, .systemPurple, .systemYellow, .systemIndigo, .systemGray, .white]
      return colors[Int.random(in: 0..<colors.count)].withAlphaComponent(0.5)
    }
  }
  
  @IBOutlet weak var collectionView: UICollectionView!
  private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
    
    overrideUserInterfaceStyle = .dark
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
    let layout = UICollectionViewCompositionalLayout { [weak self]
      (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
      guard let self = self else { fatalError("Cannot create layout")}
      return self.generateLayout(section: Section.allCases[sectionIndex], layoutEnvironment: layoutEnvironment)
    }
    
    let layoutConfiguration = UICollectionViewCompositionalLayoutConfiguration()
    layoutConfiguration.interSectionSpacing = 30
    layout.configuration = layoutConfiguration
    
    return layout
  }
  
  func generateLayout(section: Section, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
    let visibleGroupCount: CGFloat
    
    switch section {
    case .featuredPlaylists, .recommendedPlaylists, .recentlyPlayed:
      visibleGroupCount = 1
    default:
      visibleGroupCount = 2
    }
    
    let itemContentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 10, trailing: 5)
    let groupWidth = layoutEnvironment.container.contentSize.width * 0.93
    let groupWidthDimension = NSCollectionLayoutDimension.absolute(groupWidth / visibleGroupCount)
    let sectionSideInset = (layoutEnvironment.container.contentSize.width - groupWidth) / 2
    let sectionContentInsets = NSDirectionalEdgeInsets(top: 12, leading: sectionSideInset, bottom: 0, trailing: sectionSideInset)
    
    switch section {
    case .featuredPlaylists:
      return self.generateFeaturedPlaylistLayout(itemContentInsets: itemContentInsets,
                                                 groupWidthDimension: groupWidthDimension,
                                                 sectionContentInsets: sectionContentInsets)
    case .mixtapesForYou, .favoritePlaylists, .playlistsYouMayLike:
      return self.generateCommonPlaylistLayout(section: section,
                                               itemContentInsets: itemContentInsets,
                                               groupWidthDimension: groupWidthDimension,
                                               sectionContentInsets: sectionContentInsets)
    case .djStation:
      return self.generateDJStationLayout(itemContentInsets: itemContentInsets,
                                          groupWidthDimension: groupWidthDimension,
                                          sectionContentInsets: sectionContentInsets)
    case .recentlyPlayed, .newSongsYouMayLike:
      return self.generateTracksLayout(itemContentInsets: itemContentInsets,
                                       groupWidthDimension: groupWidthDimension,
                                       sectionContentInsets: sectionContentInsets)
    case .recommendedPlaylists:
      return self.generateVIBErecommendedPlaylistLayout(itemContentInsets: itemContentInsets,
                                                        groupWidthDimension: groupWidthDimension,
                                                        sectionContentInsets: sectionContentInsets)
    default:
      return self.generateDJStationLayout(itemContentInsets: itemContentInsets,
                                          groupWidthDimension: groupWidthDimension,
                                          sectionContentInsets: sectionContentInsets)
    }
  }
  
  func generateFeaturedPlaylistLayout(itemContentInsets: NSDirectionalEdgeInsets,
                                      groupWidthDimension: NSCollectionLayoutDimension,
                                      sectionContentInsets: NSDirectionalEdgeInsets)
  -> NSCollectionLayoutSection
  {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = itemContentInsets
    
    let groupSize = NSCollectionLayoutSize(widthDimension: groupWidthDimension, heightDimension: .fractionalHeight(0.33))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging
    section.contentInsets = sectionContentInsets
    
    return section
  }
  
  func generateCommonPlaylistLayout(section: Section,
                                    itemContentInsets: NSDirectionalEdgeInsets,
                                    groupWidthDimension: NSCollectionLayoutDimension,
                                    sectionContentInsets: NSDirectionalEdgeInsets)
  -> NSCollectionLayoutSection
  {
    var groupHeightDimension: NSCollectionLayoutDimension {
      switch section {
      case .mixtapesForYou:
        return .fractionalHeight(0.33)
      default:
        return .fractionalHeight(0.3)
      }
    }
    
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = itemContentInsets
    
    let groupSize = NSCollectionLayoutSize(widthDimension: groupWidthDimension, heightDimension: groupHeightDimension)
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
    section.contentInsets = sectionContentInsets
    
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(23))
    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                             elementKind: UICollectionView.elementKindSectionHeader,
                                                             alignment: .topLeading)
    section.boundarySupplementaryItems = [header]
    
    return section
  }
  
  func generateDJStationLayout(itemContentInsets: NSDirectionalEdgeInsets,
                               groupWidthDimension: NSCollectionLayoutDimension,
                               sectionContentInsets: NSDirectionalEdgeInsets)
  -> NSCollectionLayoutSection
  {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = itemContentInsets
    
    let groupSize = NSCollectionLayoutSize(widthDimension: groupWidthDimension, heightDimension: groupWidthDimension)
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
    section.contentInsets = sectionContentInsets
    
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(23))
    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                             elementKind: UICollectionView.elementKindSectionHeader,
                                                             alignment: .topLeading)
    section.boundarySupplementaryItems = [header]
    
    return section
  }
  
  func generateVIBErecommendedPlaylistLayout(itemContentInsets: NSDirectionalEdgeInsets,
                                             groupWidthDimension: NSCollectionLayoutDimension,
                                             sectionContentInsets: NSDirectionalEdgeInsets)
  -> NSCollectionLayoutSection
  {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = itemContentInsets
    
    let groupSize = NSCollectionLayoutSize(widthDimension: groupWidthDimension, heightDimension: .fractionalHeight(0.6))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging
    section.contentInsets = sectionContentInsets
    
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(23))
    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
    section.boundarySupplementaryItems = [header]
    
    return section
  }
  
  func generateTracksLayout(itemContentInsets: NSDirectionalEdgeInsets,
                            groupWidthDimension: NSCollectionLayoutDimension,
                            sectionContentInsets: NSDirectionalEdgeInsets)
  -> NSCollectionLayoutSection
  {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = itemContentInsets
    
    let groupSize = NSCollectionLayoutSize(widthDimension: groupWidthDimension, heightDimension: .fractionalHeight(0.4))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging
    section.contentInsets = sectionContentInsets
    
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(23))
    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
    section.boundarySupplementaryItems = [header]
    
    return section
  }
}

// MARK: - Collection View Data Source -
extension ViewController {
  func configureDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView)
    {( collectionView, indexPath, item
    ) -> UICollectionViewCell? in
      let sectionType = Section.allCases[indexPath.section]
      
      switch sectionType {
      case .featuredPlaylists:
        guard let featuredPlaylistCell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCell.reuseIdentifier, for: indexPath) as? FeaturedPlaylistCell, let playlist = item as? Playlist else { fatalError("Cannot create new cell") }
        
        featuredPlaylistCell.title.text = playlist.title
        featuredPlaylistCell.subtitle.text = playlist.subtitle
        featuredPlaylistCell.themeLabel.text = playlist.theme
        featuredPlaylistCell.thumbnail.backgroundColor = Section.allCases[indexPath.section].color
        
        return featuredPlaylistCell
        
      case .mixtapesForYou, .favoritePlaylists, .playlistsYouMayLike, .djStation:
        guard let commonCell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonPlaylistCell.reuseIdentifier, for: indexPath) as? CommonPlaylistCell,
              let playlist = item as? Playlist else { fatalError("Cannot create new cell")}
        
        commonCell.title.text = sectionType != Section.djStation ? playlist.title : ""
        commonCell.subtitle.text = playlist.subtitle
        commonCell.thumbnail.backgroundColor = Section.allCases[indexPath.section].color
        
        return commonCell
        
      case .recentlyPlayed:
        guard let trackCell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCell.reuseIdentifier,
                                                                 for: indexPath) as? TrackCell,
              let track = item as? Track
        else { fatalError("Cannot create new cell") }
        
        trackCell.title.text = track.title
        trackCell.artist.text = track.artists.joined(separator: ", ")
        trackCell.thumbnail.backgroundColor = Section.allCases[indexPath.section].color
        
        return trackCell
        
      case .recommendedPlaylists:
        guard let commonCell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonPlaylistCell.reuseIdentifier, for: indexPath) as? CommonPlaylistCell, let playlist = item as? Playlist else { fatalError("Cannot create new cell")}
        
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
    var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
    
    let playlistCollections = DataSource.shared.playlists
    playlistCollections.enumerated().forEach { (index, playlistCollection) in
      let section = Section.allCases[index]
      snapshot.appendSections([section])
      if let tracks = playlistCollection.playlists[0].tracks, section == .recentlyPlayed {
        snapshot.appendItems(tracks)
      } else {
        snapshot.appendItems(playlistCollection.playlists)
      }
    }
    
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}
