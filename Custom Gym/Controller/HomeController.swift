//
//  HomeController.swift
//  Custom Gym
//
//  Created by Joe Rivard on 1/3/18.
//  Copyright © 2018 Joe Rivard. All rights reserved.
//

import UIKit

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var workouts = [Workout]()
    private var todayWorkout: Activity?

    private var activities = [Activity]()

    // MARK: - View lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFromCoreData()
        updateGreetingLabel()

        self.activities = self.activities.sorted { $0.date! > $1.date! }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        updateDate()
        loadFromCoreData()

        todayWorkout = activities.filter { checkIfToday(date: $0.date!) }.first
//        if let todayWorkout = todayWorkout {
//            guard let index = activities.index(of: todayWorkout) else { return }
//            workouts.remove(at: index)
//        }

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func loadFromCoreData() {
        do {
            workouts = try AppDelegate.context.fetch(Workout.fetchRequest())
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

        do {
            activities = try AppDelegate.context.fetch(Activity.fetchRequest())
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
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
            return activities.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        switch indexPath.section {
        case 0:
            if let todayWorkout = todayWorkout {
                cell.textLabel?.text = todayWorkout.workouts?.name
            }
        default:
            cell.textLabel?.text = activities[indexPath.row].workouts?.name ?? "I was deleted"
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
            view.addSubview(activityButton)
            activityButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            activityButton.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -4).isActive = true
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

    // MARK: - Actions

    @objc func handleAdd() {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        for i in 0...workouts.count - 1 {
            let workout = workouts[i]
            let name = workout.name

            let createWorkout = UIAlertAction(title: name, style: .default) { (_) in
                let activity = Activity(context: AppDelegate.context)
                activity.workouts = workout
                activity.date = Date()
                self.activities.append(activity)

                self.activities = self.activities.sorted { $0.date! > $1.date! }

                self.todayWorkout = activity
                self.tableView.reloadData()
                AppDelegate.appDelegate.saveContext()
            }

            optionMenu.addAction(createWorkout)
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.dismiss(animated: true, completion: nil)
        }

        optionMenu.addAction(cancel)
        present(optionMenu, animated: true, completion: nil)
    }

    // MARK: - Helper functions

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

    func updateDate() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateLabel.text = dateFormatter.string(from: date)
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

    private let activityButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(#imageLiteral(resourceName: "closeIcon"), for: .normal)
        b.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        return b
    }()
}














