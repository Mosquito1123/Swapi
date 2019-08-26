//
//  PlanetDetailsViewController.swift
//  Swapi
//
//  Created by TuyenLe on 7/30/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import Foundation

extension PlanetDetailsViewController: DetailScrollViewProtocol {
    var mainScrollView: UIScrollView {
        return planetMainScrollView
    }
    
    var imageScrollView: UIScrollView {
        return planetsImageScrollView
    }
    
    var leftArrow: UIButton {
        return planetScrollViewLeftArrow
    }
    
    var rightArrow: UIButton {
        return planetScrollViewRightArrow
    }
    
    var pageIndex: Int {
        get {
            return planetIndex ?? 0
        }
        set {
            planetIndex = newValue
        }
    }
}

extension PlanetDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == planetsImageScrollView {
            if viewModel?.previousImageViewContentOffset.x ?? 0 > scrollView.contentOffset.x {
                planetScrollViewLeftArrowAction()
            } else if viewModel?.previousImageViewContentOffset.x ?? 0 < scrollView.contentOffset.x {
                planetScrollViewRightArrowAction()
            }
        }
    }
}

extension PlanetDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let planetCell = tableView.dequeueReusableCell(withIdentifier: "planetInformation", for: indexPath)
        if indexPath.row == 0 {
            planetCell.textLabel?.text = "Rotation period"
            planetCell.detailTextLabel?.text = planetData?.rotationPeriod
        } else if indexPath.row == 1 {
            planetCell.textLabel?.text = "Orbital period"
            planetCell.detailTextLabel?.text = planetData?.orbitalPeriod
        } else if indexPath.row == 2 {
            planetCell.textLabel?.text = "Diameter"
            planetCell.detailTextLabel?.text = planetData?.diameter
        } else if indexPath.row == 3 {
            planetCell.textLabel?.text = "Climate"
            planetCell.detailTextLabel?.text = planetData?.climate
        } else if indexPath.row == 4 {
            planetCell.textLabel?.text = "Gravit"
            planetCell.detailTextLabel?.text = planetData?.gravity
        } else if indexPath.row == 5 {
            planetCell.textLabel?.text = "Terrain"
            planetCell.detailTextLabel?.text = planetData?.terrain
        } else if indexPath.row == 3 {
            planetCell.textLabel?.text = "Surface water"
            planetCell.detailTextLabel?.text = planetData?.surfaceWater
        } else if indexPath.row == 3 {
            planetCell.textLabel?.text = "Population"
            planetCell.detailTextLabel?.text = planetData?.population
        }

        return planetCell
    }
}

class PlanetDetailsViewModel: ViewModel {
    weak var planetDetailsVC: PlanetDetailsViewController?

    var residents: [String] {
        let planetDatas = planetDetailsVC?.planetData
        var result: [String] = []

        for resident in planetDatas?.residents ?? [] {
            let id = Int(resident.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.characters?[id]?.name ?? "")
        }
        return result
    }

    var films: [String] {
        let planetDatas = planetDetailsVC?.planetData
        var result: [String] = []

        for film in planetDatas?.films ?? [] {
            let id = Int(film.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.films?[id]?.title ?? "")
        }
        return result
    }

    init(planetDetailsVC: PlanetDetailsViewController) {
        super.init(detailScrollViewProtocol: planetDetailsVC)
        self.planetDetailsVC = planetDetailsVC
    }
    
    override func set(direction: ViewModel.PageDirection) {
        super.set(direction: direction)
        
        if let vc = planetDetailsVC {
            vc.planetData = Array(LocalCache.planets?.values ?? Dictionary<Int, Planet>().values)[vc.pageIndex]
            vc.title = vc.planetData?.name
        }
    }
    
    func reloadAllTableAndCollection() {
        guard let vc = planetDetailsVC else { return }
        vc.planetInformation.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}

class PlanetDetailsViewController: UIViewController {
    var planetData: Planet?

    @IBOutlet weak var planetMainScrollView: UIScrollView!

    @IBOutlet weak var planetScrollViewRightArrow: UIButton!

    @IBOutlet weak var planetScrollViewLeftArrow: UIButton!

    @IBOutlet weak var planetsImageScrollView: UIScrollView!

    @IBOutlet weak var planetInformation: UITableView!

    var viewModel: PlanetDetailsViewModel?

    private var planetIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        presentDetails()
    }

    func presentDetails() {
        if let index = planetIndex {
            planetData = Array(LocalCache.planets?.values ?? Dictionary<Int, Planet>().values)[index]
            title = planetData?.name
        }
        viewModel = PlanetDetailsViewModel(planetDetailsVC: self)
        viewModel?.scrollViewSetup()
    }

    @IBAction func planetScrollViewLeftArrowAction() {
        if pageIndex > 0 {
            viewModel?.set(direction: .left)
            viewModel?.reloadAllTableAndCollection()
        }
    }
    @IBAction func planetScrollViewRightArrowAction() {
        let totalPage = LocalCache.planets?.count ?? 0
        if pageIndex < totalPage - 1 {
            viewModel?.set(direction: .right)
            viewModel?.reloadAllTableAndCollection()
        }
    }
}
