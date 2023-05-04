//
//  HistoryViewController.swift
//  BrowserPrototypeTestApp
//
//  Created by Dmitriy Lukyanov on 04.05.2023.
//

import UIKit

class HistoryViewController: UIViewController, Coordinating {
    var coordinator: Coordinator?
    let container: DIContainer
    var dataSourceTable: [String] = []
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        table.separatorColor = .black
        return table
    }()
    
    init(container: DIContainer, coordinator: Coordinator? = nil) {
        self.container = container
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "History"
        
        setupTableView()
        
        let clearBtn = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearBtnPressed))
        navigationItem.rightBarButtonItem = clearBtn
        
        let data = container.appState[\.historyState]
        dataSourceTable = Array(data.reversed())
        
        tableView.register(HistoryCell.self, forCellReuseIdentifier: "HistoryCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc func clearBtnPressed() {
        container.appState[\.historyState] = []
        dataSourceTable = []
        tableView.reloadData()
    }
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSourceTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryCell else {
            fatalError("Cannot create cell for History table")
        }
        
        cell.configure(title: dataSourceTable[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        container.appState[\.selectedUrl] = dataSourceTable[indexPath.row]
        coordinator?.eventOccured(with: .goToMainVC)
    }
}

extension HistoryViewController {
    func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
}
