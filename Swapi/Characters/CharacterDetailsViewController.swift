//
//  CharacterDetails.swift
//  Swapi
//
//  Created by TuyenLe on 7/30/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import Foundation

// Views

class Cell: UICollectionViewCell {
    var name: String? {
        didSet {
            guard let name = name else { return }
            label.text = name
        }
    }
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var viewMoreIndicator: UIButton = {
        let button = UIButton()
        let arrowRight = imageResize(image: UIImage(named: "arrowRight"), sizeChange: CGSize(width: 12, height: 12))
        button.setImage(arrowRight, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func setupLabel() {
        contentView.addSubview(label)
        label.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLabel()
        contentView.addSubview(viewMoreIndicator)
        viewMoreIndicator.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
}

class FilmCell: Cell {
   // leave this class empty on purpose just for the sake of readability for filmCollection
}

class SpecieCell: Cell {
    // leave this class empty on purpose just for the sake of readablility for specieCollection
}

class VehicleCell: Cell {
    // leave this class empty on purpose just for the sake of readablility for vehicleCollection
}

// Extension

extension CharacterDetailsViewController: DetailScrollViewProtocol {
    var mainScrollView: UIScrollView {
        get {
            return characterMainScrollView
        }
    }

    var imageScrollView: UIScrollView {
        get {
            return charactersImageScrollView
        }
    }

    var leftArrow: UIButton {
        get {
            return characterScrollViewLeftArrow
        }
    }

    var rightArrow: UIButton {
        get {
            return characterScrollViewRightArrow
        }
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
        }
        return viewModel?.species.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filmsCollection, let filmCell = collectionView.dequeueReusableCell(withReuseIdentifier: "filmCell", for: indexPath) as? FilmCell  {

            filmCell.name = viewModel?.films[indexPath.row]

            return filmCell
        } else if collectionView == specieCollection, let specieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "specieCell", for: indexPath) as? SpecieCell {

            specieCell.name = viewModel?.species[indexPath.row]

            return specieCell
        } else if collectionView == vehicleCollection, let vehicleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "vehicleCell", for: indexPath) as? VehicleCell {

            vehicleCell.name = viewModel?.vehicles[indexPath.row]

            return vehicleCell
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
        } else {
            label.text = viewModel?.species[indexPath.row]
        }

        return CGSize(width: label.intrinsicContentSize.width + 24, height: label.intrinsicContentSize.height) // add 24 to make space for right arrow indicator
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: tap to take to film detail screen
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
        let rightAccesory = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))

        rightAccesory.textAlignment = .right
        cell.accessoryType = .none

        if indexPath.row == 0 {
            cell.textLabel?.text = "height"
            cell.detailTextLabel?.text = viewModel?.height
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "mass"
            cell.detailTextLabel?.text = viewModel?.mass
        } else if indexPath.row == 2 {
            cell.textLabel?.text = "hair color"
            cell.detailTextLabel?.text = characterData?.hairColor
        } else if indexPath.row == 3 {
            cell.textLabel?.text = "skin color"
            cell.detailTextLabel?.text = characterData?.skinColor
        } else if indexPath.row == 4 {
            cell.textLabel?.text = "eye color"
            cell.detailTextLabel?.text = characterData?.eyeColor
        } else if indexPath.row == 5 {
            cell.textLabel?.text = "birth year"
            cell.detailTextLabel?.text = characterData?.birthYear
        } else if indexPath.row == 6 {
            cell.textLabel?.text = "gender"
            cell.detailTextLabel?.text = characterData?.gender
        } else if indexPath.row == 7 {
            cell.detailTextLabel?.text = viewModel?.homeworld
            cell.isUserInteractionEnabled = viewModel?.homeworld == "unknown" ? false : true
            cell.textLabel?.text = "homeworld"
            cell.accessoryType = viewModel?.homeworld == "unknown" ? .none : .disclosureIndicator
            return cell
        }
        return cell
    }
}

// Main class

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
        super.init(detailScrollViewProtocol: characterDetailsVC, detailVC: characterDetailsVC)
        self.characterDetailsVC = characterDetailsVC
    }
    
    // MARK: view logic
    
    override func set(direction: ViewModel.PageDirection) {
        super.set(direction: direction)
        
        if let vc = characterDetailsVC {
            vc.characterData = Array(LocalCache.characters!.values)[vc.pageIndex]
            vc.title = vc.characterData?.name
        }
    }
    
    func reloadAllTableAndCollection() {
        guard let vc = characterDetailsVC else { return }
        vc.filmsCollection.reloadSections(IndexSet(integer: 0))
        vc.specieCollection.reloadSections(IndexSet(integer: 0))
        vc.attributeCollection.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}


class CharacterDetailsViewController: UIViewController {

    // MARK: view properties

    @IBOutlet weak var vehicleCollection: UICollectionView!

    @IBOutlet weak var specieCollection: UICollectionView!

    @IBOutlet weak var attributeCollection: UITableView!

    @IBOutlet weak var filmsLabel: UILabel!

    @IBOutlet weak var filmsCollection: UICollectionView!

    @IBOutlet weak var characterMainScrollView: UIScrollView!

    @IBOutlet weak var charactersImageScrollView: UIScrollView!

    @IBOutlet weak var characterScrollViewLeftArrow: UIButton!

    @IBOutlet weak var characterScrollViewRightArrow: UIButton!

    // MARK: control logic

    var characterData: People?

    var viewModel: CharacterDetailsViewModel?

    private var characterIndex: Int?

    // MARK: initial setup

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = CharacterDetailsViewModel(characterDetailsVC: self)

        if let index = characterIndex {
            characterData = Array(LocalCache.characters!.values)[index]
            title = characterData?.name
        }
        presentDetails()
    }

    func presentDetails() {
        viewModel?.scrollViewSetup()
    }

    // MARK: Character scroll view logic

    @IBAction func characterScrollViewRightArrowAction() {
        if pageIndex < 86  {
            viewModel?.set(direction: .right)
            viewModel?.reloadAllTableAndCollection()
        }
    }
    
    @IBAction func characterScrollViewLeftArrowAction() {
        if pageIndex > 0 {
            viewModel?.set(direction: .left)
            viewModel?.reloadAllTableAndCollection()
        }
    }
}

extension CharacterDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.accessibilityIdentifier == "characterDetailScrollView" {

            if viewModel?.previousImageViewContentOffset.x ?? 0 > scrollView.contentOffset.x {
                characterScrollViewLeftArrowAction()
            } else if viewModel?.previousImageViewContentOffset.x ?? 0 < scrollView.contentOffset.x {
                characterScrollViewRightArrowAction()
            }
            viewModel?.previousImageViewContentOffset = scrollView.contentOffset
            characterData = Array(LocalCache.characters!.values)[pageIndex]
            title = characterData?.name
            filmsCollection.reloadData()
        }
    }
}
