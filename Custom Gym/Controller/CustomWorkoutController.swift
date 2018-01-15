//
//  CustomWorkoutController.swift
//  Custom Gym
//
//  Created by Joe Rivard on 1/3/18.
//  Copyright © 2018 Joe Rivard. All rights reserved.
//

import UIKit

class CustomWorkoutController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var workouts = [Workout]()
    var exercises = [Exercise]()

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        view.backgroundColor = .white

        view.addSubview(tableView)
        tableView.constrain(to: view)
    }

    func setupNavBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.font : UIFont(name: "HelveticaNeue-UltraLight", size: 24)!, .kern : 3]
        navigationItem.title = "Workouts & Exercises"

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
    }

    // MARK: - Tableview data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return workouts.count
        case 1:
            return exercises.count
        default:
            fatalError()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .red
        return cell
    }

    // MARK: - Tableview delegate

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    // MARK: - Actions

    @objc func handleAdd() {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let createWorkout = UIAlertAction(title: "Create Workout", style: .default) { (_) in
            print("present create workout")
        }

        let createExercise = UIAlertAction(title: "Create Exercise", style: .default) { (_) in
            let exerciseController = ExerciseController()
            let navController = UINavigationController(rootViewController: exerciseController)
            self.present(navController, animated: true, completion: nil)
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.dismiss(animated: true, completion: nil)
        }

        optionMenu.addAction(createWorkout)
        optionMenu.addAction(createExercise)
        optionMenu.addAction(cancel)

        present(optionMenu, animated: true, completion: nil)
    }

    // MARK: - Views

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
}















