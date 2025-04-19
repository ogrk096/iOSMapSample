//
//  Place.swift
//  camp
//
//  Created by 小黒皓太 on 2023/02/22.
//

import Foundation

struct Place {
    var PlaceID: Int
    var PlaceName: String
    var IdoMin: Int
    var IdoMax: Int
    var KeidoMin: Int
    var KeidoMax: Int
    var Count: Int
    var Info: String
    var Ido: Int
    var Keido: Int
    
    init(placeID: Int, placeName: String, idoMin: Int, idoMax: Int, keidoMin: Int, keidoMax: Int, count: Int, info: String, ido: Int, keido: Int) {
        self.PlaceID = placeID
        self.PlaceName = placeName
        self.IdoMin = idoMin
        self.IdoMax = idoMax
        self.KeidoMin = keidoMin
        self.KeidoMax = keidoMax
        self.Count = count
        self.Info = info
        self.Ido = ido
        self.Keido = keido
    }
}
