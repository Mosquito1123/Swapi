//
//  LaunchScreenViewController.swift
//  Swapi
//
//  Created by TuyenLe on 7/30/19.
//  Copyright (c) 2019 TuyenLe. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol LaunchScreenDisplayLogic: class {
    func cachPeople(viewModel: LaunchScreen.Fetch.ViewModel.Characters)
    func cachFilms(viewModel: LaunchScreen.Fetch.ViewModel.Films)
    func cachPlanets(viewModel: LaunchScreen.Fetch.ViewModel.Planets)
    func cachSpecies(viewModel: LaunchScreen.Fetch.ViewModel.Species)
    func cachStarships(viewModel: LaunchScreen.Fetch.ViewModel.Starships)
    func cachVehicles(viewModel: LaunchScreen.Fetch.ViewModel.Vehicles)
}

class LaunchScreenViewController: UIViewController, LaunchScreenDisplayLogic {

    var interactor: LaunchScreenBusinessLogic?

    var router: (NSObjectProtocol & LaunchScreenRoutingLogic & LaunchScreenDataPassing)?

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    lazy var tryAgainButton: UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = "tryServiceRequestAgain"
        button.setTitle("Try Again", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.clear.cgColor
        button.addTarget(self, action: #selector(preFetchAllStarwarsEntities), for: .touchUpInside)

        return button
    }()

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = LaunchScreenInteractor()
        let presenter = LaunchScreenPresenter()
        let router = LaunchScreenRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
          let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
          if let router = router, router.responds(to: selector) {
            router.perform(selector, with: segue)
          }
        }
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        preFetchAllStarwarsEntities()
    }

    // MARK: Prefetch entities and cach them to local database

    @objc func preFetchAllStarwarsEntities() {
        tryAgainButton.removeFromSuperview()
        loadingIndicator.startAnimating()
        interactor?.preFetchCharacters(request: LaunchScreen.Fetch.Request(sequence: 1..<10))
        interactor?.preFetchFilms()
        interactor?.preFetchPlanets(request: LaunchScreen.Fetch.Request(sequence: 1..<8))
        interactor?.preFetchSpecies(request: LaunchScreen.Fetch.Request(sequence: 1..<5))
        interactor?.preFetchStarships(request: LaunchScreen.Fetch.Request(sequence: 1..<5))
        interactor?.preFetchVehicles(request: LaunchScreen.Fetch.Request(sequence: 1..<5))

        Service.dispatchGroup.notify(queue: .main) {
            if LocalCache.characters != nil, LocalCache.films != nil, LocalCache.planets != nil,
               LocalCache.species != nil, LocalCache.starships != nil, LocalCache.vehicles != nil {

                print("finish pre-fetching all starwars entities")
                self.performSegue(withIdentifier: "first_screen", sender: nil)

            } else {
                print("error pre-fetching starwards properties")
                self.loadingIndicator.stopAnimating()
                self.view.addSubview(self.tryAgainButton)
                self.tryAgainButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
                self.tryAgainButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
                self.tryAgainButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                self.tryAgainButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            }
        }

    }

    func cachPeople(viewModel: LaunchScreen.Fetch.ViewModel.Characters) {
        print("cach characters")
        LocalCache.characters = viewModel.characters
    }

    func cachFilms(viewModel: LaunchScreen.Fetch.ViewModel.Films) {
        print("cach films")
        LocalCache.films = viewModel.films
    }

    func cachPlanets(viewModel: LaunchScreen.Fetch.ViewModel.Planets) {
        print("cach planets")
        LocalCache.planets = viewModel.planets
    }

    func cachSpecies(viewModel: LaunchScreen.Fetch.ViewModel.Species) {
        print("cach species")
        LocalCache.species = viewModel.species
    }

    func cachStarships(viewModel: LaunchScreen.Fetch.ViewModel.Starships) {
        print("cach starships")
        LocalCache.starships = viewModel.starships
    }

    func cachVehicles(viewModel: LaunchScreen.Fetch.ViewModel.Vehicles) {
        print("cach vehicles")
        LocalCache.vehicles = viewModel.vehicles
    }
}
