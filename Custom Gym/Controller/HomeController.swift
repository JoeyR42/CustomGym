//
//  HomeController.swift
//  Custom Gym
//
//  Created by Joe Rivard on 1/3/18.
//  Copyright © 2018 Joe Rivard. All rights reserved.
//

import UIKit

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var workouts = [Workout]()
    private var todayWorkout: Workout?

    // MARK: - View lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateGreetingLabel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

        populateWorkouts()
        todayWorkout = workouts.filter { checkIfToday(date: $0.date!) }.first
        if let todayWorkout = todayWorkout {
            guard let index = workouts.index(of: todayWorkout) else { return }
            workouts.remove(at: index)
        }

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func setupViews() {
        view.backgroundColor = .white

        view.addSubview(greetingStack)
        greetingStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 28).isActive = true
        greetingStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        greetingStack.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -12).isActive = true

        greetingStack.addSubview(border)
        border.leadingAnchor.constraint(equalTo: greetingStack.leadingAnchor, constant: -12).isActive = true
        border.topAnchor.constraint(equalTo: greetingStack.topAnchor).isActive = true
        border.bottomAnchor.constraint(equalTo: greetingStack.bottomAnchor).isActive = true
        border.widthAnchor.constraint(equalToConstant: 4).isActive = true

        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: greetingStack.bottomAnchor, constant: 8).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        border.applyGradient(colours: [.orange, Themes.orangeCreme])
    }

    // MARK: - Tableview data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return workouts.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        switch indexPath.section {
        case 0:
            if let todayWorkout = todayWorkout {
                cell.textLabel?.text = todayWorkout.name
            } else {
                //Make the cell of special type to start a new workout
            }
        default:
            cell.textLabel?.text = workouts[indexPath.row].name
        }

        return cell
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
            headerLabel.text = "Today"
        case 1:
            headerLabel.text = "Recent"
        default:
            fatalError()
        }

        return view
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }

    // MARK: - Helper functions

    func populateWorkouts() {
        let exercise = Exercise(context: AppDelegate.context)
        exercise.name = "Squat"
        exercise.reps = 5
        exercise.sets = 3
        exercise.weight = 175

        let workout = Workout(context: AppDelegate.context)
        workout.name = "Legs"
        workout.date = Date()
        workout.addToExercises(exercise)
        workouts.append(workout)

        let exercise2 = Exercise(context: AppDelegate.context)
        exercise2.name = "Bench"
        exercise2.reps = 5
        exercise2.sets = 3
        exercise2.weight = 175

        let workout2 = Workout(context: AppDelegate.context)
        workout2.name = "Chest"
        workout2.date = Date(timeIntervalSince1970: 1)
        workout2.addToExercises(exercise2)
        workouts.append(workout2)
    }

    func updateGreetingLabel() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)

        switch hour {
        case 4...11:
            greetingLabel.text = "Good Morning!"
        case 12...17:
            greetingLabel.text = "Good Afternoon!"
        case 18...3:
            greetingLabel.text = "Good Evening!"
        default:
            fatalError()
        }
    }

    func checkIfToday(date: Date) -> Bool {
        let calendar = NSCalendar.current
        return calendar.isDateInToday(date)
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

    private lazy var greetingStack: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false

        sv.addArrangedSubview(greetingLabel)
        sv.addArrangedSubview(dateLabel)

        sv.alignment = .leading
        sv.axis = .vertical
        sv.spacing = 8
        return sv
    }()

    private lazy var greetingLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont(name: "HelveticaNeue-UltraLight", size: 44)
        return l
    }()

    private lazy var dateLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Todays date"
        l.font = UIFont(name: "HelveticaNeue-UltraLight", size: 32)
        return l
    }()

    private let border: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let backgroundGradient: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
}














