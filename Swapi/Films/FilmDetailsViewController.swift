//
//  FilmDetails.swift
//  Swapi
//
//  Created by TuyenLe on 7/30/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import Foundation

// Views

class CharacterCell: Cell {

}

// Extension

extension FilmDetailsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        if collectionView == characterCollection {
            label.text = viewModel?.characters[indexPath.row]
        }

        return CGSize(width: label.intrinsicContentSize.width + 24, height: label.intrinsicContentSize.height) // add 24 to make space for right arrow indicator
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == characterCollection {
            let characterName = viewModel?.characters[indexPath.row]
            let characters = Array(LocalCache.characters?.values ?? Dictionary<Int, People>().values)
            for (index, character) in characters.enumerated() {
                if character.name == characterName {
                    Router.routeTo(from: self, to: .CharacterDetails, param: index)
                    break
                }
            }
        }
    }
}

extension FilmDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == characterCollection {
            return viewModel?.characters.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == characterCollection, let characterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as? CharacterCell {
            characterCell.name = viewModel?.characters[indexPath.row]
            return characterCell
        }
        return UICollectionViewCell()
    }
    
    
}

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
    
    func reloadAllTableAndCollection() {
        guard let vc = filmDetailsVC else { return }
        vc.characterCollection.reloadData()
    }
}

class FilmDetailsViewController: UIViewController {

    @IBOutlet weak var filmMainScrollView: UIScrollView!

    @IBOutlet weak var filmScrollViewLeftArrow: UIButton!

    @IBOutlet weak var filmScrollViewRightArrow: UIButton!

    @IBOutlet weak var filmsImageScrollView: UIScrollView!

    @IBOutlet weak var characterCollection: UICollectionView!

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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backItem = UIBarButtonItem()
        backItem.title = title
        navigationItem.backBarButtonItem = backItem
    }

    func presentDetails() {
        viewModel?.scrollViewSetup()
    }

    @IBAction func filmScrollViewRightArrowAction() {
        if pageIndex < (LocalCache.films?.count ?? 0) - 1 {
            viewModel?.set(direction: .right)
            viewModel?.reloadAllTableAndCollection()
        }
    }

    @IBAction func filmScrollViewLeftArrowAction() {
        if pageIndex > 0 {
            viewModel?.set(direction: .left)
            viewModel?.reloadAllTableAndCollection()
        }
    }
}
