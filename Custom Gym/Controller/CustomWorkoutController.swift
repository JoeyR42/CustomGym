//
//  CustomWorkoutController.swift
//  Custom Gym
//
//  Created by Joe Rivard on 1/3/18.
//  Copyright © 2018 Joe Rivard. All rights reserved.
//

import UIKit

class CustomWorkoutController: UIViewController, UITableViewDelegate, UITableViewDataSource, ExerciseControllerDelegate, WorkoutControllerDelegate {

    var workouts = [Workout]()
    var exercises = [Exercise]()

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadFromCoreData()

        setupNavBar()
        view.backgroundColor = .white

        view.addSubview(tableView)
        tableView.constrain(to: view)
    }

    func loadFromCoreData() {
        do {
            exercises = try AppDelegate.context.fetch(Exercise.fetchRequest())
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

        do {
            workouts = try AppDelegate.context.fetch(Workout.fetchRequest())
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
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
        switch indexPath.section {
        case 0:
            let cell = UITableViewCell()
            let workout = workouts[indexPath.row]
            cell.textLabel?.text = workout.name
            return cell
        case 1:
            let cell = ExerciseCell(style: .default, reuseIdentifier: "cell")
            let exercise = exercises[indexPath.row]
            cell.name.text = exercise.name
            cell.weight.text = "\(exercise.weight)"
            cell.reps.text = "\(exercise.reps)"
            return cell
        default:
            fatalError()
        }
        return UITableViewCell()
    }

    // MARK: - Tableview delegate

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = Themes.almostWhite

        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 36)

        view.addSubview(headerLabel)
        headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
        headerLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor).isActive = true
        headerLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        switch section {
        case 0:
            headerLabel.text = "Workouts"
        case 1:
            headerLabel.text = "Exercises"
        default:
            fatalError()
        }

        return view
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }

    // MARK: - Exercise controller delegate

    func saveExercise(exercise: Exercise) {
        exercises.append(exercise)

        tableView.reloadData()

        AppDelegate.appDelegate.saveContext()
    }

    //MARK: - Workout controller delegate

    func saveWorkout(workout: Workout) {
        workouts.append(workout)

        tableView.reloadData()

        AppDelegate.appDelegate.saveContext()
    }

    // MARK: - Actions

    @objc func handleAdd() {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let createWorkout = UIAlertAction(title: "Create Workout", style: .default) { (_) in
            let workoutController = WorkoutController()
            workoutController.exercises = self.exercises
            workoutController.delegate = self
            let navController = UINavigationController(rootViewController: workoutController)
            self.present(navController, animated: true, completion: nil)
        }

        let createExercise = UIAlertAction(title: "Create Exercise", style: .default) { (_) in
            let exerciseController = ExerciseController()
            exerciseController.delegate = self
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















