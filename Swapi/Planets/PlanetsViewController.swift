//
//  PlanetsViewController.swift
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


class PlanetsViewController: UITableViewController {
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

        tableView.accessibilityIdentifier = "PlanetsTableView"

        if let revealVC = revealViewController() {
            revealMenuBar.target = revealVC
            revealMenuBar.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
    }

    // MARK: Tableview setup

    var planets: Dictionary<Int, Planet>? = LocalCache.planets

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planets?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlanetsTableViewCell") else {
            return UITableViewCell(style: .default, reuseIdentifier: "PlanetsTableViewCelll")
        }
        let keysArray = Array(planets?.keys ?? Dictionary<Int, Planet>().keys)
        let planet = planets?[keysArray[indexPath.row]]
        cell.textLabel?.text = planet?.name

        // test identifiers
        cell.accessibilityIdentifier = planet?.name ?? ""
        cell.accessibilityValue = planet?.name ?? ""

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Router.routeTo(from: self, to: .PlanetDetails, page: indexPath.row, entityName: nil)
    }
}
