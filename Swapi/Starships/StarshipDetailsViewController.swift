//
//  StarshipDetailsViewController.swift
//  Swapi
//
//  Created by TuyenLe on 7/30/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import UIKit

// MARK: Extension

extension StarshipDetailsViewController: DetailScrollViewProtocol {
    var imageScrollView: UIScrollView {
        return starshipImageScrollView
    }

    var pageIndex: Int {
        get {
            return starshipIndex ?? 0
        }
        set {
            starshipIndex = newValue
        }
    }
}

extension StarshipDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == starshipImageScrollView {
            if viewModel?.previousImageViewContentOffset.x ?? 0 > scrollView.contentOffset.x {
                starshipScrollViewLeftArrowAction()
            } else if viewModel?.previousImageViewContentOffset.x ?? 0 < scrollView.contentOffset.x {
                starshipScrollViewRightArrowAction()
            }
        }
    }
}

extension StarshipDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filmCollection {
            return viewModel?.films.count ?? 0
        } else if collectionView == pilotCollection {
            return viewModel?.pilots.count ?? 0
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filmCollection, let filmCell = collectionView.dequeueReusableCell(withReuseIdentifier: "filmCell", for: indexPath) as? FilmCell {

            filmCell.name = viewModel?.films[indexPath.row]
            return filmCell
        } else if collectionView == pilotCollection, let pilotCell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as? CharacterCell {

            pilotCell.name = viewModel?.pilots[indexPath.row]
            return pilotCell
        }

        return UICollectionViewCell()
    }
}

extension StarshipDetailsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        if collectionView == filmCollection {
            label.text = viewModel?.films[indexPath.row]
        } else if collectionView == pilotCollection {
            label.text = viewModel?.pilots[indexPath.row]
        }

        return CGSize(width: label.intrinsicContentSize.width + 24, height: label.intrinsicContentSize.height) // add 24 to make space for right arrow indicator
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filmCollection {
            Router.routeTo(from: self, to: .FilmDetails, page: indexPath.row, entityName: viewModel?.films)
        } else if collectionView == pilotCollection {
            Router.routeTo(from: self, to: .CharacterDetails, page: indexPath.row, entityName: viewModel?.pilots)
        }
    }
}


extension StarshipDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let starshipCell = tableView.dequeueReusableCell(withIdentifier: "starshipInformation", for: indexPath)

        if indexPath.row == 0 {
            starshipCell.textLabel?.text = "Class"
            starshipCell.detailTextLabel?.text = starshipData?.starshipClass
        } else if indexPath.row == 1 {
            starshipCell.textLabel?.text = "Model"
            starshipCell.detailTextLabel?.text = starshipData?.model
        } else if indexPath.row == 2 {
            starshipCell.textLabel?.text = "Manufacturer"
            starshipCell.detailTextLabel?.text = starshipData?.manufacturer
        } else if indexPath.row == 3 {
            starshipCell.textLabel?.text = "Cost in credits"
            starshipCell.detailTextLabel?.text = starshipData?.costInCredits
        } else if indexPath.row == 4 {
            starshipCell.textLabel?.text = "Length"
            starshipCell.detailTextLabel?.text = starshipData?.length
        } else if indexPath.row == 5 {
            starshipCell.textLabel?.text = "Max atmosphering speed"
            starshipCell.detailTextLabel?.text = starshipData?.maxAtmospheringSpeed
        } else if indexPath.row == 6 {
            starshipCell.textLabel?.text = "Crew"
            starshipCell.detailTextLabel?.text = starshipData?.crew
        } else if indexPath.row == 7 {
            starshipCell.textLabel?.text = "Passenger"
            starshipCell.detailTextLabel?.text = starshipData?.passenger
        } else if indexPath.row == 8 {
            starshipCell.textLabel?.text = "Cargo capacity"
            starshipCell.detailTextLabel?.text = starshipData?.cargoCapacity
        } else if indexPath.row == 9 {
            starshipCell.textLabel?.text = "Consumable"
            starshipCell.detailTextLabel?.text = starshipData?.consumables
        } else if indexPath.row == 10 {
            starshipCell.textLabel?.text = "Hyperdrive rating"
            starshipCell.detailTextLabel?.text = starshipData?.heperdriveRating
        } else if indexPath.row == 11 {
            starshipCell.textLabel?.text = "MGLT"
            starshipCell.detailTextLabel?.text = starshipData?.mglt
        }

        return starshipCell
    }
    

}

// MARK: Main class

class StarshipDetailsViewModel: ViewModel {
    weak var starshipDetailsVC: StarshipDetailsViewController?

    var films: [String] {
        let starshipDatas = starshipDetailsVC?.starshipData
        var result: [String] = []
        for film in starshipDatas?.films ?? [] {
            let id = Int(film.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.films?[id]?.title ?? "")
        }
        return result
    }

    var pilots: [String] {
        let starshipDatas = starshipDetailsVC?.starshipData
        var result: [String] = []
        for pilot in starshipDatas?.pilots ?? [] {
            let id = Int(pilot.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.characters?[id]?.name ?? "")
        }
        return result
    }
    
    init(starshipDetailsVC: StarshipDetailsViewController) {
        super.init(detailScrollViewProtocol: starshipDetailsVC)
        self.starshipDetailsVC = starshipDetailsVC
    }
    
    override func scrollViewSetup() {
        super.scrollViewSetup()
        if let vc = starshipDetailsVC {
            vc.imageScrollView.contentSize.width = vc.imageScrollView.frame.width * 37
        }
    }
    
    func reloadAllTableAndCollection() {
        guard let vc = starshipDetailsVC else { return }
        vc.starshipInformation.reloadSections(IndexSet(integer: 0), with: .automatic)
        vc.filmCollection.reloadSections(IndexSet(integer: 0))
        vc.pilotCollection.reloadSections(IndexSet(integer: 0))
    }
    
    override func set(direction: ViewModel.PageDirection) {
        super.set(direction: direction)
        guard let vc = starshipDetailsVC else { return }
        vc.presentDetails()
    }
}

class StarshipDetailsViewController: UIViewController {

    // MARK: Views

    @IBOutlet weak var starshipUIImageView: UIImageView!

    @IBOutlet weak var starshipMainScrollView: UIView!

    @IBOutlet weak var pilotCollection: UICollectionView!

    @IBOutlet weak var filmCollection: UICollectionView!

    @IBOutlet weak var starshipImageScrollView: UIScrollView!

    @IBOutlet weak var starshipInformation: UITableView!

    // MARK: Control logic

    var starshipData: Starship?

    private var starshipIndex: Int?

    var viewModel: StarshipDetailsViewModel?

    var starshipNames: [String]?

    // MARK: Functionalities

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = StarshipDetailsViewModel(starshipDetailsVC: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let backItem = UIBarButtonItem()
        backItem.title = title
        navigationItem.backBarButtonItem = backItem
    }

    override func viewDidLayoutSubviews() {
        if UIDevice.current.orientation.isLandscape {
            starshipMainScrollView.constraintWithIdentifier("starshipScrollViewBottom")?.constant = 600
        } else if UIDevice.current.orientation.isPortrait {
            starshipMainScrollView.constraintWithIdentifier("starshipScrollViewBottom")?.constant = 300
        }

        if let viewModel = self.viewModel {
            viewModel.scrollViewSetup()
            presentDetails()
        }
    }

    func presentDetails() {
        if let starshipNames = starshipNames {
            for starship in Array(LocalCache.starships?.values ?? Dictionary<Int, Starship>().values) {
                if starship.name == starshipNames[pageIndex] {
                    starshipData = starship
                    break
                }
            }
        } else {
            starshipData = Array(LocalCache.starships?.values ?? Dictionary<Int, Starship>().values)[pageIndex]
        }
        title = starshipData?.name
        starshipUIImageView.image = UIImage(named: "Starships/\(title ?? "")")

        if viewModel?.previousImageViewContentOffset.x != 0.0 {
            imageScrollView.constraintWithIdentifier("starshipUIImageViewCenterX")?.constant = viewModel?.previousImageViewContentOffset.x ?? 0
        } else {
            imageScrollView.constraintWithIdentifier("starshipUIImageViewCenterX")?.constant = 1
        }
    }

    @IBAction func starshipScrollViewLeftArrowAction() {
        if pageIndex > 0 {
            viewModel?.set(direction: .left)
            viewModel?.reloadAllTableAndCollection()
        }
    }

    @IBAction func starshipScrollViewRightArrowAction() {
        let totalPage = starshipNames == nil ? LocalCache.species?.count ?? 0 : starshipNames?.count ?? 0
        if pageIndex < totalPage - 1 {
            viewModel?.set(direction: .right)
            viewModel?.reloadAllTableAndCollection()
        }
    }
}
