//
//  Track.swift
//  Groove
//
//  Created by Eric Jang on 2021/02/10.
//

import Foundation

struct Track: Decodable {
  let title: String
  let artists: [String]
  let identifier = UUID().uuidString
}

extension Track: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }
  
  
}

extension Track: Equatable {
  static func ==(lhs: Track, rhs: Track) -> Bool {
    lhs.identifier == rhs.identifier
  }
}
