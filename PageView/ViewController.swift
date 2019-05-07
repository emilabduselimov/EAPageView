//
//  ViewController.swift
//  PageView
//
//  Created by Emil Abduselimov on 06.10.2018.
//  Copyright © 2018 Emil Abduselimov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var pageView = EAPageView(frame: .zero)

    private let tableView = UITableView(frame: .zero)
    private let tableView1 = UITableView(frame: .zero)
    private let tableView2 = UITableView(frame: .zero)
    private let tableView3 = UITableView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        pageView.translatesAutoresizingMaskIntoConstraints = false

        tableView.delegate = self
        tableView.dataSource = self

        tableView1.delegate = self
        tableView1.dataSource = self

        tableView2.delegate = self
        tableView2.dataSource = self

        tableView3.delegate = self
        tableView3.dataSource = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView1.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView2.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView3.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")

        tableView.tableFooterView = UIView()
        tableView1.tableFooterView = UIView()
        tableView2.tableFooterView = UIView()

        pageView.add(item: EAPageItem(title: "Monday", view: tableView))
        pageView.add(item: EAPageItem(title: "Tuesday", view: tableView1))
        pageView.add(item: EAPageItem(title: "Wednesdayadfjlkjdalkdjsalkjsdl", view: tableView2))
        pageView.add(item: EAPageItem(title: "Thursday", view: tableView3))
        view.addSubview(pageView)

        NSLayoutConstraint.activate([pageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     pageView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                     pageView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                     pageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = "index - \(indexPath.row)"
        return cell
    }

}

