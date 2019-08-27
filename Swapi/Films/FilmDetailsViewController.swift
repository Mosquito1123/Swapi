//
//  FilmDetails.swift
//  Swapi
//
//  Created by TuyenLe on 7/30/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import Foundation

// MARK: Extension

extension FilmDetailsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        if collectionView == characterCollection {
            label.text = viewModel?.characters[indexPath.row]
        } else if collectionView == planetCollection {
            label.text = viewModel?.planets[indexPath.row]
        } else if collectionView == starshipCollection {
            label.text = viewModel?.starships[indexPath.row]
        } else if collectionView == vehicleCollection {
            label.text = viewModel?.vehicles[indexPath.row]
        } else if collectionView == specieCollection {
            label.text = viewModel?.species[indexPath.row]
        }

        return CGSize(width: label.intrinsicContentSize.width + 24, height: label.intrinsicContentSize.height) // add 24 to make space for right arrow indicator
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == characterCollection {
            Router.routeTo(from: self, to: .CharacterDetails, page: indexPath.row, entityName: viewModel?.characters)
        } else if collectionView == planetCollection {
            Router.routeTo(from: self, to: .PlanetDetails, page: indexPath.row, entityName: viewModel?.planets)
        } else if collectionView == specieCollection {
            Router.routeTo(from: self, to: .SpecieDetails, page: indexPath.row, entityName: viewModel?.species)
        } else if collectionView == starshipCollection {
            Router.routeTo(from: self, to: .StarshipDetails, page: indexPath.row, entityName: viewModel?.starships)
        }
    }
}

extension FilmDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == characterCollection {
            return viewModel?.characters.count ?? 0
        } else if collectionView == planetCollection {
            return viewModel?.planets.count ?? 0
        } else if collectionView == starshipCollection {
            return viewModel?.starships.count ?? 0
        } else if collectionView == vehicleCollection {
            return viewModel?.vehicles.count ?? 0
        } else if collectionView == specieCollection {
            return viewModel?.species.count ?? 0
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == characterCollection, let characterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as? CharacterCell {
            characterCell.name = viewModel?.characters[indexPath.row]
            return characterCell
        } else if collectionView == planetCollection, let planetCell = collectionView.dequeueReusableCell(withReuseIdentifier: "planetCell", for: indexPath) as? PlanetCell {
            planetCell.name = viewModel?.planets[indexPath.row]
            return planetCell
        } else if collectionView == starshipCollection, let starshipCell = collectionView.dequeueReusableCell(withReuseIdentifier: "starshipCell", for: indexPath) as? StarshipCell {
            starshipCell.name = viewModel?.starships[indexPath.row]
            return starshipCell
        } else if collectionView == vehicleCollection, let vehicleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "vehicleCell", for: indexPath) as? VehicleCell {
            vehicleCell.name = viewModel?.vehicles[indexPath.row]
            return vehicleCell
        } else if collectionView == specieCollection, let specieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "specieCell", for: indexPath) as? SpecieCell {
            specieCell.name = viewModel?.species[indexPath.row]
            return specieCell
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
    var imageScrollView: UIScrollView {
        return filmsImageScrollView
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

extension FilmDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filmCell = tableView.dequeueReusableCell(withIdentifier: "filmInformation", for: indexPath)
        if indexPath.row == 0 {
            filmCell.textLabel?.text = "Director"
            filmCell.detailTextLabel?.text = filmData?.director
        } else if indexPath.row == 1 {
            filmCell.textLabel?.text = "Producer"
            filmCell.detailTextLabel?.text = filmData?.producer
        } else if indexPath.row == 2 {
            filmCell.textLabel?.text = "Episode"
            filmCell.detailTextLabel?.text = "\(filmData!.episode)"
        } else if indexPath.row == 3 {
            filmCell.textLabel?.text = "Release Date"
            filmCell.detailTextLabel?.text = filmData?.releaseDate
        }
        return filmCell
    }
}

// Main class

/**
 ViewModel responsible for parsing and manipulate
 data from LocalCache
 **/
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

    var vehicles: [String] {
        let filmDatas = filmDetailsVC?.filmData
        var result: [String] = []
        
        for vehicle in filmDatas?.vehicles ?? [] {
            let id = Int(vehicle.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.vehicles?[id]?.name ?? "")
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
        super.init(detailScrollViewProtocol: filmDetailsVC)
        self.filmDetailsVC = filmDetailsVC
    }

    // MARK: view logic

    override func set(direction: ViewModel.PageDirection) {
        super.set(direction: direction)

        if let vc = filmDetailsVC {
            vc.presentDetails()
        }
    }

    override func scrollViewSetup() {
        super.scrollViewSetup()
        if let vc = filmDetailsVC {
            vc.imageScrollView.contentSize = CGSize(width: vc.imageScrollView.frame.width * 7, height: 0)
        }
    }

    func reloadAllTableAndCollection() {
        guard let vc = filmDetailsVC else { return }
        vc.characterCollection.reloadSections(IndexSet(integer: 0))
        vc.planetCollection.reloadSections(IndexSet(integer: 0))
        vc.starshipCollection.reloadSections(IndexSet(integer: 0))
        vc.vehicleCollection.reloadSections(IndexSet(integer: 0))
        vc.specieCollection.reloadSections(IndexSet(integer: 0))
        vc.filmInformationCollection.reloadSections(IndexSet(integer: 0), with: .automatic)
        vc.openingCrawl.text = vc.filmData?.openingCrawl
    }
}

/**
 Detail View Controller instantiate inside Router.routTo function
 from storyboard view controller's identifier. The design pattern
 is Model-ViewModel-Controller in order to keep the main view controller
 substantially small
 **/
class FilmDetailsViewController: UIViewController {

    // MARK: View properties

    @IBOutlet weak var filmMainScrollView: UIScrollView!

    @IBOutlet weak var filmsImageScrollView: UIScrollView!

    @IBOutlet weak var characterCollection: UICollectionView!

    @IBOutlet weak var planetCollection: UICollectionView!

    @IBOutlet weak var starshipCollection: UICollectionView!

    @IBOutlet weak var vehicleCollection: UICollectionView!

    @IBOutlet weak var specieCollection: UICollectionView!

    @IBOutlet weak var openingCrawl: UITextView!

    @IBOutlet weak var filmInformationCollection: UITableView!

    // MARK: Control logic

    var filmData: Film?

    var filmTitles: [String]?

    var viewModel: FilmDetailsViewModel?

    private var filmIndex: Int?

    // MARK: Functionalities

    override func viewDidLoad() {
        super.viewDidLoad()

        presentDetails()

        openingCrawl.text = filmData?.openingCrawl

        viewModel = FilmDetailsViewModel(filmDetailsVC: self)
        viewModel?.scrollViewSetup()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backItem = UIBarButtonItem()
        backItem.title = title
        navigationItem.backBarButtonItem = backItem
    }

    override func viewDidLayoutSubviews() {
        if UIDevice.current.orientation.isLandscape {
            filmMainScrollView.constraintWithIdentifier("filmMainScrollViewHeight")?.constant = 900
        } else if UIDevice.current.orientation.isPortrait {
            filmMainScrollView.constraintWithIdentifier("filmMainScrollViewHeight")?.constant = 600
        }
    }

    /// This function is call for initial setup and is called before reloading all tableview and collection
    func presentDetails() {
        if let filmTitles = filmTitles {
            for film in Array(LocalCache.films?.values ?? Dictionary<Int, Film>().values) {
                if film.title == filmTitles[pageIndex] {
                    filmData = film
                    break
                }
            }
        } else {
            filmData = Array(LocalCache.films?.values ?? Dictionary<Int, Film>().values)[pageIndex]
        }
        title = filmData?.title
    }

    @IBAction func filmScrollViewLeftArrowAction() {
        if pageIndex > 0 {
            viewModel?.set(direction: .left)
            viewModel?.reloadAllTableAndCollection()
        }
    }

    @IBAction func filmScrollViewRightArrowAction() {
        let totalPage = filmTitles == nil ? LocalCache.films?.count ?? 0 : filmTitles?.count ?? 0
        if pageIndex < totalPage - 1 {
            viewModel?.set(direction: .right)
            viewModel?.reloadAllTableAndCollection()
        }
    }
}
