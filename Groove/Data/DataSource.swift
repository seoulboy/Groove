//
//  DataSource.swift
//  Groove
//
//  Created by Eric Jang on 2021/02/10.
//

import UIKit

class DataSource {
  
  static let shared = DataSource()
  
  var playlists: [PlaylistCollection]
  private let decoder = PropertyListDecoder()
  
  private init() {
    guard let url = Bundle.main.url(forResource: "Playlists", withExtension: "plist"),
          let data = try? Data(contentsOf: url),
          let playlists =  try? decoder.decode([PlaylistCollection].self, from: data) else {
      self.playlists = []
      return
    }
    
    self.playlists = playlists
  }
}
