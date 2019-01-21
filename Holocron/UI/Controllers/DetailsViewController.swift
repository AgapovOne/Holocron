//
//  DetailsViewController.swift
//  Holocron
//
//  Created by Alex Agapov on 17/01/2019.
//  Copyright © 2019 Alex Agapov. All rights reserved.
//

import UIKit

final class DetailsViewController: UIViewController {

    // MARK: - Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: view.frame)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()

    private var person: Person!

    static func instantiate(person: Person) -> DetailsViewController {
        let viewController = DetailsViewController()
        viewController.person = person
        return viewController
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        title = person.name

        stackView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(stackView)

        let values: [String?] = [
            (person?.birthYear),
            (person?.eyeColor),
            (person?.gender?.rawValue.uppercased()),
            (person?.hairColor),
            (person?.mass),
            (person?.height),
            (person?.homeworld),
            (person?.name),
            (person?.skinColor),
            //            (person?.created),
            //            (person?.edited),
            (person?.url.absoluteString),
            (person?.films.map({ $0.absoluteString }).joined(separator: "; ")),
            (person?.species.map({ $0.absoluteString }).joined(separator: "; ")),
            (person?.starships.map({ $0.absoluteString }).joined(separator: "; ")),
            (person?.vehicles.map({ $0.absoluteString }).joined(separator: "; "))
        ]

        values
            .compactMap({ $0 })
            .forEach {
                let label = UILabel()
                label.text = $0
                stackView.addArrangedSubview(label)
        }
    }
}
