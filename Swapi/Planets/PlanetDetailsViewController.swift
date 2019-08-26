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

    }
}

class PlanetDetailsViewController: UIViewController {
    var planetData: Planet?

    @IBOutlet weak var planetMainScrollView: UIScrollView!

    @IBOutlet weak var planetScrollViewRightArrow: UIButton!

    @IBOutlet weak var planetScrollViewLeftArrow: UIButton!

    @IBOutlet weak var planetsImageScrollView: UIScrollView!

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
