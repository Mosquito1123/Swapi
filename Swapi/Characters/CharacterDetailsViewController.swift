//
//  CharacterDetails.swift
//  Swapi
//
//  Created by TuyenLe on 7/30/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import Foundation

struct CharacterDetailsViewModel {
    weak var characterDetailsVC: CharacterDetailsViewController?
    
    var homeWorlds: [String] {
        let characterDatas = characterDetailsVC?.routeCharacterData
        var result: [String] = []

        for homeWorld in characterDatas?.homeworld ?? [] {
            let id = Int(homeWorld.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.characters?[id]?.name ?? "")
        }
        return result
    }
    
    var films: [String] {
        let characterDatas = characterDetailsVC?.routeCharacterData
        var result: [String] = []

        for film in characterDatas?.films ?? [] {
            let id = Int(film.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.films?[id]?.title ?? "")
        }
        
        return result
    }
    
    var vehicles: [String] {
        let characterDatas = characterDetailsVC?.routeCharacterData
        var result: [String] = []

        for vehicle in characterDatas?.vehicles ?? [] {
            let id = Int(vehicle.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.vehicles?[id]?.name ?? "")
        }
        return result
    }
    
    var starships: [String] {
        let characterDatas = characterDetailsVC?.routeCharacterData
        var result: [String] = []
        
        for starship in characterDatas?.starships ?? [] {
            let id = Int(starship.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.starships?[id]?.name ?? "")
        }

        return result
    }
}

class CharacterDetailsViewController: UIViewController {
    var routeCharacterData: People?
    
    var viewModel: CharacterDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = routeCharacterData?.name
        
        viewModel = CharacterDetailsViewModel(characterDetailsVC: self)
        
        presentDetails()
    }
    
    func presentDetails() {
        // TODO: present details to UIView
    }
}
