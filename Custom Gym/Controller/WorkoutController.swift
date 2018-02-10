//
//  WorkoutController.swift
//  Custom Gym
//
//  Created by Joe Rivard on 1/15/18.
//  Copyright © 2018 Joe Rivard. All rights reserved.
//

import UIKit

class WorkoutController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    // MARK: - Actions

    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }

    @objc func handleSave() {

    }

    // MARK: Views

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.allowsSelection = false
        return tv
    }()
}
