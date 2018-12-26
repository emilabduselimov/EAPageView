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

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        tableView1.delegate = self
        tableView1.dataSource = self

        tableView2.delegate = self
        tableView2.dataSource = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView1.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView2.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")

        let items = [EAPageItem(title: "ПН", view: tableView),
                     EAPageItem(title: "ВТ", view: tableView1),
                     EAPageItem(title: "СР", view: tableView2)]

        pageView = EAPageView(items: items)
        view.addSubview(pageView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
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

