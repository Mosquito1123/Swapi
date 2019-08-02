//
//  FilmDetails.swift
//  Swapi
//
//  Created by TuyenLe on 7/30/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import Foundation

struct FilmDetailsViewModel {
    weak var filmDetailsVC: FilmDetailsViewController?

    var characters: [String] {
        let filmDatas = filmDetailsVC?.routeFilmData
        var result: [String] = []

        for character in filmDatas?.characters ?? [] {
            let id = Int(character.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.characters?[id]?.name ?? "")
        }
        return result
    }

    var planets: [String] {
        let filmDatas = filmDetailsVC?.routeFilmData
        var result: [String] = []

        for planet in filmDatas?.planets ?? [] {
            let id = Int(planet.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.planets?[id]?.name ?? "")
        }
        return result
    }

    var starships: [String] {
        let filmDatas = filmDetailsVC?.routeFilmData
        var result: [String] = []

        for starship in filmDatas?.starships ?? [] {
            let id = Int(starship.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.starships?[id]?.name ?? "")
        }
        return result
    }

    var species: [String] {
        let filmDatas = filmDetailsVC?.routeFilmData
        var result: [String] = []

        for specie in filmDatas?.species ?? [] {
            let id = Int(specie.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.species?[id]?.name ?? "")
        }
        return result
    }
}

class FilmDetailsViewController: UIViewController {
    var routeFilmData: Film?

    var viewModel: FilmDetailsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = routeFilmData?.title
        viewModel = FilmDetailsViewModel(filmDetailsVC: self)
        
        presentDetails()
    }

    func presentDetails() {
        // TODO: present details to UIView
    }
}
