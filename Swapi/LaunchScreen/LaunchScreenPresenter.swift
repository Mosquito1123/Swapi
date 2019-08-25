//
//  LaunchScreenPresenter.swift
//  Swapi
//
//  Created by TuyenLe on 7/30/19.
//  Copyright (c) 2019 TuyenLe. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import SwiftyJSON

protocol LaunchScreenPresentationLogic
{
    func cachCharacters(response: LaunchScreen.Fetch.Response.Characters)
    func cachFilms(response: LaunchScreen.Fetch.Response.Films)
    func cachPlanets(response: LaunchScreen.Fetch.Response.Planets)
    func cachSpecies(respones: LaunchScreen.Fetch.Response.Species)
    func cachStarships(response: LaunchScreen.Fetch.Response.Starships)
    func cachVehicles(response: LaunchScreen.Fetch.Response.Vehicles)
}

class LaunchScreenPresenter: LaunchScreenPresentationLogic
{

    weak var viewController: LaunchScreenDisplayLogic?

    // MARK: Caching data

    func cachCharacters(response: LaunchScreen.Fetch.Response.Characters) {
        let characterDatas = response.character
        var dict: Dictionary<Int, Character> = [Int: Character]()
        do {
            for characterData in characterDatas {
                if characterData == nil { continue }
                let json = try JSON(data: characterData!)
                
                for character in json["results"] {
                    let id = Int(character.1["url"].string!.components(separatedBy: "/")[5])!
                    dict[id] = Character(name: character.1["name"].string ?? "",
                                      height: character.1["height"].string ?? "",
                                      mass: character.1["mass"].string ?? "",
                                      hairColor: character.1["hair_color"].string ?? "",
                                      skinColor: character.1["skin_color"].string ?? "",
                                      eyeColor: character.1["eye_color"].string ?? "",
                                      birthYear: character.1["birth_year"].string ?? "",
                                      gender: character.1["gender"].string ?? "",
                                      homeworld: character.1["homeworld"].string ?? "",
                                      films: character.1["films"].array ?? [],
                                      vehicles: character.1["vehicles"].array ?? [],
                                      starships: character.1["starships"].array ?? [],
                                      species: character.1["species"].array ?? [])
                }
            }
            viewController?.cachPeople(viewModel: LaunchScreen.Fetch.ViewModel.Characters(characters: dict))
        } catch let error {
            print("Error parsing people: ", error)
        }
    }

    func cachFilms(response: LaunchScreen.Fetch.Response.Films) {
        guard let filmDatas = response.films else {
            print("film datas is null")
            return
        }
        var dict: Dictionary<Int, Film> = [Int: Film]()
        do {
            let json = try JSON(data: filmDatas)
                
            for film in json["results"] {
                let id = Int(film.1["url"].string!.components(separatedBy: "/")[5])!
                dict[id] = Film(title: film.1["title"].string ?? "",
                                episode: film.1["episode_id"].int ?? 0,
                                openingCrawl: film.1["opening_crawl"].string ?? "",
                                director: film.1["director"].string ?? "",
                                producer: film.1["producer"].string ?? "",
                                releaseDate: film.1["release_date"].string ?? "",
                                characters: film.1["characters"].array ?? [],
                                planets: film.1["planets"].array ?? [],
                                starships: film.1["starships"].array ?? [],
                                vehicles: film.1["vehicles"].array ?? [],
                                species: film.1["species"].array ?? [],
                                created: film.1["created"].string ?? "",
                                edited: film.1["edited"].string ?? "")
            }
            
            viewController?.cachFilms(viewModel: LaunchScreen.Fetch.ViewModel.Films(films: dict))
        } catch let error {
            print("Error parsing films: ", error)
        }
    }

    func cachPlanets(response: LaunchScreen.Fetch.Response.Planets) {
        var dict: Dictionary<Int, Planet> = [Int: Planet]()
        do {
            for planetData in response.planets {
                if planetData == nil { continue }
                
                let json = try JSON(data: planetData!)
                for planet in json["results"] {
                    let id = Int(planet.1["url"].string!.components(separatedBy: "/")[5])!
                    dict[id] = Planet(name: planet.1["name"].string ?? "",
                                      rotationPeriod: planet.1["rotation_period"].string ?? "",
                                      orbitalPeriod: planet.1["orbital_period"].string ?? "",
                                      diameter: planet.1["diameter"].string ?? "",
                                      climate: planet.1["climate"].string ?? "",
                                      gravity: planet.1["gravity"].string ?? "",
                                      terrain: planet.1["terrain"].string ?? "",
                                      surfaceWater: planet.1["surface_water"].string!,
                                      population: planet.1["population"].string!,
                                      residents: planet.1["residents"].array ?? [],
                                      films: planet.1["films"].array ?? [],
                                      created: planet.1["created"].string!,
                                      edited: planet.1["edited"].string!)
                }
            }
            
            viewController?.cachPlanets(viewModel: LaunchScreen.Fetch.ViewModel.Planets(planets: dict))
        } catch let error {
            print("Error parsing planets: ", error)
        }
    }

    func cachSpecies(respones: LaunchScreen.Fetch.Response.Species) {
        var dict: Dictionary<Int, Specie> = [Int: Specie]()
        do {
            for specieData in respones.species {
                if specieData == nil { continue }
                
                let json = try JSON(data: specieData!)
                for specie in json["results"] {
                    let id = Int(specie.1["url"].string!.components(separatedBy: "/")[5])!
                    dict[id] = Specie(name: specie.1["name"].string ?? "",
                                      classification: specie.1["classification"].string ?? "",
                                      designation: specie.1["designation"].string ?? "",
                                      averageHeight: specie.1["average_height"].string ?? "",
                                      skinColors: specie.1["skin_colors"].string ?? "",
                                      hairColors: specie.1["hair_colors"].string ?? "",
                                      eyeColors: specie.1["eye_colors"].string ?? "",
                                      averageLifespan: specie.1["average_lifespan"].string ?? "",
                                      homeworld: specie.1["homeworld"].array ?? [],
                                      language: specie.1["language"].string ?? "",
                                      people: specie.1["peoplen"].array ?? [],
                                      films: specie.1["films"].array ?? [],
                                      created: specie.1["created"].string ?? "",
                                      edited: specie.1["edited"].string ?? "")
                }
            }
            viewController?.cachSpecies(viewModel: LaunchScreen.Fetch.ViewModel.Species(species: dict))
        } catch let error {
            print("Error parsing species: ", error)
        }
    }

    func cachStarships(response: LaunchScreen.Fetch.Response.Starships) {
        var dict: Dictionary<Int, Starship> = [Int: Starship]()
        do {
            for starshipData in response.starships {
                if starshipData == nil { continue }
                
                let json = try JSON(data: starshipData!)
                for starship in json["results"] {
                    let id = Int(starship.1["url"].string!.components(separatedBy: "/")[5])!
                    dict[id] = Starship(name: starship.1["name"].string ?? "",
                                        model: starship.1["model"].string ?? "",
                                        manufacturer: starship.1["manufactuer"].string ?? "",
                                        costInCredits: starship.1["cost_in_credits"].string ?? "",
                                        length: starship.1["length"].string ?? "",
                                        maxAtmospheringSpeed: starship.1["max_atmosphering_speed"].string ?? "",
                                        crew: starship.1["crew"].string ?? "",
                                        passenger: starship.1["passenger"].string ?? "",
                                        cargoCapacity: starship.1["cargo_capacity"].string ?? "",
                                        consumables: starship.1["consumables"].string ?? "",
                                        vehicleClass: starship.1["vehicle_class"].string ?? "",
                                        pilots: starship.1["pilots"].array ?? [],
                                        films: starship.1["films"].array ?? [],
                                        created: starship.1["created"].string ?? "",
                                        edited: starship.1["edited"].string ?? "",
                                        heperdriveRating: starship.1["heperdriveRating"].string ?? "",
                                        mglt: starship.1["mglt"].string ?? "",
                                        starshipClass: starship.1["starship_class"].string ?? "")
                }
            }
            viewController?.cachStarships(viewModel: LaunchScreen.Fetch.ViewModel.Starships(starships: dict))
        } catch let error {
            print("Error parsing starships: ", error)
        }
    }

    func cachVehicles(response: LaunchScreen.Fetch.Response.Vehicles) {
        var dict: Dictionary<Int, Vehicle> = [Int: Vehicle]()
        do {
            for vehicleData in response.vehicles {
                if vehicleData == nil  { continue }
                
                let json = try JSON(data: vehicleData!)
                for vehicle in json["results"] {
                    let id = Int(vehicle.1["url"].string!.components(separatedBy: "/")[5])!
                    dict[id] = Starship(name: vehicle.1["name"].string ?? "",
                                        model: vehicle.1["model"].string ?? "",
                                        manufacturer: vehicle.1["manufacturer"].string ?? "",
                                        costInCredits: vehicle.1["cost_in_credits"].string ?? "",
                                        length: vehicle.1["length"].string ?? "",
                                        maxAtmospheringSpeed: vehicle.1["max_atmosphering_speed"].string ?? "",
                                        crew: vehicle.1["crew"].string ?? "",
                                        passenger: vehicle.1["passenger"].string ?? "",
                                        cargoCapacity: vehicle.1["cargo_capacity"].string ?? "",
                                        consumables: vehicle.1["consumables"].string ?? "",
                                        vehicleClass: vehicle.1["vehicle_class"].string ?? "",
                                        pilots: vehicle.1["pilots"].array ?? [],
                                        films: vehicle.1["films"].array ?? [],
                                        created: vehicle.1["created"].string ?? "",
                                        edited: vehicle.1["edited"].string ?? "",
                                        heperdriveRating: nil,
                                        mglt: nil,
                                        starshipClass: nil)
                }
            }
            viewController?.cachVehicles(viewModel: LaunchScreen.Fetch.ViewModel.Vehicles(vehicles: dict))
        } catch let error {
            print("Error parsing vehicles: ", error)
        }
    }
}
