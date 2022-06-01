//
//  SettingsTableViewController.swift
//  TextToSpeech
//
//  Created by Daniel James Tronca on 01/06/22.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

}
