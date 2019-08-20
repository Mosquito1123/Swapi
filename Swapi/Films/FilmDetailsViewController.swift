//
//  FilmDetails.swift
//  Swapi
//
//  Created by TuyenLe on 7/30/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import Foundation

// Extension

extension FilmDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == filmsImageScrollView {
            if viewModel?.previousImageViewContentOffset.x ?? 0 > scrollView.contentOffset.x {
                filmScrollViewLeftArrowAction()
            } else if viewModel?.previousImageViewContentOffset.x ?? 0 < scrollView.contentOffset.x {
                filmScrollViewRightArrowAction()
            }
        }
    }
}

extension FilmDetailsViewController: DetailScrollViewProtocol {
    var mainScrollView: UIScrollView {
        return filmMainScrollView
    }
    
    var imageScrollView: UIScrollView {
        return filmsImageScrollView
    }
    
    var leftArrow: UIButton {
        return filmScrollViewLeftArrow
    }
    
    var rightArrow: UIButton {
        return filmScrollViewRightArrow
    }
    
    var pageIndex: Int {
        get {
            return filmIndex ?? 0
        }
        set {
            filmIndex = newValue
        }
    }
    
    
}

// Main class

class FilmDetailsViewModel: ViewModel {

    weak var filmDetailsVC: FilmDetailsViewController?

    var characters: [String] {
        let filmDatas = filmDetailsVC?.filmData
        var result: [String] = []

        for character in filmDatas?.characters ?? [] {
            let id = Int(character.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.characters?[id]?.name ?? "")
        }
        return result
    }

    var planets: [String] {
        let filmDatas = filmDetailsVC?.filmData
        var result: [String] = []

        for planet in filmDatas?.planets ?? [] {
            let id = Int(planet.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.planets?[id]?.name ?? "")
        }
        return result
    }

    var starships: [String] {
        let filmDatas = filmDetailsVC?.filmData
        var result: [String] = []

        for starship in filmDatas?.starships ?? [] {
            let id = Int(starship.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.starships?[id]?.name ?? "")
        }
        return result
    }

    var species: [String] {
        let filmDatas = filmDetailsVC?.filmData
        var result: [String] = []

        for specie in filmDatas?.species ?? [] {
            let id = Int(specie.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.species?[id]?.name ?? "")
        }
        return result
    }
    
    init(filmDetailsVC: FilmDetailsViewController) {
        super.init(detailScrollViewProtocol: filmDetailsVC, detailVC: filmDetailsVC)
        self.filmDetailsVC = filmDetailsVC
    }

    // MARK: view logic

    override func set(direction: ViewModel.PageDirection) {
        super.set(direction: direction)

        if let vc = filmDetailsVC {
            vc.filmData = Array(LocalCache.films?.values ?? Dictionary<Int, Film>().values)[vc.pageIndex]
            vc.title = vc.filmData?.title
        }
    }
}

class FilmDetailsViewController: UIViewController {

    @IBOutlet weak var filmMainScrollView: UIScrollView!

    @IBOutlet weak var filmScrollViewLeftArrow: UIButton!

    @IBOutlet weak var filmScrollViewRightArrow: UIButton!

    @IBOutlet weak var filmsImageScrollView: UIScrollView!

    var filmData: Film?

    var viewModel: FilmDetailsViewModel?

    private var filmIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = FilmDetailsViewModel(filmDetailsVC: self)

        if let index = filmIndex {
            filmData = Array(LocalCache.films?.values ?? Dictionary<Int, Film>().values)[index]
            title = filmData?.title
        }
        presentDetails()
    }

    func presentDetails() {
        viewModel?.scrollViewSetup()
    }

    @IBAction func filmScrollViewRightArrowAction() {
        if pageIndex < (LocalCache.films?.count ?? 0) - 1 {
            viewModel?.set(direction: .right)
        }
    }

    @IBAction func filmScrollViewLeftArrowAction() {
        if pageIndex > 0 {
            viewModel?.set(direction: .left)
        }
    }
}
