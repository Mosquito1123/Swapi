//
//  PlanetDetailsViewController.swift
//  Swapi
//
//  Created by TuyenLe on 7/30/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import Foundation

struct PlanetDetailsViewModel {
    weak var planetDetailsVC: PlanetDetailsViewController?

    var residents: [String] {
        let planetDatas = planetDetailsVC?.routePlanetData
        var result: [String] = []

        for resident in planetDatas?.residents ?? [] {
            let id = Int(resident.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.characters?[id]?.name ?? "")
        }
        return result
    }

    var films: [String] {
        let planetDatas = planetDetailsVC?.routePlanetData
        var result: [String] = []

        for film in planetDatas?.films ?? [] {
            let id = Int(film.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.films?[id]?.title ?? "")
        }
        return result
    }
}

class PlanetDetailsViewController: UIViewController {
    var routePlanetData: Planet?

    var viewModel: PlanetDetailsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = routePlanetData?.name
        viewModel = PlanetDetailsViewModel(planetDetailsVC: self)
    }

    func presentDetails() {
        // TODO: present details to UIView
    }
}
