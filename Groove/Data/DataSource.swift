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
    guard let url = Bundle.main.url(forResource: "Playlists", withExtension: "plist") else {
      self.playlists = []
      return
    }
    
    do {
      if let data = try? Data(contentsOf: url) {
        self.playlists = try decoder.decode([PlaylistCollection].self, from: data)
        return
      }
    } catch {
      print(error)
    }
    self.playlists = []
  }
}
