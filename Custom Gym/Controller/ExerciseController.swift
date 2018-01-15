//
//  ExerciseController.swift
//  Custom Gym
//
//  Created by Joe Rivard on 1/3/18.
//  Copyright © 2018 Joe Rivard. All rights reserved.
//

import UIKit

class ExerciseController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let context = AppDelegate.context

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func setupViews() {
        view.backgroundColor = .white

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismiss))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))

        view.addSubview(tableView)
        tableView.constrain(to: view)
    }

    // MARK: - Tableview data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.separatorInset = .zero

        switch indexPath.row {
        case 0:
            nameTextField = UITextField(frame: cell.contentView.bounds.insetBy(dx: 15, dy: 0))
            cell.addSubview(nameTextField)
            nameTextField.placeholder = "Name"
        case 1:
            weightTextField = UITextField(frame: cell.contentView.bounds.insetBy(dx: 15, dy: 0))
            cell.addSubview(weightTextField)
            weightTextField.placeholder = "Starting Weight (Optional)"
        case 2:
            repsTextField = UITextField(frame: cell.contentView.bounds.insetBy(dx: 15, dy: 0))
            cell.addSubview(repsTextField)
            repsTextField.placeholder = "Starting Reps (Optional)"
        default:
            fatalError()
        }

        return cell
    }

    // MARK - Tableview delegate
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    // MARK: - Actions

    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }

    @objc func handleSave() {
        let texts = [nameTextField, weightTextField, repsTextField].flatMap { $0?.text }

        let exercise = Exercise(context: context)
        exercise.name = texts[0]
        exercise.weight = Int64(texts[1])!
        exercise.reps = Int64(texts[2])!

        
    }

    // MARK: - Views

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.allowsSelection = false
        return tv
    }()

    var nameTextField: UITextField!
    var weightTextField: UITextField!
    var repsTextField: UITextField!
}
