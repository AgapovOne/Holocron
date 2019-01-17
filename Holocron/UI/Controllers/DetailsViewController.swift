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

        let label = UILabel()
        label.text = "HAHAGHAHAHAH"
        stackView.addArrangedSubview(label)

        let label2 = UILabel()
        label2.text = "WOW ITS YOU RIGHT?!@>!@>"
        stackView.addArrangedSubview(label2)
    }
}
