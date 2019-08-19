//
//  CharacterDetails.swift
//  Swapi
//
//  Created by TuyenLe on 7/30/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import Foundation

// Views

class FilmCell: UICollectionViewCell {
    var name: String? {
        didSet {
            guard let name = name else { return }
            filmLabel.text = name
        }
    }

    private lazy var filmLabel: UILabel = {
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
    
    private func setupFilmLabel() {
        contentView.addSubview(filmLabel)
        filmLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        filmLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        filmLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        filmLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        filmLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFilmLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFilmLabel()
        contentView.addSubview(viewMoreIndicator)
        viewMoreIndicator.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
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
        return viewModel?.films.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let filmCell = collectionView.dequeueReusableCell(withReuseIdentifier: "filmCell", for: indexPath) as? FilmCell else {
            return UICollectionViewCell()
        }

        filmCell.name = viewModel?.films[indexPath.row]

        return filmCell
    }
}

extension CharacterDetailsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.text = viewModel?.films[indexPath.row]

        return CGSize(width: label.intrinsicContentSize.width + 24, height: label.intrinsicContentSize.height) // add 24 to make space for right arrow indicator
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let filmCell = collectionView.dequeueReusableCell(withReuseIdentifier: "filmCell", for: indexPath) as? FilmCell else { return }
        filmCell.backgroundColor = UIColor.black
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
        
        return "\(characterDatas?.height ?? String(0)) meter"
    }
    
    var mass: String {
        let characterDatas = characterDetailsVC?.characterData
        
        return "\(characterDatas?.mass ?? String(0)) kg"
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
    
    func filmsCollectionSetupConstraints() {
        guard let vc = characterDetailsVC else { return }
        vc.filmsCollection.leftAnchor.constraint(equalTo: vc.characterMainScrollView.leftAnchor).isActive = true
        vc.filmsCollection.heightAnchor.constraint(equalToConstant: 50).isActive = true
        vc.filmsCollection.topAnchor.constraint(equalTo: vc.filmsLabel.topAnchor, constant: 30).isActive = true
    }
}


class CharacterDetailsViewController: UIViewController {

    // MARK: view properties

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

        viewModel?.scrollViewSetup()
        viewModel?.filmsCollectionSetupConstraints()
        presentDetails()
    }

    func presentDetails() {
        // TODO: present details to UIView
    }

    // MARK: Character scroll view logic

    @IBAction func characterScrollViewRightArrowAction() {
        if pageIndex < 86  {
            viewModel?.set(direction: .right)
            filmsCollection.reloadSections(IndexSet(integer: 0))
            attributeCollection.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
    
    @IBAction func characterScrollViewLeftArrowAction() {
        if pageIndex > 0 {
            viewModel?.set(direction: .left)
            filmsCollection.reloadSections(IndexSet(integer: 0))
            attributeCollection.reloadSections(IndexSet(integer: 0), with: .automatic)
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
