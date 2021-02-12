//
//  ViewController.swift
//  Groove
//
//  Created by Eric Jang on 2021/02/05.
//

import UIKit

class ViewController: UIViewController {
  
  enum Section: String, CaseIterable {
    case topSection = "#내돈내듣 VIBE",
         featuredPlaylists = "Featured Playlists",
         mixtapesForYou = "Mixtapes For You",
         favoritePlaylists = "Favorite Playlists",
         playlistsYouMayLike = "Playlists You May Like",
         djStation = "DJ Station",
         recentlyPlayed = "Recently Played",
         recommendedPlaylists = "VIBE Recommended Playlists",
         holidayMorning = "Holiday Morning",
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
    collectionView.register(TopSectionHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: TopSectionHeaderView.reuseIdentifier)
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
    layoutConfiguration.interSectionSpacing = 40
    layout.configuration = layoutConfiguration
    
    return layout
  }
  
  func generateLayout(section sectionType: Section, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
    typealias OrthogonalScrollBehavior = UICollectionLayoutSectionOrthogonalScrollingBehavior
    
    let visibleGroupCount: CGFloat
    switch sectionType {
    case .featuredPlaylists, .recentlyPlayed, .recommendedPlaylists, .holidayMorning, .newSongsYouMayLike, .magazine:
      visibleGroupCount = 1
    default:
      visibleGroupCount = 2
    }

    let orthogonalScrollBehavior: OrthogonalScrollBehavior
    switch sectionType {
    case .featuredPlaylists, .recentlyPlayed, .recommendedPlaylists, .holidayMorning, .newSongsYouMayLike, .magazine:
      orthogonalScrollBehavior = .groupPaging
    case .mixtapesForYou, .favoritePlaylists, .playlistsYouMayLike, .djStation, .nowReplay:
      orthogonalScrollBehavior = .continuousGroupLeadingBoundary
    case .topSection:
      orthogonalScrollBehavior = .none
    }
    
    
    let itemContentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 10, trailing: 5)
    let groupWidth = layoutEnvironment.container.contentSize.width * 0.93
    let groupWidthDimension = NSCollectionLayoutDimension.absolute(groupWidth / visibleGroupCount)
    let sectionSideInset = (layoutEnvironment.container.contentSize.width - groupWidth) / 2
    let sectionContentInsets = NSDirectionalEdgeInsets(top: 12, leading: sectionSideInset, bottom: 0, trailing: sectionSideInset)
    let topSectionContentInsets = NSDirectionalEdgeInsets(top: 0, leading: sectionSideInset, bottom: -60, trailing: sectionSideInset)
    
    let layoutSection: NSCollectionLayoutSection
    switch sectionType {
    case .featuredPlaylists:
      layoutSection = self.generateFeaturedPlaylistLayout(itemContentInsets: itemContentInsets,
                                                 groupWidthDimension: groupWidthDimension)
    case .mixtapesForYou, .favoritePlaylists, .playlistsYouMayLike, .nowReplay:
      layoutSection = self.generateHalfWidthLayout(section: sectionType,
                                               itemContentInsets: itemContentInsets,
                                               groupWidthDimension: groupWidthDimension)
    case .djStation, .magazine:
      layoutSection = self.generateSquareLayout(itemContentInsets: itemContentInsets,
                                          groupWidthDimension: groupWidthDimension)
    case .recentlyPlayed, .newSongsYouMayLike:
      layoutSection = self.generateTracksLayout(itemContentInsets: itemContentInsets,
                                       groupWidthDimension: groupWidthDimension)
    case .recommendedPlaylists, .holidayMorning:
      layoutSection = self.generateFullWidthPlaylistLayout(itemContentInsets: itemContentInsets,
                                                        groupWidthDimension: groupWidthDimension)
    case .topSection:
      layoutSection = self.generateTopSectionLayout(groupWidthDimension: groupWidthDimension)
    }
    
    layoutSection.orthogonalScrollingBehavior = orthogonalScrollBehavior
    layoutSection.contentInsets = sectionType != .topSection ? sectionContentInsets : topSectionContentInsets
    
    return layoutSection
  }
  
  func generateFeaturedPlaylistLayout(itemContentInsets: NSDirectionalEdgeInsets,
                                      groupWidthDimension: NSCollectionLayoutDimension)
  -> NSCollectionLayoutSection
  {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = itemContentInsets
    
    let groupSize = NSCollectionLayoutSize(widthDimension: groupWidthDimension, heightDimension: .fractionalHeight(0.35))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    return section
  }
  
  func generateHalfWidthLayout(section: Section,
                                    itemContentInsets: NSDirectionalEdgeInsets,
                                    groupWidthDimension: NSCollectionLayoutDimension)
  -> NSCollectionLayoutSection
  {
    let groupHeightDimension: NSCollectionLayoutDimension
    switch section {
    case .mixtapesForYou:
      groupHeightDimension = .fractionalHeight(0.33)
    case .nowReplay:
      groupHeightDimension = .fractionalHeight(0.4)
    default:
      groupHeightDimension = .fractionalHeight(0.3)
    }
    
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = itemContentInsets
    
    let groupSize = NSCollectionLayoutSize(widthDimension: groupWidthDimension, heightDimension: groupHeightDimension)
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(23))
    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                             elementKind: UICollectionView.elementKindSectionHeader,
                                                             alignment: .topLeading)
    let section = NSCollectionLayoutSection(group: group)
    section.boundarySupplementaryItems = [header]
    return section
  }
  
  func generateSquareLayout(itemContentInsets: NSDirectionalEdgeInsets,
                               groupWidthDimension: NSCollectionLayoutDimension)
  -> NSCollectionLayoutSection
  {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = itemContentInsets
    
    let groupSize = NSCollectionLayoutSize(widthDimension: groupWidthDimension, heightDimension: groupWidthDimension)
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(23))
    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                             elementKind: UICollectionView.elementKindSectionHeader,
                                                             alignment: .topLeading)
    let section = NSCollectionLayoutSection(group: group)
    section.boundarySupplementaryItems = [header]
    
    return section
  }
  
  func generateFullWidthPlaylistLayout(itemContentInsets: NSDirectionalEdgeInsets,
                                             groupWidthDimension: NSCollectionLayoutDimension)
  -> NSCollectionLayoutSection
  {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = itemContentInsets
    
    let groupSize = NSCollectionLayoutSize(widthDimension: groupWidthDimension, heightDimension: .fractionalHeight(0.6))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(23))
    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
    
    let section = NSCollectionLayoutSection(group: group)
    section.boundarySupplementaryItems = [header]
    return section
  }
  
  func generateTracksLayout(itemContentInsets: NSDirectionalEdgeInsets,
                            groupWidthDimension: NSCollectionLayoutDimension)
  -> NSCollectionLayoutSection
  {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = itemContentInsets
    
    let groupSize = NSCollectionLayoutSize(widthDimension: groupWidthDimension, heightDimension: .fractionalHeight(0.4))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(23))
    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)

    let section = NSCollectionLayoutSection(group: group)
    section.boundarySupplementaryItems = [header]
    return section
  }
  
  func generateTopSectionLayout(groupWidthDimension: NSCollectionLayoutDimension) -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: groupWidthDimension, heightDimension: .fractionalHeight(0.4))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
    
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
    
    let section = NSCollectionLayoutSection(group: group)
    section.boundarySupplementaryItems = [header]
    return section
  }
}

// MARK: - Collection View Data Source -
extension ViewController {
  func configureDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView)
    {( collectionView, indexPath, item) -> UICollectionViewCell? in
      let sectionType = Section.allCases[indexPath.section]
      
      switch sectionType {
      case .featuredPlaylists:
        guard let featuredPlaylistCell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCell.reuseIdentifier, for: indexPath) as? FeaturedPlaylistCell, let playlist = item as? Playlist else { fatalError("Cannot create new cell") }
        
        featuredPlaylistCell.title.text = playlist.title
        featuredPlaylistCell.subtitle.text = playlist.subtitle
        featuredPlaylistCell.themeLabel.text = playlist.theme
        featuredPlaylistCell.thumbnail.backgroundColor = sectionType.color
        
        return featuredPlaylistCell
        
      case .mixtapesForYou, .favoritePlaylists, .playlistsYouMayLike:
        guard let commonCell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonPlaylistCell.reuseIdentifier, for: indexPath) as? CommonPlaylistCell,
              let playlist = item as? Playlist else { fatalError("Cannot create new cell")}
        
        commonCell.title.text = playlist.title
        commonCell.subtitle.text = playlist.subtitle
        commonCell.thumbnail.backgroundColor = sectionType.color
        
        return commonCell
      case .recentlyPlayed, .newSongsYouMayLike:
        guard let trackCell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCell.reuseIdentifier,
                                                                 for: indexPath) as? TrackCell,
              let track = item as? Track
        else { fatalError("Cannot create new cell") }
        
        trackCell.title.text = track.title
        trackCell.artist.text = track.artists.joined(separator: ", ")
        trackCell.thumbnail.backgroundColor = sectionType.color
        
        return trackCell
        
      case .recommendedPlaylists, .holidayMorning:
        guard let commonCell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonPlaylistCell.reuseIdentifier, for: indexPath) as? CommonPlaylistCell, let playlist = item as? Playlist else { fatalError("Cannot create new cell")}
        
        commonCell.title.text = playlist.title
        commonCell.subtitle.text = playlist.subtitle
        commonCell.thumbnail.backgroundColor = sectionType.color
        commonCell.caption.text = playlist.caption
        
        return commonCell
        
      case .djStation, .magazine, .topSection:
        guard let commonCell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonPlaylistCell.reuseIdentifier, for: indexPath) as? CommonPlaylistCell else { fatalError("Cannot create new cell")}
        
        commonCell.thumbnail.backgroundColor = sectionType.color
        
        return commonCell
        
      case .nowReplay:
        guard let replayCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReplayCell.reuseIdentifier, for: indexPath) as? ReplayCell, let playlist = item as? Playlist else { fatalError("Cannot create new cell")}
        
        replayCell.thumbnail.backgroundColor = sectionType.color
        replayCell.title.text = playlist.title
        
        return replayCell
      }
    }
    
    dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
      
      let section = Section.allCases[indexPath.section]
      if section == .topSection {
        guard let topSectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TopSectionHeaderView.reuseIdentifier, for: indexPath) as? TopSectionHeaderView else { fatalError("Cannot create new supplementary view") }
        
        topSectionHeaderView.title.text = section.rawValue
        
        return topSectionHeaderView
      } else {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderView.reuseIdentifier, for: indexPath) as? PlaylistHeaderView else { fatalError("Cannot create new supplementary view") }
        headerView.header.text = section.rawValue
        return headerView
      }
      
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
      if section == .recentlyPlayed || section == .newSongsYouMayLike {
        guard let tracks = playlistCollection.playlists[0].tracks else { return }
        snapshot.appendItems(tracks)
      } else {
        snapshot.appendItems(playlistCollection.playlists)
      }
    }
    
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}
