//
//  SettingsVC.swift
//  XcomFighter
//
//  Created by Vadim Blagodarny on 26.09.2023.
//

import UIKit

final class SettingsVC: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(SettingsCell.self, forCellReuseIdentifier: Constants.Other.cellId)
        tv.allowsSelection = false
        tv.dataSource = self
        tv.backgroundColor = .white
        return tv
    }()
    
    private var settings = [
        Settings(parameterName: Constants.Texts.settingsFullScreenTapControls, parameterValue: Constants.Settings.fullScreenTapControls),
        Settings(parameterName: Constants.Texts.settingsDoubleSpeedUfo, parameterValue: Constants.Settings.doubleSpeedUfo),
        Settings(parameterName: Constants.Texts.settingsXaxisUfoMovement, parameterValue: Constants.Settings.xAxisUfoMovement),
        Settings(parameterName: Constants.Texts.settingsUfoFriendlyFire, parameterValue: Constants.Settings.ufoFriendlyFire)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = Constants.Texts.settingsTitle
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension SettingsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Other.cellId, for: indexPath) as? SettingsCell
        cell?.configure(model: settings[indexPath.row])
        return cell ?? UITableViewCell()
    }

}
