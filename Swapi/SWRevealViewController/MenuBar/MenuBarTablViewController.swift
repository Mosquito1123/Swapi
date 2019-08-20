//
//  MenuBarTablView.swift
//  Swapi
//
//  Created by TuyenLe on 7/29/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import Foundation

class MenuBarTableViewController: UITableViewController {

    var menu: [String] = [
        "Characters",
        "Films",
        "Planets",
        "Species",
        "Starships",
        "Vehicles"
    ]

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuCell = tableView.dequeueReusableCell(withIdentifier: menu[indexPath.row], for: indexPath)
        menuCell.textLabel?.text = menu[indexPath.row]
        menuCell.frame.size.width = 5
        return menuCell
    }
}
