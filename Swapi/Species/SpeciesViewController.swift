//
//  SpeciesViewController.swift
//  Swapi
//
//  Created by TuyenLe on 7/29/19.
//  Copyright (c) 2019 TuyenLe. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class SpeciesViewController: UITableViewController {
    @IBOutlet weak var revealMenuBar: UIBarButtonItem!

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.accessibilityIdentifier = "SpeciesTableView"

        if let revealVC = revealViewController() {
            revealMenuBar.target = revealVC
            revealMenuBar.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backItem = UIBarButtonItem()
        backItem.title = "Species"
        backItem.tintColor = .yellow
        navigationItem.backBarButtonItem = backItem
    }

    // MARK: Tableview setup

    var species: [Int: Specie]? = LocalCache.species

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return species?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SpeciesTableViewCell") else {
            return UITableViewCell(style: .default, reuseIdentifier: "SpeciesTableViewCelll")
        }
        let keysArray = Array(species?.keys ?? [Int: Specie]().keys)
        let specie = species?[keysArray[indexPath.row]]
        cell.textLabel?.text = specie?.name
        cell.textLabel?.textColor = .white

        // test identifiers
        cell.accessibilityIdentifier = specie?.name ?? ""
        cell.accessibilityValue = specie?.name ?? ""

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Router.routeTo(from: self, to: .specieDetails, page: indexPath.row, entityName: nil)
    }
}
