//
//  SpecieDetailsViewController.swift
//  Swapi
//
//  Created by TuyenLe on 7/30/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import Foundation

extension SpecieDetailsViewController: DetailScrollViewProtocol {
    var mainScrollView: UIScrollView {
        return specieMainScrollView
    }
    
    var imageScrollView: UIScrollView {
        return specieImageScrollView
    }
    
    var leftArrow: UIButton {
        return specieScrollViewLeftArrow
    }
    
    var rightArrow: UIButton {
        return specieScrollViewRightArrow
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
            Router.routeTo(from: self, to: .PlanetDetails, page: 0, entityName: [viewModel?.homeWorlds ?? ""])
        }
    }
}

extension SpecieDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let specieCell = tableView.dequeueReusableCell(withIdentifier: "specieInformation", for: indexPath)

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
            specieCell.selectionStyle = .gray
            specieCell.detailTextLabel?.text = viewModel?.homeWorlds
            specieCell.accessoryType = .disclosureIndicator
        }
        return specieCell
    }
}

extension SpecieDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == specieImageScrollView {
            if viewModel?.previousImageViewContentOffset.x ?? 0 > scrollView.contentOffset.x {
                specieScrollViewLeftArrowAction()
            } else if viewModel?.previousImageViewContentOffset.x ?? 0 < scrollView.contentOffset.x {
                specieScrollViewRightArrowAction()
            }
        }
    }
}

class SpecieDetailsViewModel: ViewModel {
    weak var specieDetailsVC: SpecieDetailsViewController?

    var homeWorlds: String {
        guard let specieDatas = specieDetailsVC?.specieData else { return "" }

        let id = Int(specieDatas.homeworld.components(separatedBy: "/")[5])!

        return LocalCache.planets?[id]?.name ?? ""
    }

    var characters: [String] {
        let specieDatas = specieDetailsVC?.specieData
        var result: [String] = []
        for character in specieDatas?.people ?? [] {
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
    }
    
    override func set(direction: ViewModel.PageDirection) {
        super.set(direction: direction)
        guard let vc = specieDetailsVC else { return }
        vc.presentDetails()
    }
}

class SpecieDetailsViewController: UIViewController {

    @IBOutlet weak var specieInformation: UITableView!

    @IBOutlet weak var specieMainScrollView: UIScrollView!

    @IBOutlet weak var specieScrollViewLeftArrow: UIButton!

    @IBOutlet weak var specieScrollViewRightArrow: UIButton!

    @IBOutlet weak var specieImageScrollView: UIScrollView!

    var specieData: Specie?

    var specieIndex: Int?

    var viewModel: SpecieDetailsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = SpecieDetailsViewModel(specieDetailsVC: self)
        viewModel?.scrollViewSetup()

        presentDetails()
    }

    func presentDetails() {
        specieData = Array(LocalCache.species?.values ?? Dictionary<Int, Specie>().values)[pageIndex]
        title = specieData?.name
    }

    @IBAction func specieScrollViewLeftArrowAction() {
        if pageIndex > 0 {
            viewModel?.set(direction: .left)
            viewModel?.reloadAllTableAndCollection()
        }
    }

    @IBAction func specieScrollViewRightArrowAction() {
        let totalPage = LocalCache.planets?.count ?? 0
        if pageIndex < totalPage - 1 {
            viewModel?.set(direction: .right)
            viewModel?.reloadAllTableAndCollection()
        }
    }
}
