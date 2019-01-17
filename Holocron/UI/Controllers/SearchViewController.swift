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
    private lazy var refreshControl = UIRefreshControl()

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

        tableView.refreshControl = refreshControl
    }

    private func configureObservers() {
        let refreshControlEvent = refreshControl.rx.controlEvent(.valueChanged).map({ [weak self] in self?.searchController.searchBar.text ?? "" })
        let searchBarTextEvent = searchController.searchBar.rx.text.orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()

        let searchResults = Observable.merge(refreshControlEvent, searchBarTextEvent)
                    .flatMapLatest { [weak disposeBag] query -> Observable<[Person]> in
                        let request = NetworkService.getPeople(name: query)

                        if let disposeBag = disposeBag {
                        request
                            .subscribe { [weak self] _ in
                                self?.refreshControl.endRefreshing()
                            }.disposed(by: disposeBag)
                        }

                        return request
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

        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Person.self))
            .subscribe { [weak self] event in
                switch event {
                case .next(let indexPath, let person):
                    self?.tableView.deselectRow(at: indexPath, animated: true)

                    let detailsViewController = DetailsViewController.instantiate(person: person)
                    self?.navigationController?.pushViewController(detailsViewController, animated: true)
                default:
                    break
                }
            }.disposed(by: disposeBag)

        // Start with searching for everyone
        searchController.searchBar.rx.text.onNext("")
    }
}
