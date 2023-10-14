//
//  ScoreViewController.swift
//  XcomFighter
//
//  Created by Vadim Blagodarny on 22.09.2023.
//

import UIKit

final class ScoreVC: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(ScoreCell.self, forCellReuseIdentifier: Constants.Other.cellId)
        tv.allowsSelection = false
        tv.dataSource = self
        tv.backgroundColor = .white
        return tv
    }()
    
    private lazy var clearScoreButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = Constants.Images.clearScoreButtonImage
        button.tintColor = .red
        button.style = .plain
        button.target = self
        button.action = #selector(clearScoreTap)
        return button
    }()
    
    private var score = HighScore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getScoreTable()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = Constants.Texts.scoreTitle
        navigationItem.rightBarButtonItems = [clearScoreButton]
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
    
    private func getScoreTable() {
        let userDefaults = UserDefaults.standard
        let jsonDecoder = JSONDecoder()
        
        guard let data = userDefaults.value(forKey: Constants.Other.settingsKey) as? Data else { return }
        
        var decodedData = try? jsonDecoder.decode(HighScore.self, from: data)
        decodedData?.players?.sort(by: { $0.score > $1.score })
        score = decodedData ?? HighScore()
    }
    
    @objc private func clearScoreTap() {
        let alert = UIAlertController(title: Constants.Texts.scoreDeleteTitle,
                                      message: Constants.Texts.scoreDeleteMessage,
                                      preferredStyle: .actionSheet)
        
        alert.addAction(
            .init(title: Constants.Texts.scoreDeleteOk, style: .destructive) { [weak self] _ in
                UserDefaults.standard.removeObject(forKey: Constants.Other.settingsKey)
                self?.score = HighScore()
                self?.tableView.reloadData()
            }
        )
        
        alert.addAction(
            .init(title: Constants.Texts.scoreDeleteCancel, style: .cancel)
        )
        
        self.present(alert, animated: true)
    }
}

extension ScoreVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        score.players?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Other.cellId, for: indexPath) as? ScoreCell
        cell?.configure(model: score.players?[indexPath.row])
        return cell ?? UITableViewCell()
    }
}
