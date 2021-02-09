//
//  PlaylistCollection.swift
//  Groove
//
//  Created by Eric Jang on 2021/02/10.
//

import Foundation

struct PlaylistCollection: Decodable {
  let title: String
  let playlists: [Playlist]
  let identifier = UUID().uuidString
}

extension PlaylistCollection: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }
}

extension PlaylistCollection: Equatable {
  static func ==(lhs: PlaylistCollection, rhs: PlaylistCollection) -> Bool {
    lhs.identifier == rhs.identifier
  }
}
