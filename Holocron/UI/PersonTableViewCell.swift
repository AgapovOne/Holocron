//
//  PersonTableViewCell.swift
//  Holocron
//
//  Created by Alex Agapov on 17/01/2019.
//  Copyright © 2019 Alex Agapov. All rights reserved.
//

import UIKit

final class PersonTableViewCell: UITableViewCell {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setup()
    }

    private func setup() {
    }
}
