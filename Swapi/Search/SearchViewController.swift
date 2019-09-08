//
//  SearchViewController.swift
//  Swapi
//
//  Created by TuyenLe on 9/6/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import UIKit

// MARK: Extension

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        searchResults.removeAll()
        let caseInsensitiveSearchText = searchText.lowercased()

        for character in LocalCache.characters?.values ?? [Int: Character]().values where character.name.lowercased().contains(caseInsensitiveSearchText) {
            searchResults.append(character.name)
        }

        for film in LocalCache.films?.values ?? [Int: Film]().values where film.title.lowercased().contains(caseInsensitiveSearchText) {
            searchResults.append(film.title)
        }

        for planet in LocalCache.planets?.values ?? [Int: Planet]().values where planet.name.lowercased().contains(caseInsensitiveSearchText) {
            searchResults.append(planet.name)
        }

        for specie in LocalCache.species?.values ?? [Int: Specie]().values where specie.name.lowercased().contains(caseInsensitiveSearchText) {
            searchResults.append(specie.name)
        }

        for starship in LocalCache.starships?.values ?? [Int: Starship]().values where starship.name.lowercased().contains(caseInsensitiveSearchText) {
            searchResults.append(starship.name)
        }

        for vehicle in LocalCache.vehicles?.values ?? [Int: Vehicle]().values where vehicle.name.lowercased().contains(caseInsensitiveSearchText) {
            searchResults.append(vehicle.name)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let searchResultCell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell") else {
            return UITableViewCell()
        }

        searchResultCell.textLabel?.text = searchResults[indexPath.row]
        searchResultCell.textLabel?.textColor = .white

        return searchResultCell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchResultName = searchResults[indexPath.row]

        for character in LocalCache.characters?.values ?? [Int: Character]().values where character.name == searchResultName {
            Router.routeTo(from: self, to: .characterDetails, page: 0, entityName: [searchResultName])
            return
        }

        for film in LocalCache.films?.values ?? [Int: Film]().values where film.title == searchResultName {
            Router.routeTo(from: self, to: .filmDetails, page: 0, entityName: [searchResultName])
            return
        }

        for planet in LocalCache.planets?.values ?? [Int: Planet]().values where planet.name == searchResultName {
            Router.routeTo(from: self, to: .planetDetails, page: 0, entityName: [searchResultName])
            return
        }

        for specie in LocalCache.species?.values ?? [Int: Specie]().values where specie.name == searchResultName {
            Router.routeTo(from: self, to: .specieDetails, page: 0, entityName: [searchResultName])
            return
        }

        for starship in LocalCache.starships?.values ?? [Int: Starship]().values where starship.name == searchResultName {
            Router.routeTo(from: self, to: .starshipDetails, page: 0, entityName: [searchResultName])
            return
        }

        for vehicle in LocalCache.vehicles?.values ?? [Int: Vehicle]().values where vehicle.name == searchResultName {
            Router.routeTo(from: self, to: .vehicleDetails, page: 0, entityName: [searchResultName])
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchResultTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let label = UILabel()
        label.text = searchOptionsFilter[indexPath.row]

        return CGSize(width: label.intrinsicContentSize.width * 1.5, height: label.intrinsicContentSize.height)
    }
}

extension SearchViewController: UICollectionViewDataSource {
    var searchOptionsFilter: [String] {
        return ["characters", "films", "planets", "species", "starships", "vehicles"]
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let searchFilterOptionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchFilterOptionCell", for: indexPath) as? SearchFilterOptionCell
            else {
                return UICollectionViewCell()
        }

        searchFilterOptionCell.name = searchOptionsFilter[indexPath.row]
        searchFilterOptionCell.labelColor = .white
        searchFilterOptionCell.layer.borderColor = UIColor.white.cgColor
        searchFilterOptionCell.layer.borderWidth = 1
        searchFilterOptionCell.layer.cornerRadius = 5
        searchFilterOptionCell.textAlignment = .center
        return searchFilterOptionCell
    }
}

// MARK: Main class

class SearchViewController: UIViewController, UISearchControllerDelegate {

    @IBOutlet weak var searchResultTableView: UITableView!

    var searchController: UISearchController = UISearchController(searchResultsController: nil)

    var searchResults: [String] = []

    override func viewDidLoad() {

        super.viewDidLoad()

        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .yellow

        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false

        navigationItem.titleView = searchController.searchBar

        definesPresentationContext = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backItem = UIBarButtonItem()
        backItem.title = "Search"
        backItem.tintColor = .yellow
        navigationItem.backBarButtonItem = backItem
    }
}

class SearchFilterOptionCell: Cell {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
