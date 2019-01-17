//
//  SearchViewController.swift
//  Holocron
//
//  Created by Alex Agapov on 16/01/2019.
//  Copyright © 2019 Alex Agapov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private lazy var tableView = UITableView()
    private lazy var searchController = UISearchController(searchResultsController: nil)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureObservers()
    }

    // MARK: - Private
    private func configureUI() {
        view.backgroundColor = .white

        title = "Search"

        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true

        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: "Cell")

        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()

        tableView.frame = view.frame
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
    }

    private func configureObservers() {
        let searchResults = searchController.searchBar.rx.text.orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query -> Observable<[Person]> in
                return NetworkService.getPeople(name: query)
                    .catchErrorJustReturn([]).asObservable()
            }
            .observeOn(MainScheduler.instance)
        searchResults
            .debug()
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) {
                (index, model: Person, cell) in
                cell.textLabel?.text = model.name
                cell.detailTextLabel?.text = model.url.absoluteString
            }
            .disposed(by: disposeBag)

        searchController.searchBar.rx.text.onNext("")

        tableView.rx.itemSelected
            .subscribe { [weak self] event in
            switch event {
            case .next(let indexPath):
                self?.tableView.deselectRow(at: indexPath, animated: true)
            default:
                break
            }
        }.disposed(by: disposeBag)

        tableView.rx.modelSelected(Person.self)
            .subscribe { [weak self] event in
                switch event {
                case .next(let person):
                    let detailsViewController = DetailsViewController.instantiate(person: person)
                    self?.navigationController?.pushViewController(detailsViewController, animated: true)
                default:
                    break
                }
            }.disposed(by: disposeBag)
    }
}
