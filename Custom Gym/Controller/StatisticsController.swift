//
//  StatisticsController.swift
//  Custom Gym
//
//  Created by Joe Rivard on 1/3/18.
//  Copyright © 2018 Joe Rivard. All rights reserved.
//

import UIKit

class StatisticsController: UIViewController {

//    var activities = [Activity]()
    var exercises = [Exercise]()
    var weights = [Int]()
    var reps = [Int]()

    override func viewWillAppear(_ animated: Bool) {
        loadFromCoreData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Themes.almostWhite
        loadFromCoreData()

        exercises.forEach { weights.append(Int($0.weight)); reps.append(Int($0.reps)) }
        reps = reps.sorted { $0 < $1 }
        weights = weights.sorted { $0 < $1 }

        view.addSubview(weightGraph)
        weightGraph.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        weightGraph.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -12).isActive = true
        weightGraph.widthAnchor.constraint(equalToConstant: 240).isActive = true
        weightGraph.heightAnchor.constraint(equalToConstant: 240).isActive = true

        view.addSubview(repGraph)
        repGraph.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        repGraph.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 12).isActive = true
        repGraph.widthAnchor.constraint(equalToConstant: 240).isActive = true
        repGraph.heightAnchor.constraint(equalToConstant: 240).isActive = true

        weightGraph.addSubview(weightLabel)
        weightLabel.centerXAnchor.constraint(equalTo: weightGraph.centerXAnchor).isActive = true
        weightLabel.topAnchor.constraint(equalTo: weightGraph.topAnchor, constant: 4).isActive = true

        repGraph.addSubview(repLabel)
        repLabel.centerXAnchor.constraint(equalTo: repGraph.centerXAnchor).isActive = true
        repLabel.topAnchor.constraint(equalTo: repGraph.topAnchor, constant: 4).isActive = true
    }

    func loadFromCoreData() {
        do {
            exercises = try AppDelegate.context.fetch(Exercise.fetchRequest())
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    private lazy var weightGraph: GraphView = {
        let g = GraphView()
        g.graphPoints = weights
        g.translatesAutoresizingMaskIntoConstraints = false
        g.backgroundColor = Themes.almostWhite
        return g
    }()

    private lazy var repGraph: GraphView = {
        let g = GraphView()
        g.graphPoints = reps
        g.translatesAutoresizingMaskIntoConstraints = false
        g.backgroundColor = Themes.almostWhite
        return g
    }()

    private let weightLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Weight Progression"
        return l
    }()

    private let repLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Rep Progression"
        return l
    }()
}
