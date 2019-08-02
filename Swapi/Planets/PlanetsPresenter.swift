//
//  PlanetsPresenter.swift
//  Swapi
//
//  Created by TuyenLe on 7/29/19.
//  Copyright (c) 2019 TuyenLe. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import SwiftyJSON

protocol PlanetsPresentationLogic
{
  func presentPlanets(response: Planets.Fetch.Response)
}

class PlanetsPresenter: PlanetsPresentationLogic
{
  weak var viewController: PlanetsDisplayLogic?
  
  // MARK: Do something
  
    func presentPlanets(response: Planets.Fetch.Response)
    {
        do {
            var planetArray: [Planet] = []
            
            for planetData in response.planets {
                if planetData == nil { continue }

                let json = try JSON(data: planetData!)
                for planet in json["results"] {
                    planetArray.append(Planet(name: planet.1["name"].string!,
                                              rotationPeriod: planet.1["rotation_period"].string!,
                                              orbitalPeriod: planet.1["orbital_period"].string!,
                                              diameter: planet.1["diameter"].string!,
                                              climate: planet.1["climate"].string!,
                                              gravity: planet.1["gravity"].string!,
                                              terrain: planet.1["terrain"].string!,
                                              surfaceWater: planet.1["surface_water"].string!,
                                              population: planet.1["population"].string!,
                                              residents: nil,
                                              films: nil,
                                              created: planet.1["created"].string!,
                                              edited: planet.1["edited"].string!))
                }
            }
            viewController?.displayPlanets(viewModel: Planets.Fetch.ViewModel(planets: planetArray))
        } catch let error {
            print("Error parsing planets: ", error)
        }
    }
}