//
//  WorkoutCell.swift
//  Custom Gym
//
//  Created by Joe Rivard on 2/10/18.
//  Copyright © 2018 Joe Rivard. All rights reserved.
//

import UIKit

class WorkoutCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {

    var exercises: [Exercise]?
    var workoutController: WorkoutController?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        contentView.addSubview(picker)
        picker.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        picker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        picker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        picker.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return exercises!.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return exercises![row].name
    }

    lazy var picker: UIPickerView = {
        let pv = UIPickerView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.delegate = self
        pv.dataSource = self
        return pv
    }()

}
