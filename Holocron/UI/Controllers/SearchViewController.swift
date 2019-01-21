//
//  SearchViewController.swift
//  Holocron
//
//  Created by Alex Agapov on 16/01/2019.
//  Copyright © 2019 Alex Agapov. All rights reserved.
//

import UIKit
import Cartography
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()

        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: "Cell")

        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()

        tableView.refreshControl = refreshControl
        return tableView
    }()
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
    }()
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .blue
        return control
    }()

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

        tableView.frame = view.frame
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)

        view.addSubview(errorLabel)
        constrain(errorLabel) {
            $0.centerY == $0.superview!.centerY
            $0.leading == $0.superview!.leading + 16
            $0.trailing == $0.superview!.trailing - 16
        }
    }

    private func configureObservers() {
        let refreshControlEvent = refreshControl.rx
            .controlEvent(.valueChanged)
            .map { [weak self] in self?.searchController.searchBar.text ?? "" }
        let searchBarTextEvent = searchController.searchBar.rx.text.orEmpty
            .throttle(0.6, scheduler: MainScheduler.instance)
            .distinctUntilChanged()

        let searchResults = Observable.merge(refreshControlEvent, searchBarTextEvent)
            .flatMapLatest { [weak disposeBag] query -> Observable<[Person]> in
                let request = NetworkService.getPeople(name: query)

                if let disposeBag = disposeBag {
                    request
                        .observeOn(MainScheduler.instance)
                        .subscribe { [weak self] _ in
                            self?.refreshControl.endRefreshing()
                        }.disposed(by: disposeBag)
                }
                return request
                    .catchError({ [weak self] (error) in
                        self?.errorLabel.text = error.localizedDescription
                        self?.errorLabel.textColor = .red
                        return Single<[Person]>.just([])
                    })
                    .do(onSuccess: { [weak self] _ in
                        let text = self?.searchController.searchBar.text
                        let errorString = text == nil
                            ? "Nothing found"
                            : "Nothing found for \"\(text!)\""
                        self?.errorLabel.text = errorString
                        self?.errorLabel.textColor = .black
                    })
                    .asObservable()
            }
            .observeOn(MainScheduler.instance)

        searchResults
//            .debug()
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) {
                (index, model: Person, cell) in
                cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
                cell.textLabel?.text = model.name

                let details: [String?] = [
                    (model.gender?.rawValue.capitalized).map({ "is \($0)" }),
                    (model.eyeColor?.capitalized).map({ "with \($0) eyes" }),
                    (model.hairColor?.capitalized).map({ "\($0) hair" }),
                    "\(model.skinColor.capitalized) skin",
                    "\(model.mass) kg",
                    "\(model.height) cm",
                    model.birthYear.map({ "born in \($0)" })
                ]
                cell.detailTextLabel?.numberOfLines = 0
                cell.detailTextLabel?.text = details.compactMap({ $0 }).joined(separator: ", ")
            }
            .disposed(by: disposeBag)

        let searchEmptyDriver = searchResults
            .map({ $0.isEmpty })
            .asDriver(onErrorJustReturn: true)

        searchEmptyDriver
            .drive(tableView.rx.isHidden)
            .disposed(by: disposeBag)

        searchEmptyDriver
            .map({ !$0 })
            .drive(errorLabel.rx.isHidden)
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
