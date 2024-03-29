//
//  CharacterDetails.swift
//  Swapi
//
//  Created by TuyenLe on 7/30/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import Foundation

// MARK: Extension

extension CharacterDetailsViewController: DetailScrollViewProtocol {
    var imageScrollView: UIScrollView {
        return charactersImageScrollView
    }

    var pageIndex: Int {
        get {
            return characterIndex ?? 0
        }
        set {
            characterIndex = newValue
        }
    }
}

extension CharacterDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filmsCollection {
            return viewModel?.films.count ?? 0
        } else if collectionView == vehicleCollection {
            return viewModel?.vehicles.count ?? 0
        } else if collectionView == starshipCollection {
            return viewModel?.starships.count ?? 0
        }
        return viewModel?.species.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filmsCollection,
            let filmCell = collectionView.dequeueReusableCell(withReuseIdentifier: "filmCell", for: indexPath) as? FilmCell {

            filmCell.name = viewModel?.films[indexPath.row]
            filmCell.showMoreIndicator = filmCell.showMoreIndicator ?? true
            return filmCell
        } else if collectionView == specieCollection,
            let specieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "specieCell", for: indexPath) as? SpecieCell {

            specieCell.name = viewModel?.species[indexPath.row]
            specieCell.showMoreIndicator = specieCell.showMoreIndicator ?? true
            return specieCell
        } else if collectionView == vehicleCollection,
            let vehicleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "vehicleCell", for: indexPath) as? VehicleCell {

            vehicleCell.name = viewModel?.vehicles[indexPath.row]
            vehicleCell.showMoreIndicator = vehicleCell.showMoreIndicator ?? true
            return vehicleCell
        } else if collectionView == starshipCollection,
            let starshipCell = collectionView.dequeueReusableCell(withReuseIdentifier: "starshipCell", for: indexPath) as? StarshipCell {

            starshipCell.name = viewModel?.starships[indexPath.row]
            starshipCell.showMoreIndicator = starshipCell.showMoreIndicator ?? true
            return starshipCell
        }

        return UICollectionViewCell()
    }
}

extension CharacterDetailsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        if collectionView == filmsCollection {
            label.text = viewModel?.films[indexPath.row]
        } else if collectionView == vehicleCollection {
            label.text = viewModel?.vehicles[indexPath.row]
        } else if collectionView == starshipCollection {
            label.text = viewModel?.starships[indexPath.row]
        } else {
            label.text = viewModel?.species[indexPath.row]
        }

        return CGSize(width: label.intrinsicContentSize.width + 24, height: label.intrinsicContentSize.height) // add 24 to make space for right arrow indicator
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filmsCollection {
            Router.routeTo(from: self, to: .filmDetails, page: indexPath.row, entityName: viewModel?.films)
        } else if collectionView == specieCollection {
            Router.routeTo(from: self, to: .specieDetails, page: indexPath.row, entityName: viewModel?.species)
        } else if collectionView == starshipCollection {
            Router.routeTo(from: self, to: .starshipDetails, page: indexPath.row, entityName: viewModel?.starships)
        } else if collectionView == vehicleCollection {
            Router.routeTo(from: self, to: .vehicleDetails, page: indexPath.row, entityName: viewModel?.vehicles)
        }
    }
}

extension CharacterDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "attribute", for: indexPath)
        cell.accessoryType = .none
        if indexPath.row == 0 {
            cell.textLabel?.text = "Height"
            cell.detailTextLabel?.text = viewModel?.height
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "Mass"
            cell.detailTextLabel?.text = viewModel?.mass
        } else if indexPath.row == 2 {
            cell.textLabel?.text = "Hair color"
            cell.detailTextLabel?.text = characterData?.hairColor
        } else if indexPath.row == 3 {
            cell.textLabel?.text = "Skin color"
            cell.detailTextLabel?.text = characterData?.skinColor
        } else if indexPath.row == 4 {
            cell.textLabel?.text = "Eye color"
            cell.detailTextLabel?.text = characterData?.eyeColor
        } else if indexPath.row == 5 {
            cell.textLabel?.text = "Birth year"
            cell.detailTextLabel?.text = characterData?.birthYear
        } else if indexPath.row == 6 {
            cell.textLabel?.text = "Gender"
            cell.detailTextLabel?.text = characterData?.gender
        } else if indexPath.row == 7 {
            cell.detailTextLabel?.text = viewModel?.homeworld
            cell.isUserInteractionEnabled = viewModel?.homeworld == "unknown" ? false : true
            cell.textLabel?.text = "Homeworld"
            cell.accessoryType = viewModel?.homeworld == "unknown" ? .none : .disclosureIndicator
            return cell
        }
        return cell
    }
}

extension CharacterDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == attributeCollection && indexPath.row == 7 {
            Router.routeTo(from: self, to: .planetDetails, page: 0, entityName: [viewModel?.homeworld ?? ""])
        }
    }
}

extension CharacterDetailsViewController: UIScrollViewDelegate {
    var endOfScrollViewContentOffsetX: CGFloat {
        let characterCount = characterNames?.count ?? (LocalCache.characters?.count ?? 1)

        return (viewModel?.imageScrollViewWidth ?? 0) * CGFloat(characterCount - 1)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == charactersImageScrollView {
            if viewModel?.previousImageScrollViewContentOffset.x ?? 0 > scrollView.contentOffset.x {
                characterScrollViewLeftArrowAction()
            } else if viewModel?.previousImageScrollViewContentOffset.x ?? 0 < scrollView.contentOffset.x {
                characterScrollViewRightArrowAction()
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

// Main class

/**
 ViewModel responsible for parsing and manipulate
 data from LocalCache
 **/

class CharacterDetailsViewModel: ViewModel {

    weak var characterDetailsVC: CharacterDetailsViewController?

    // MARK: data manipulation

    var height: String {
        let characterDatas = characterDetailsVC?.characterData
        let meter = characterDatas?.height == "unknown" ? "" : "meter"
        return "\(characterDatas?.height ?? String(0)) \(meter)"
    }

    var mass: String {
        let characterDatas = characterDetailsVC?.characterData
        let kg = characterDatas?.mass == "unknown" ? "" : "kg"
        return "\(characterDatas?.mass ?? String(0)) \(kg)"
    }

    var homeworld: String {
        let characterDatas = characterDetailsVC?.characterData

        let id = Int(characterDatas!.homeworld.components(separatedBy: "/")[5])!
        return LocalCache.planets?[id]?.name ?? ""
    }

    var films: [String] {
        let characterDatas = characterDetailsVC?.characterData
        var result: [String] = []

        for film in characterDatas?.films ?? [] {
            let id = Int(film.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.films?[id]?.title ?? "")
        }

        return result
    }

    var vehicles: [String] {
        let characterDatas = characterDetailsVC?.characterData
        var result: [String] = []

        for vehicle in characterDatas?.vehicles ?? [] {
            let id = Int(vehicle.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.vehicles?[id]?.name ?? "")
        }
        return result
    }

    var starships: [String] {
        let characterDatas = characterDetailsVC?.characterData
        var result: [String] = []

        for starship in characterDatas?.starships ?? [] {
            let id = Int(starship.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.starships?[id]?.name ?? "")
        }

        return result
    }

    var species: [String] {
        let characterDatas = characterDetailsVC?.characterData
        var result: [String] = []

        for specie in characterDatas?.species ?? [] {
            let id = Int(specie.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.species?[id]?.name ?? "")
        }

        return result
    }

    // MARK: initialization

    init(characterDetailsVC: CharacterDetailsViewController) {
        super.init(detailScrollViewProtocol: characterDetailsVC)
        self.characterDetailsVC = characterDetailsVC
    }

    // MARK: view logic

    override func set(direction: ViewModel.PageDirection) {
        super.set(direction: direction)

        if let vc = characterDetailsVC {
            vc.presentDetails()
        }
    }

    override func scrollViewSetup() {
        super.scrollViewSetup()
        if let vc = characterDetailsVC {
            vc.imageScrollView.contentSize.width = vc.imageScrollView.frame.width * 87
        }
    }

    func reloadAllTableAndCollection() {
        guard let vc = characterDetailsVC else { return }
        vc.filmsCollection.reloadSections(IndexSet(integer: 0))
        vc.specieCollection.reloadSections(IndexSet(integer: 0))
        vc.vehicleCollection.reloadSections(IndexSet(integer: 0))
        vc.starshipCollection.reloadSections(IndexSet(integer: 0))
        vc.attributeCollection.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}

/**
 Detail View Controller instantiate inside Router.routTo function
 from storyboard view controller's identifier. The design pattern
 is Model-ViewModel-Controller in order to keep the main view controller
 substantially small
 **/
class CharacterDetailsViewController: UIViewController {

    // MARK: view properties

    @IBOutlet weak var characterMainScrollView: UIScrollView!

    @IBOutlet weak var vehicleCollection: UICollectionView!

    @IBOutlet weak var attributeCollection: UITableView!

    @IBOutlet weak var starshipCollection: UICollectionView!

    @IBOutlet weak var specieCollection: UICollectionView!

    @IBOutlet weak var filmsCollection: UICollectionView!

    @IBOutlet weak var charactersImageScrollView: UIScrollView!

    @IBOutlet weak var characterUIImageView: UIImageView!

    // MARK: control logic

    var characterData: Character?

    var viewModel: CharacterDetailsViewModel?

    var characterNames: [String]?

    private var characterIndex: Int?

    // MARK: initial setup

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CharacterDetailsViewModel(characterDetailsVC: self)
        if let viewModel = self.viewModel {
            viewModel.scrollViewSetup()
            presentDetails()
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        viewModel?.imageScrollViewWidth = size.width
        imageScrollView.setContentOffset(imageScrollView.contentOffset, animated: true)
        viewModel?.setPreviousImageViewContentOffset(with: imageScrollView.contentOffset)
        viewModel?.setUIImageViewCenterXContraint(identifier: "characterUIImageViewCenterX", constant: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backItem = UIBarButtonItem()
        backItem.title = title
        backItem.tintColor = .yellow
        navigationItem.backBarButtonItem = backItem
        imageScrollView.setContentOffset(.zero, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageScrollView.setContentOffset(viewModel?.previousImageScrollViewContentOffset ?? .zero, animated: true)
    }

    override func viewDidLayoutSubviews() {
        characterMainScrollView.contentSize.height = 1000
    }

    func presentDetails() {
        if let characterNames = characterNames {
            for character in Array(LocalCache.characters?.values ?? [Int: Character]().values) where character.name == characterNames[pageIndex] {
                characterData = character
                break
            }
        } else {
            characterData = Array(LocalCache.characters?.values ?? [Int: Character]().values)[pageIndex]
        }
        title = characterData?.name
        characterUIImageView.image = UIImage(named: "Characters/\(title ?? "")")
        viewModel?.setUIImageViewCenterXContraint(identifier: "characterUIImageViewCenterX", constant: nil)
    }

    // MARK: Character scroll view logic

    func characterScrollViewRightArrowAction() {
        let totalPage = characterNames == nil ? LocalCache.characters?.count ?? 0 : characterNames?.count ?? 0
        if pageIndex < totalPage - 1 {
            viewModel?.set(direction: .right)
            viewModel?.reloadAllTableAndCollection()
        }
    }

    func characterScrollViewLeftArrowAction() {
        if pageIndex > 0 {
            viewModel?.set(direction: .left)
            viewModel?.reloadAllTableAndCollection()
        }
    }
}
