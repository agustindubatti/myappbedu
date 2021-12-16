//
//  CurrentSong.swift
//  CleanExample
//
//  Created by Agustin Dubatti on 01/12/2021.
//

import Foundation


class CurrentSong {
    var name: String
    var duration: Double
    var timePlayed: Double {
        didSet {
            print(oldValue)
        }
    }
    
    init(name: String, duration: Double, timePlayed: Double) {
        self.name = name
        self.duration = duration
        self.timePlayed = timePlayed
    }
}
