//
//  ExerciseController.swift
//  Custom Gym
//
//  Created by Joe Rivard on 1/3/18.
//  Copyright © 2018 Joe Rivard. All rights reserved.
//

import UIKit

class ExerciseController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func setupViews() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismiss))

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

        let textField = UITextField(frame: cell.contentView.bounds.insetBy(dx: 15, dy: 0))
        cell.addSubview(textField)

        switch indexPath.row {
        case 0:
            textField.placeholder = "Name"
        case 1:
            textField.placeholder = "Starting Weight (Optional)"
        case 2:
            textField.placeholder = "Starting Reps (Optional)"
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

    // MARK: - Views
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.allowsSelection = false
        return tv
    }()

}
