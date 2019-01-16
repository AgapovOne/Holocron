//
//  SearchViewController.swift
//  Holocron
//
//  Created by Alex Agapov on 16/01/2019.
//  Copyright © 2019 Alex Agapov. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    func configure() {
        view.backgroundColor = .white

        title = "Search"

        navigationController?.navigationBar.prefersLargeTitles = true

        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        navigationItem.searchController = search
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text)
    }
}

