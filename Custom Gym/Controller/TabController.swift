//
//  ViewController.swift
//  Custom Gym
//
//  Created by Joe Rivard on 1/3/18.
//  Copyright © 2018 Joe Rivard. All rights reserved.
//

import UIKit

class TabController: UITabBarController {

    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // MARK: - View lifecycle

    func loadFromCoreData() {
//        do {
//            noteCores = try context.fetch(NoteCore.fetchRequest())
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadFromCoreData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.itemPositioning = .fill
        tabBar.backgroundColor = .white

        setupController()
    }

    func setupController() {
        let homeController = HomeController()
        let homeIcon = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "homeIcon"), tag: 0)
        homeIcon.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        homeController.tabBarItem = homeIcon

        let customWorkoutController = CustomWorkoutController()
        let customWorkoutIcon = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "gymIcon"), tag: 1)
        customWorkoutIcon.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        customWorkoutController.tabBarItem = customWorkoutIcon

        let statsController = StatisticsController()
        let statsIcon = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "statsIcon"), tag: 2)
        statsIcon.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        statsController.tabBarItem = statsIcon

        viewControllers = [homeController, customWorkoutController, statsController]
    }
}

