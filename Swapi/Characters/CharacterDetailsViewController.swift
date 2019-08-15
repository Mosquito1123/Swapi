//
//  CharacterDetails.swift
//  Swapi
//
//  Created by TuyenLe on 7/30/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import Foundation

class CharacterDetailsViewModel: ViewModel {

    weak var characterDetailsVC: CharacterDetailsViewController?

    // MARK: data manipulation

    var homeWorlds: [String] {
        let characterDatas = characterDetailsVC?.characterData
        var result: [String] = []

        for homeWorld in characterDatas?.homeworld ?? [] {
            let id = Int(homeWorld.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.characters?[id]?.name ?? "")
        }
        return result
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
        super.init(imageScrollViewProtocol: characterDetailsVC, detailVC: characterDetailsVC)
        self.characterDetailsVC = characterDetailsVC
    }

    // MARK: view logic

    override func setCharacter(page: ViewModel.PageDirection) {
        super.setCharacter(page: page)

        if let vc = characterDetailsVC {
            vc.characterData = Array(LocalCache.characters!.values)[vc.characterIndex!]
            vc.title = vc.characterData?.name
        }
    }
}

extension CharacterDetailsViewController: ImageScrollViewProtocol {
    var scrollView: UIScrollView {
        get {
            return charactersScrollView
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

class CharacterDetailsViewController: UIViewController {

    // MARK: scroll view properties

    @IBOutlet weak var charactersScrollView: UIScrollView!
    
    @IBOutlet weak var characterScrollViewLeftArrow: UIButton!

    @IBOutlet weak var characterScrollViewRightArrow: UIButton!

    // MARK: control logic

    var characterData: People?

    var viewModel: CharacterDetailsViewModel?

    var characterIndex: Int?

    // MARK: initial setup

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        viewModel = CharacterDetailsViewModel(characterDetailsVC: self)
        scrollView.delegate = self

        
        if let index = characterIndex {
            characterData = Array(LocalCache.characters!.values)[index]
            title = characterData?.name
        }

        viewModel?.charactersScrollViewSetup()
        presentDetails()
    }

    func presentDetails() {
        // TODO: present details to UIView
    }
    
    // MARK: Device rotation

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        viewModel?.updateConstraints(to: size)
    }

    // MARK: Character scroll view logic

    @IBAction func characterScrollViewLeftArrowAction(_ sender: Any) {
        if characterIndex! > 0 {
            viewModel?.setCharacter(page: .left)
        }
    }
    
    @IBAction func characterScrollViewRightArrowAction(_ sender: Any) {
        if characterIndex! < 87  {
            viewModel?.setCharacter(page: .right)
        }
    }
}

extension CharacterDetailsViewController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        characterIndex = scrollView.page
        characterData = Array(LocalCache.characters!.values)[characterIndex!]
        title = characterData?.name
    }
}

extension UIScrollView {
    /// current page number
    var page: Int {
        return Int(round(contentOffset.x / frame.size.width))
    }
}
