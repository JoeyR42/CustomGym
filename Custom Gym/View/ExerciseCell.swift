//
//  ExerciseCell.swift
//  Custom Gym
//
//  Created by Joe Rivard on 1/15/18.
//  Copyright © 2018 Joe Rivard. All rights reserved.
//

import UIKit

class ExerciseCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        contentView.addSubview(name)
        contentView.addSubview(weight)
        contentView.addSubview(reps)

        name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        name.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        name.trailingAnchor.constraint(lessThanOrEqualTo: weight.leadingAnchor, constant: -4).isActive = true

        weight.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        weight.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

        reps.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        reps.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }

    // MARK: - Views

    let name: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let weight: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let reps: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

}
