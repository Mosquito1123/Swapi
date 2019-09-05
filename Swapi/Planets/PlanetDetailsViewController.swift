//
//  PlanetDetailsViewController.swift
//  Swapi
//
//  Created by TuyenLe on 7/30/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import Foundation

// MARK: Extension

extension PlanetDetailsViewController: DetailScrollViewProtocol {
    var imageScrollView: UIScrollView {
        return planetsImageScrollView
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
    var endOfScrollViewContentOffsetX: CGFloat {
        let planetCount = planetNames?.count ?? (LocalCache.planets?.count ?? 1)
        
        return (viewModel?.scrollImageContentOffsetX ?? 0) * CGFloat(planetCount - 1)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == planetsImageScrollView {
            if viewModel?.previousImageViewContentOffset.x ?? 0 > scrollView.contentOffset.x {
                planetScrollViewLeftArrowAction()
            } else if viewModel?.previousImageViewContentOffset.x ?? 0 < scrollView.contentOffset.x {
                planetScrollViewRightArrowAction()
            }
        }
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        // prevent user scroll past the end of scroll view
        if scrollView.contentOffset.x > endOfScrollViewContentOffsetX {
            var visibleRect = scrollView.frame
            visibleRect.origin.x = endOfScrollViewContentOffsetX
            scrollView.scrollRectToVisible(visibleRect, animated: true)
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
            planetCell.textLabel?.text = "Gravity"
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

extension PlanetDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filmCollection {
            return viewModel?.films.count ?? 0
        } else if collectionView == inhabitantCollection {
            return viewModel?.inhabitants.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filmCollection, let filmCell = collectionView.dequeueReusableCell(withReuseIdentifier: "filmCell", for: indexPath) as? FilmCell {
            filmCell.name = viewModel?.films[indexPath.row]
            return filmCell
        } else if collectionView == inhabitantCollection, let inhabitantCell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as? CharacterCell {
            inhabitantCell.name = viewModel?.inhabitants[indexPath.row]
            return inhabitantCell
        }
        
        return UICollectionViewCell()
    }
}

extension PlanetDetailsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        if collectionView == filmCollection {
            label.text = viewModel?.films[indexPath.row]
        } else if collectionView == inhabitantCollection {
            label.text = viewModel?.inhabitants[indexPath.row]
        }

        return CGSize(width: label.intrinsicContentSize.width + 24, height: label.intrinsicContentSize.height) // add 24 to make space for right arrow indicator
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filmCollection {
            Router.routeTo(from: self, to: .FilmDetails, page: indexPath.row, entityName: viewModel?.films)
        } else if collectionView == inhabitantCollection {
            Router.routeTo(from: self, to: .CharacterDetails, page: indexPath.row, entityName: viewModel?.inhabitants)
        }
    }
}

// MARK: Main class

/**
 ViewModel responsible for parsing and manipulate
 data from LocalCache
 **/
class PlanetDetailsViewModel: ViewModel {
    weak var planetDetailsVC: PlanetDetailsViewController?

    var inhabitants: [String] {
        let planetDatas = planetDetailsVC?.planetData
        var result: [String] = []

        for inhabitant in planetDatas?.residents ?? [] {
            let id = Int(inhabitant.string!.components(separatedBy: "/")[5])!
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
            vc.presentDetails()
        }
    }

    override func scrollViewSetup() {
        super.scrollViewSetup()
        if let vc = planetDetailsVC {
            vc.imageScrollView.contentSize.width = vc.imageScrollView.frame.width * 61
        }
    }

    func reloadAllTableAndCollection() {
        guard let vc = planetDetailsVC else { return }
        vc.planetInformation.reloadSections(IndexSet(integer: 0), with: .automatic)
        vc.filmCollection.reloadSections(IndexSet(integer: 0))
        vc.inhabitantCollection.reloadSections(IndexSet(integer: 0))
    }
}

/**
 Detail View Controller instantiate inside Router.routTo function
 from storyboard view controller's identifier. The design pattern
 is Model-ViewModel-Controller in order to keep the main view controller
 substantially small
 **/
class PlanetDetailsViewController: UIViewController {

    // MARK: View properties

    @IBOutlet weak var filmCollection: UICollectionView!

    @IBOutlet weak var planetsImageScrollView: UIScrollView!

    @IBOutlet weak var planetInformation: UITableView!

    @IBOutlet weak var inhabitantCollection: UICollectionView!

    @IBOutlet weak var planetUIImageView: UIImageView!
    // MARK: Control logic

    var planetData: Planet?

    var viewModel: PlanetDetailsViewModel?

    private var planetIndex: Int?

    var planetNames: [String]?

    // MARK: Functionalities

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PlanetDetailsViewModel(planetDetailsVC: self)
    }
    
    override func viewDidLayoutSubviews() {
        if let viewModel = self.viewModel {
            viewModel.scrollViewSetup()
            presentDetails()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let backItem = UIBarButtonItem()
        backItem.title = title
        backItem.tintColor = .yellow
        navigationItem.backBarButtonItem = backItem
    }

    func presentDetails() {
        if let planetNames = planetNames {
            for planet in Array(LocalCache.planets?.values ?? Dictionary<Int, Planet>().values) {
                if planet.name == planetNames[pageIndex] {
                    planetData = planet
                    break
                }
            }
        } else {
            planetData = Array(LocalCache.planets?.values ?? Dictionary<Int, Planet>().values)[pageIndex]
        }
        title = planetData?.name
        planetUIImageView.image = UIImage(named: "Planets/\(title ?? "")")
        
        if viewModel?.previousImageViewContentOffset.x != 0.0 {
            imageScrollView.constraintWithIdentifier("planetUIImageViewCenterX")?.constant = viewModel?.previousImageViewContentOffset.x ?? 0
        } else {
            imageScrollView.constraintWithIdentifier("planetUIImageViewCenterX")?.constant = 1
        }
    }

    @IBAction func planetScrollViewLeftArrowAction() {
        if pageIndex > 0 {
            viewModel?.set(direction: .left)
            viewModel?.reloadAllTableAndCollection()
        }
    }

    @IBAction func planetScrollViewRightArrowAction() {
        let totalPage = planetNames == nil ? LocalCache.planets?.count ?? 0 : planetNames?.count ?? 0
        if pageIndex < totalPage - 1 {
            viewModel?.set(direction: .right)
            viewModel?.reloadAllTableAndCollection()
        }
    }
}
