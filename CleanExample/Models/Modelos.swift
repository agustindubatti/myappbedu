//
//  Modelos.swift
//  CleanExample
//
//  Created by Agustin Dubatti on 02/11/2021.
//

import Foundation

struct Account {
    let user: String
    let pass: String
}

struct Registered {
  let user1: Account = Account(user: "adubatti@gmail.com", pass: "test123")
}



struct Song: Codable, Hashable {
    let title: String?
    let artist: String?
    let album: String?
    let song_id: String?
    let genre: String?
    var isPlaying: Bool? //= false
    
    enum CodingKeys: String, CodingKey {
        case artist
        case title = "name"
        case album
        case genre
        case song_id = "song_id"
    }
}


enum MusicGenre {
  case Rock
  case Pop
  case Jazz
  case Classical
  case Electro
  case Reggea
}

enum PlayerStates {
    case play
    case pause
    case next
    case previous
}


struct AudioCellModel {
    var delegate : CelDelegate
    var songName : String
}

protocol CelDelegate{
    func updateState()
}
                
var misTracks: [Song] = []


enum OpcionesMenu: CaseIterable {
    case trash
    case download
    case addPlaylist
    case share
    
    var title: String {
        switch self {
        case .trash:
            return "Eliminar"
        case .download:
            return "Descargar"
        case .addPlaylist:
            return "Agregar a Playlist"
        case .share:
            return "Compartir"
        }
    }
    
    var imagen: UIImage? {
        switch self {
        case .trash:
            return UIImage(systemName: "trash")
        case .download:
            return UIImage(systemName: "arrow.down")
        case .addPlaylist:
            return UIImage(systemName: "plus.rectangle.fill.on.rectangle.fill")
        case .share:
            return UIImage(systemName: "square.and.arrow.up")
        }
    }
}


