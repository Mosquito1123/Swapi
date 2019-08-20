//
//  FilmsViewController.swift
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

class FilmsViewController: UITableViewController {

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

        tableView.accessibilityIdentifier = "FilmsTableView"

        if let revealVC = revealViewController() {
            revealMenuBar.target = revealVC
            revealMenuBar.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
    }

    // MARK: Table view setup

    var films: Dictionary<Int, Film>? = LocalCache.films

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilmsTableViewCell") else {
            return UITableViewCell(style: .default, reuseIdentifier: "FilmsTableViewCelll")
        }
        let keysArray = Array(films?.keys ?? Dictionary<Int, Film>().keys)
        let film = films?[keysArray[indexPath.row]]
        cell.textLabel?.text = film?.title

        // test identifiers
        cell.accessibilityIdentifier = film?.title ?? ""
        cell.accessibilityValue = film?.title ?? ""

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Router.routeTo(from: self, to: .FilmDetails, param: indexPath.row)
    }
}
