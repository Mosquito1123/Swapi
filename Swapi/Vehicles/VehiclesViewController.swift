//
//  VehiclesViewController.swift
//  Swapi
//
//  Created by TuyenLe on 7/30/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import UIKit

class VehiclesViewController: UITableViewController {
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

        tableView.accessibilityIdentifier = "VehiclesTableView"

        if let revealVC = revealViewController() {
            revealMenuBar.target = revealVC
            revealMenuBar.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backItem = UIBarButtonItem()
        backItem.title = "Vehicles"
        backItem.tintColor = .yellow
        navigationItem.backBarButtonItem = backItem
    }

    // MARK: Tableview setup

    var vehicles: [Int: Vehicle]? = LocalCache.vehicles

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicles?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VehiclesTableViewCell") else {
            return UITableViewCell(style: .default, reuseIdentifier: "VehiclesTableViewCell")
        }

        let keysArray = Array(vehicles?.keys ?? [Int: Vehicle]().keys)
        let vehicle = vehicles?[keysArray[indexPath.row]]
        cell.textLabel?.text = vehicle?.name
        cell.textLabel?.textColor = .white

        // test identifiers
        cell.accessibilityIdentifier = vehicle?.name ?? ""
        cell.accessibilityValue = vehicle?.name ?? ""

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Router.routeTo(from: self, to: .vehicleDetails, page: indexPath.row, entityName: nil)
    }
}
