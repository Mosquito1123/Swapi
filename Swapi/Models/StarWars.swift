//
//  Model.swift
//  Star Wars Index
//
//  Created by TuyenLe on 7/26/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import Foundation
import SwiftyJSON

struct LocalCache {
    public static var characters: Dictionary<Int, People>?
    public static var films: Dictionary<Int, Film>?
    public static var planets: Dictionary<Int, Planet>?
    public static var species: Dictionary<Int, Specie>?
    public static var starships: Dictionary<Int, Starship>?
    public static var vehicles: Dictionary<Int, Vehicle>?
}

struct People: Equatable {
    static func == (lhs: People, rhs: People) -> Bool {
        return true
    }
    
    var name: String

    var height: String

    var mass: String

    var hairColor: String

    var skinColor: String

    var eyeColor: String

    var birthYear: String

    var gender: String

    var homeworld: String

    var films: [JSON]

    var vehicles: [JSON]

    var starships: [JSON]

    var species: [JSON]
}

struct Film: Equatable {
    static func == (lhs: Film, rhs: Film) -> Bool {
        return true
    }
    
    var title: String
    
    var episode: Int
    
    var openingCrawl: String
    
    var director: String
    
    var producer: String
    
    var releaseDate: String
    
    var characters: [JSON]
    
    var planets: [JSON]
    
    var starships: [JSON]

    var vehicles: [JSON]

    var species: [JSON]
    
    var created: String
    
    var edited: String
}

struct Planet: Equatable {
    var name: String

    var rotationPeriod: String

    var orbitalPeriod: String

    var diameter: String

    var climate: String

    var gravity: String

    var terrain: String

    var surfaceWater: String

    var population: String

    var residents: [JSON]

    var films: [JSON]

    var created: String

    var edited: String
}

struct Specie: Equatable {
    var name: String

    var classification: String

    var designation: String

    var averageHeight: String

    var skinColors: String

    var hairColors: String

    var eyeColors: String

    var averageLifespan: String

    var homeworld: [JSON]

    var language: String

    var people: [JSON]

    var films: [JSON]

    var created: String

    var edited: String
}

protocol Vehicle {
    var name: String { get set }

    var model: String { get set }

    var manufacturer: String { get set }

    var costInCredits: String { get set }

    var length: String { get set }

    var maxAtmospheringSpeed: String { get set }

    var crew: String { get set }

    var passenger: String { get set }

    var cargoCapacity: String { get set }

    var consumables: String { get set }

    var vehicleClass: String { get set }

    var pilots: [JSON] { get set }

    var films: [JSON] { get set }

    var created: String { get set }

    var edited: String { get set }
}

struct Starship: Vehicle {
    var name: String

    var model: String

    var manufacturer: String

    var costInCredits: String

    var length: String

    var maxAtmospheringSpeed: String

    var crew: String

    var passenger: String

    var cargoCapacity: String

    var consumables: String

    var vehicleClass: String

    var pilots: [JSON]

    var films: [JSON]

    var created: String

    var edited: String

    var heperdriveRating: String?

    var mglt: String?

    var starshipClass: String?
}


