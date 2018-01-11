//
//  CustomWorkoutController.swift
//  Custom Gym
//
//  Created by Joe Rivard on 1/3/18.
//  Copyright © 2018 Joe Rivard. All rights reserved.
//

import UIKit

class CustomWorkoutController: UIViewController {

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        view.backgroundColor = .white
    }

    func setupNavBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.font : UIFont(name: "HelveticaNeue-UltraLight", size: 24)!, .kern : 3]
        navigationItem.title = "Workouts & Exercises"

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
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
}
