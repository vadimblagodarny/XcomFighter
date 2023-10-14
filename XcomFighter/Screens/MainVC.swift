//
//  MainViewController.swift
//  XcomFighter
//
//  Created by Vadim Blagodarny on 22.09.2023.
//

import UIKit

final class MainVC: UIViewController {
    
    private lazy var startButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(Constants.Texts.startButtonText, for: .normal)
        btn.addTarget(self, action: #selector(startTheGame), for: .touchUpInside)
        btn.backgroundColor = .brown
        btn.layer.cornerRadius = Constants.Sizes.globalCornerRadius
        btn.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .bold)
        btn.setTitleColor(.systemGray5, for: .normal)
        btn.setTitleColor(.white, for: .highlighted)
        return btn
    }()
    
    private lazy var settingsButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(Constants.Texts.settingsButtonText, for: .normal)
        btn.addTarget(self, action: #selector(settingsScreen), for: .touchUpInside)
        btn.backgroundColor = .brown
        btn.layer.cornerRadius = Constants.Sizes.globalCornerRadius
        btn.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .bold)
        btn.setTitleColor(.systemGray5, for: .normal)
        btn.setTitleColor(.white, for: .highlighted)
        return btn
    }()
    
    private lazy var scoreButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(Constants.Texts.scoreTitle, for: .normal)
        btn.addTarget(self, action: #selector(leaderboardScreen), for: .touchUpInside)
        btn.backgroundColor = .brown
        btn.layer.cornerRadius = Constants.Sizes.globalCornerRadius
        btn.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .bold)
        btn.setTitleColor(.systemGray5, for: .normal)
        btn.setTitleColor(.white, for: .highlighted)
        return btn
    }()
    
    private lazy var canyon: UIImageView = {
        let iv = UIImageView(image: Constants.Images.canyonImage)
        iv.frame = CGRect(x: 0, y: -view.frame.height, width: view.frame.width, height: view.frame.height * 2)
        iv.contentMode = .scaleToFill
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        restoreSettings()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        canyonMovement()
    }

    private func setupViews() {
        view.addSubview(canyon)
        view.addSubview(startButton)
        view.addSubview(settingsButton)
        view.addSubview(scoreButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            settingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            settingsButton.widthAnchor.constraint(equalToConstant: Constants.Sizes.mainMenuButtonWidth),
            settingsButton.heightAnchor.constraint(equalToConstant: Constants.Sizes.mainMenuButtonHeight),
            
            startButton.centerXAnchor.constraint(equalTo: settingsButton.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: settingsButton.centerYAnchor, constant: -Constants.Sizes.mainMenuButtonOffset),
            startButton.widthAnchor.constraint(equalToConstant: Constants.Sizes.mainMenuButtonWidth),
            startButton.heightAnchor.constraint(equalToConstant: Constants.Sizes.mainMenuButtonHeight),
            
            scoreButton.centerXAnchor.constraint(equalTo: settingsButton.centerXAnchor),
            scoreButton.centerYAnchor.constraint(equalTo: settingsButton.centerYAnchor, constant: Constants.Sizes.mainMenuButtonOffset),
            scoreButton.widthAnchor.constraint(equalToConstant: Constants.Sizes.mainMenuButtonWidth),
            scoreButton.heightAnchor.constraint(equalToConstant: Constants.Sizes.mainMenuButtonHeight)
        ])
    }
    
    private func restoreSettings() {
        Constants.Settings.fullScreenTapControls = UserDefaults.standard.bool(forKey: Constants.SettingsKeys.fullScreenTapControls)
        Constants.Settings.doubleSpeedUfo = UserDefaults.standard.bool(forKey: Constants.SettingsKeys.doubleSpeedUfo)
        Constants.Settings.xAxisUfoMovement = UserDefaults.standard.bool(forKey: Constants.SettingsKeys.xAxisUfoMovement)
        Constants.Settings.ufoFriendlyFire = UserDefaults.standard.bool(forKey: Constants.SettingsKeys.ufoFriendlyFire)
    }
    
    private func canyonMovement() {
        UIView.animate(withDuration: Constants.Settings.canyonMovementDuration, delay: 0, options: [.curveLinear, .repeat], animations: {
            self.canyon.frame.origin.y = self.canyon.frame.origin.y + self.view.frame.height
        }, completion: { finished in
            self.canyon.frame.origin.y = -self.view.frame.height
        })
    }
    
    @objc private func startTheGame() {
        let vc = GameVC()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func settingsScreen() {
        let vc = SettingsVC()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func leaderboardScreen() {
        let vc = ScoreVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}
