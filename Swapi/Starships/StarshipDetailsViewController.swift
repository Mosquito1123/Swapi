//
//  StarshipDetailsViewController.swift
//  Swapi
//
//  Created by TuyenLe on 7/30/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import UIKit

struct StarshipDetailsViewModel {
    weak var starshipDetailsVC: StarshipDetailsViewController?
    
    var films: [String] {
        let starshipDatas = starshipDetailsVC?.routeStarshipData
        var result: [String] = []
        for film in starshipDatas?.films ?? [] {
            let id = Int(film.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.films?[id]?.title ?? "")
        }
        return result
    }
    
    var pilots: [String] {
        let starshipDatas = starshipDetailsVC?.routeStarshipData
        var result: [String] = []
        for pilot in starshipDatas?.pilots ?? [] {
            let id = Int(pilot.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.characters?[id]?.name ?? "")
        }
        return result
    }
}

class StarshipDetailsViewController: UIViewController {
    var routeStarshipData: Starship?
    
    var viewModel: StarshipDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = routeStarshipData?.name
        viewModel = StarshipDetailsViewModel(starshipDetailsVC: self)
        
    }
    
    func presentDetails() {
        // TODO: present details to UIView
    }
}
