//
//  Playlist.swift
//  Groove
//
//  Created by Eric Jang on 2021/02/10.
//

import Foundation

struct Playlist: Decodable {
  let theme: String?
  let title: String?
  let subtitle: String?
  let caption: String?
  let tracks: [Track]?
  let identifier = UUID().uuidString
}

extension Playlist: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }
}

extension Playlist: Equatable {
  static func ==(lhs: Playlist, rhs: Playlist) -> Bool {
    lhs.identifier == rhs.identifier
  }
}
