//
//  WorkoutController.swift
//  Custom Gym
//
//  Created by Joe Rivard on 1/15/18.
//  Copyright © 2018 Joe Rivard. All rights reserved.
//

import UIKit

protocol WorkoutControllerDelegate: class {
    func saveWorkout(workout: Workout)
}

class WorkoutController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var exercises: [Exercise]?
    var heightAnchor: NSLayoutConstraint?
    var selectedExercises = [Exercise]()

    weak var delegate: WorkoutControllerDelegate?

    var row = 2
    let rowHeight = 86
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func setupViews() {
        view.backgroundColor = .white

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismiss))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))

        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        view.addSubview(addButton)
        view.bringSubview(toFront: addButton)
        addButton.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 72).isActive = true
        addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
    }

    // MARK: - Tableview data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return row
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
        case 0:
            let cell = UITableViewCell()
            nameTextField = UITextField(frame: cell.contentView.bounds.insetBy(dx: 15, dy: 0))
            cell.addSubview(nameTextField)
            nameTextField.placeholder = "Name"
            return cell
        default:
            let cell = WorkoutCell()
            cell.workoutController = self
            cell.backgroundColor = Themes.almostWhite
            cell.exercises = exercises
            return cell
        }
    }

    // MARK: - Tableview delegate

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 44
        default:
            return 86
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        if indexPath.row == 0 {
            return
        }
        if editingStyle == .delete {
            self.row -= 1
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Actions

    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }

    @objc func handleSave() {
        for i in 1...row - 1 {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! WorkoutCell
            let exerciseIndex = cell.picker.selectedRow(inComponent: 0)
            selectedExercises.append(exercises![exerciseIndex])
        }
        let set = NSOrderedSet(array: selectedExercises)
        let workout = Workout(context: AppDelegate.context)
        workout.addToExercises(set)
        workout.name = nameTextField.text
        delegate?.saveWorkout(workout: workout)

        dismiss(animated: true, completion: nil)
    }

    @objc func handleAdd() {
        let indexPath = IndexPath(row: row, section: 0)
        row += 1
        heightAnchor?.constant += CGFloat(rowHeight)
        tableView.insertRows(at: [indexPath], with: .automatic)

    }

    // MARK: Views

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.allowsSelection = false
        tv.rowHeight = 86
        return tv
    }()

    let addButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        b.setImage(#imageLiteral(resourceName: "closeIcon"), for: .normal)
        return b
    }()

    var nameTextField: UITextField!
}













