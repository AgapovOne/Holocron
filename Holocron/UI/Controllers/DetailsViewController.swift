//
//  DetailsViewController.swift
//  Holocron
//
//  Created by Alex Agapov on 17/01/2019.
//  Copyright © 2019 Alex Agapov. All rights reserved.
//

import UIKit
import Cartography
import DefaultsKit

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

        configureUI()

        var peopleArray = Defaults.shared.get(for: Person.localStorageKey) ?? []
        if !peopleArray.contains(person) {
            peopleArray.append(person)
        }
        Defaults.shared.set(peopleArray, for: Person.localStorageKey)
    }

    private func configureUI() {
        view.backgroundColor = .white

        title = person.name

        view.addSubview(stackView)

        constrain(stackView) {
            $0.edges == inset($0.superview!.safeAreaLayoutGuide.edges, 16)
        }

        let values: [(String, String?)] = [
            ("Name", person?.name),
            ("Birthdate year", person?.birthYear),
            ("Eye color", person?.eyeColor?.capitalized),
            ("Gender", person?.gender?.rawValue.capitalized),
            ("Hair color", person?.hairColor?.capitalized),
            ("Skin color", person?.skinColor.capitalized),
            ("Weight", (person?.mass).map({ "\($0) kg" })),
            ("Height", (person?.height).map({ "\($0) cm" })),
//            ("Find out more", person?.url.absoluteString),
//            ("Homeworld", person?.homeworld.absoluteString),
//            ("Films", person?.films.map({ $0.absoluteString }).joined(separator: ";\n")),
//            ("Species related", person?.species.map({ $0.absoluteString }).joined(separator: ";\n")),
//            ("Starships related", person?.starships.map({ $0.absoluteString }).joined(separator: ";\n")),
//            ("Vehicles related", person?.vehicles.map({ $0.absoluteString }).joined(separator: ";\n"))
        ]

        values
            .compactMap({ $0.1 == nil ? nil : ($0.0, $0.1!) })
            .forEach {
                let innerStackView = UIStackView()
                innerStackView.axis = .horizontal
                innerStackView.spacing = 16

                let keyLabel = UILabel()
                keyLabel.numberOfLines = 1
                keyLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
                keyLabel.text = $0.0
                innerStackView.addArrangedSubview(keyLabel)

                let valueLabel = UILabel()
                valueLabel.numberOfLines = 0
                valueLabel.text = $0.1
                keyLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
                innerStackView.addArrangedSubview(valueLabel)
                stackView.addArrangedSubview(innerStackView)
        }
    }
}
