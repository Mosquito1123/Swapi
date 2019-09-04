//
//  SpecieDetailsViewController.swift
//  Swapi
//
//  Created by TuyenLe on 7/30/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import Foundation

// MARK: Extension

extension SpecieDetailsViewController: DetailScrollViewProtocol {

    var imageScrollView: UIScrollView {
        return specieImageScrollView
    }

    var pageIndex: Int {
        get {
            return specieIndex ?? 0
        }
        set {
            specieIndex = newValue
        }
    }
}

extension SpecieDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 8 {
            Router.routeTo(from: self, to: .PlanetDetails, page: 0, entityName: [viewModel?.homeworld ?? ""])
        }
    }
}

extension SpecieDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let specieCell = tableView.dequeueReusableCell(withIdentifier: "specieInformation", for: indexPath)
        specieCell.accessoryType = .none
        if indexPath.row == 0 {
            specieCell.textLabel?.text = "Classification"
            specieCell.detailTextLabel?.text = specieData?.classification
        } else if indexPath.row == 1 {
            specieCell.textLabel?.text = "Designation"
            specieCell.detailTextLabel?.text = specieData?.designation
        } else if indexPath.row == 2 {
            specieCell.textLabel?.text = "Average height"
            specieCell.detailTextLabel?.text = specieData?.averageHeight
        } else if indexPath.row == 3 {
            specieCell.textLabel?.text = "Skin color"
            specieCell.detailTextLabel?.text = specieData?.skinColors
        } else if indexPath.row == 4 {
            specieCell.textLabel?.text = "Hair colors"
            specieCell.detailTextLabel?.text = specieData?.hairColors
        } else if indexPath.row == 5 {
            specieCell.textLabel?.text = "Eye colors"
            specieCell.detailTextLabel?.text = specieData?.eyeColors
        } else if indexPath.row == 6 {
            specieCell.textLabel?.text = "Average lifespan"
            specieCell.detailTextLabel?.text = specieData?.averageLifespan
        } else if indexPath.row == 7 {
            specieCell.textLabel?.text = "Language"
            specieCell.detailTextLabel?.text = specieData?.language
        } else if indexPath.row == 8 {
            specieCell.textLabel?.text = "Homeworld"
            specieCell.isUserInteractionEnabled = viewModel?.homeworld == "unknown" ? false : true
            specieCell.accessoryType = viewModel?.homeworld == "unknown" ? .none : .disclosureIndicator
            specieCell.selectionStyle = .gray
            specieCell.detailTextLabel?.text = viewModel?.homeworld

        }
        return specieCell
    }
}

extension SpecieDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // incase user scroll past the end of scroll view
        if scrollView.contentOffset.x > 10584.0 {
            var visibleRect = scrollView.frame
            visibleRect.origin.x = 10584.0
            scrollView.scrollRectToVisible(visibleRect, animated: true)
        }
        if scrollView == specieImageScrollView {
            if viewModel?.previousImageViewContentOffset.x ?? 0 > scrollView.contentOffset.x {
                specieScrollViewLeftArrowAction()
            } else if viewModel?.previousImageViewContentOffset.x ?? 0 < scrollView.contentOffset.x {
                specieScrollViewRightArrowAction()
            }
        }
    }
}

extension SpecieDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == ownByCharacterCollection {
            return viewModel?.characters.count ?? 0
        } else if collectionView == filmCollection {
            return viewModel?.films.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == ownByCharacterCollection, let characterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as? CharacterCell {

            characterCell.name = viewModel?.characters[indexPath.row]
            return characterCell

        } else if collectionView == filmCollection, let filmCell = collectionView.dequeueReusableCell(withReuseIdentifier: "filmCell", for: indexPath) as? FilmCell {

            filmCell.name = viewModel?.films[indexPath.row]
            return filmCell

        }

        return UICollectionViewCell()
    }
}

extension SpecieDetailsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        if collectionView == ownByCharacterCollection {
            label.text = viewModel?.characters[indexPath.row]
        } else if collectionView == filmCollection {
            label.text = viewModel?.films[indexPath.row]
        }
        
        return CGSize(width: label.intrinsicContentSize.width + 24, height: label.intrinsicContentSize.height) // add 24 to make space for right arrow indicator
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == ownByCharacterCollection {
            Router.routeTo(from: self, to: .CharacterDetails, page: indexPath.row, entityName: viewModel?.characters)
        } else if collectionView == filmCollection {
            Router.routeTo(from: self, to: .FilmDetails, page: indexPath.row, entityName: viewModel?.films)
        }
    }
}

// MARK: Main class

/**
 ViewModel responsible for parsing and manipulate
 data from LocalCache
**/
class SpecieDetailsViewModel: ViewModel {
    weak var specieDetailsVC: SpecieDetailsViewController?

    var homeworld: String {
        guard let specieDatas = specieDetailsVC?.specieData else { return "" }
        if specieDatas.homeworld != "" {
            let id = Int(specieDatas.homeworld.components(separatedBy: "/")[5])!
            return LocalCache.planets?[id]?.name ?? ""
        }

        return "unknown"
    }

    var characters: [String] {
        let specieDatas = specieDetailsVC?.specieData
        var result: [String] = []
        for character in specieDatas?.characters ?? [] {
            let id = Int(character.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.characters?[id]?.name ?? "")
        }
    
        return result
    }

    var films: [String] {
        let specieDatas = specieDetailsVC?.specieData
        var result: [String] = []
        for film in specieDatas?.films ?? [] {
            let id = Int(film.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.films?[id]?.title ?? "")
        }
        return result
    }
    
    init(specieDetailsVC: SpecieDetailsViewController) {
        super.init(detailScrollViewProtocol: specieDetailsVC)
        self.specieDetailsVC = specieDetailsVC
    }
    
    func reloadAllTableAndCollection() {
        guard let vc = specieDetailsVC else { return }
        vc.specieInformation.reloadSections(IndexSet(integer: 0), with: .automatic)
        vc.ownByCharacterCollection.reloadSections(IndexSet(integer: 0))
    }

    override func set(direction: ViewModel.PageDirection) {
        super.set(direction: direction)
        guard let vc = specieDetailsVC else { return }
        vc.presentDetails()
    }

    override func scrollViewSetup() {
        super.scrollViewSetup()
        if let vc = specieDetailsVC {
            vc.imageScrollView.contentSize.width = vc.imageScrollView.frame.width * 37
        }
    }
}

/**
 Detail View Controller instantiate inside Router.routTo function
 from storyboard view controller's identifier. The design pattern
 is Model-ViewModel-Controller in order to keep the main view controller
 substantially small
**/
class SpecieDetailsViewController: UIViewController {

    @IBOutlet weak var specieInformation: UITableView!

    @IBOutlet weak var specieUIImageView: UIImageView!

    @IBOutlet weak var specieImageScrollView: UIScrollView!

    @IBOutlet weak var ownByCharacterCollection: UICollectionView!

    @IBOutlet weak var filmCollection: UICollectionView!

    var specieData: Specie?
    
    var specieNames: [String]?

    var specieIndex: Int?

    var viewModel: SpecieDetailsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = SpecieDetailsViewModel(specieDetailsVC: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let backItem = UIBarButtonItem()
        backItem.title = title
        navigationItem.backBarButtonItem = backItem
    }

    override func viewDidLayoutSubviews() {
        if let viewModel = self.viewModel {
            viewModel.scrollViewSetup()
            presentDetails()
        }
    }

    func presentDetails() {
        if let specieNames = specieNames {
            for specie in Array(LocalCache.species?.values ?? Dictionary<Int, Specie>().values) {
                if specie.name == specieNames[pageIndex] {
                    specieData = specie
                    break
                }
            }
        } else {
            specieData = Array(LocalCache.species?.values ?? Dictionary<Int, Specie>().values)[pageIndex]
        }
        title = specieData?.name
        specieUIImageView.image = UIImage(named: "Species/\(title ?? "")")
        if viewModel?.previousImageViewContentOffset.x != 0.0 {
            imageScrollView.constraintWithIdentifier("specieUIImageViewCenterX")?.constant = viewModel?.previousImageViewContentOffset.x ?? 0
        } else {
            imageScrollView.constraintWithIdentifier("specieUIImageViewCenterX")?.constant = 1
        }
    }

    @IBAction func specieScrollViewLeftArrowAction() {
        if pageIndex > 0 {
            viewModel?.set(direction: .left)
            viewModel?.reloadAllTableAndCollection()
        }
    }

    @IBAction func specieScrollViewRightArrowAction() {
        let totalPage = specieNames == nil ? LocalCache.species?.count ?? 0 : specieNames?.count ?? 0
        if pageIndex < totalPage - 1 {
            viewModel?.set(direction: .right)
            viewModel?.reloadAllTableAndCollection()
        }
    }
}
