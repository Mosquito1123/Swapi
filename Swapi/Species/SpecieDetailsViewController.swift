//
//  SpecieDetailsViewController.swift
//  Swapi
//
//  Created by TuyenLe on 7/30/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import Foundation

struct SpecieDetailsViewModel {
    weak var specieDetailsVC: SpecieDetailsViewController?

    var homeWorlds: [String] {
        let specieDatas = specieDetailsVC?.routeSpecieData
        var result: [String] = []
        for homeWorld in specieDatas?.homeworld ?? [] {
            let id = Int(homeWorld.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.planets?[id]?.name ?? "")
        }
    
        return result
    }

    var characters: [String] {
        let specieDatas = specieDetailsVC?.routeSpecieData
        var result: [String] = []
        for character in specieDatas?.people ?? [] {
            let id = Int(character.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.characters?[id]?.name ?? "")
        }
    
        return result
    }

    var films: [String] {
        let specieDatas = specieDetailsVC?.routeSpecieData
        var result: [String] = []
        for film in specieDatas?.films ?? [] {
            let id = Int(film.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.films?[id]?.title ?? "")
        }
        return result
    }
}

class SpecieDetailsViewController: UIViewController {
    var routeSpecieData: Specie?

    var viewModel: SpecieDetailsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = routeSpecieData?.name
        viewModel = SpecieDetailsViewModel(specieDetailsVC: self)
    }

    func presentDetails() {
        // TODO: present details to UIView
    }
}
