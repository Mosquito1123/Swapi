//
//  StarshipsViewController.swift
//  Swapi
//
//  Created by TuyenLe on 7/30/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import UIKit

class StarshipsViewController: UITableViewController {

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

        tableView.accessibilityIdentifier = "StarshipsTableView"

        if let revealVC = revealViewController() {
            revealMenuBar.target = revealVC
            revealMenuBar.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
    }

    // MARK: Tableview setup

    var starships: Dictionary<Int, Starship>? = LocalCache.starships

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return starships?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StarshipsTableViewCell") else {
            return UITableViewCell(style: .default, reuseIdentifier: "StarshipsTableViewCelll")
        }
        let keysArray = Array(starships?.keys ?? Dictionary<Int, Starship>().keys)
        let starship = starships?[keysArray[indexPath.row]]
        cell.textLabel?.text = starship?.name

        // test identifiers
        cell.accessibilityIdentifier = starship?.name ?? ""
        cell.accessibilityValue = starship?.name ?? ""

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Router.routeTo(from: self, to: .StarshipDetails, page: indexPath.row, entityName: nil)
    }
}
