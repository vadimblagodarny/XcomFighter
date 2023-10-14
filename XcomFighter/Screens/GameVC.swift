//
//  GameViewController.swift
//  XcomFighter
//
//  Created by Vadim Blagodarny on 07.09.2023.
//

import UIKit

final class GameVC: UIViewController {
    
    private lazy var canyon: UIImageView = {
        let iv = UIImageView(image: Constants.Images.canyonImage)
        iv.frame = CGRect(x: 0, y: -view.frame.height, width: view.frame.width, height: view.frame.height * 2)
        iv.contentMode = .scaleToFill
        return iv
    }()

    private lazy var gameView: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - Constants.Sizes.controlsViewHeight - Constants.Sizes.controlsOffset)
        return v
    }()
    
    private lazy var fighter: UIImageView = {
        let iv = UIImageView(image: Constants.Images.fighterImage)
        iv.frame = Constants.Frames.fighterFrame
        iv.contentMode = .scaleAspectFit
        iv.layer.shadowOpacity = Constants.Sizes.unitsShadowOpacity
        iv.layer.shadowOffset = Constants.Sizes.unitsShadowOffset
        iv.isHidden = true
        return iv
    }()
    
    private lazy var closeButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(Constants.Texts.closeButtonTitle, for: .normal)
        btn.setTitleColor(.systemRed, for: .normal)
        btn.setTitleColor(.red, for: .highlighted)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        btn.addTarget(self, action: #selector(closeButtonPress), for: .touchUpInside)
        btn.backgroundColor = Constants.Colors.semiTransparent
        btn.layer.cornerRadius = Constants.Sizes.globalCornerRadius
        return btn
    }()
    
    private lazy var controlsView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        return v
    }()
    
    private lazy var moveLeftButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(Constants.Texts.moveLeftButtonTitle, for: .normal)
        btn.setTitleColor(.systemGray5, for: .normal)
        btn.setTitleColor(.white, for: .highlighted)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        btn.addTarget(self, action: #selector(moveFighterLeft), for: .touchDown)
        btn.backgroundColor = .blue
        btn.layer.cornerRadius = Constants.Sizes.globalCornerRadius
        return btn
    }()
    
    private lazy var moveRightButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(Constants.Texts.moveRightButtonTitle, for: .normal)
        btn.setTitleColor(.systemGray5, for: .normal)
        btn.setTitleColor(.white, for: .highlighted)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        btn.addTarget(self, action: #selector(moveFighterRight), for: .touchDown)
        btn.backgroundColor = .blue
        btn.layer.cornerRadius = Constants.Sizes.globalCornerRadius
        return btn
    }()
    
    private lazy var missileLaunchButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(Constants.Texts.missileLaunchButtonText, for: .normal)
        btn.setTitleColor(.systemGray5, for: .normal)
        btn.setTitleColor(.white, for: .highlighted)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        btn.addTarget(self, action: #selector(missileWillAppear), for: .touchUpInside)
        btn.backgroundColor = .red
        btn.layer.cornerRadius = Constants.Sizes.globalCornerRadius
        return btn
    }()
    
    private lazy var hitCounterLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        lbl.textColor = .blue
        lbl.text = String(Int.zero)
        lbl.backgroundColor = Constants.Colors.semiTransparent
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = Constants.Sizes.globalCornerRadius
        return lbl
    }()
    
    private lazy var crashCounterLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        lbl.textColor = .red
        lbl.text = String(Constants.Settings.fighterArmor)
        lbl.backgroundColor = Constants.Colors.semiTransparent
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = Constants.Sizes.globalCornerRadius
        return lbl
    }()
    
    private lazy var collisionTimer = Timer(timeInterval: Constants.Settings.collisionTimerInterval, repeats: true) { _ in
        self.cleanUp()
        self.collisionCheck()
    }
    
    private lazy var beamFireTimer = Timer(timeInterval: Constants.Settings.beamFireTimerInterval, repeats: true) { _ in
        self.ufos.forEach { ufo in
            let rnd = Int.random(in: 0...Constants.Settings.randomizer)
            if rnd == Constants.Settings.randomizer {
                self.beamWillAppear(ufo)
            }
        }
    }
    
    private lazy var ufoAppearTimer = Timer(timeInterval: Constants.Settings.ufoAppearTimerInterval, repeats: true) { _ in
        if Bool.random() && self.crashCounter > 0 {
            self.ufoWillAppear()
        }
    }
    
    private var hitCounter: Int = 0
    private var crashCounter: Int = Constants.Settings.fighterArmor
    private var ufos: [UIView] = []
    private var beams: [UIView] = []
    private var missiles: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        fighterWillAppear()
        RunLoop.main.add(collisionTimer, forMode: .common)
        RunLoop.main.add(ufoAppearTimer, forMode: .common)
        RunLoop.main.add(beamFireTimer, forMode: .common)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        canyonMovement()
    }
    
    private func setupViews() {
        view.addSubview(canyon)
        
        view.addSubview(gameView)
        gameView.addSubview(fighter)
        gameView.addSubview(closeButton)

        view.addSubview(controlsView)
        controlsView.addSubview(moveLeftButton)
        controlsView.addSubview(moveRightButton)
        controlsView.addSubview(missileLaunchButton)
        controlsView.addSubview(hitCounterLabel)
        controlsView.addSubview(crashCounterLabel)

        if Constants.Settings.fullScreenTapControls {
            moveLeftButton.isHidden = true
            moveRightButton.isHidden = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(tappedOnScreen))
            view.addGestureRecognizer(tap)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            hitCounterLabel.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor),
            hitCounterLabel.heightAnchor.constraint(equalTo:controlsView.heightAnchor),
            hitCounterLabel.leadingAnchor.constraint(equalTo: moveLeftButton.trailingAnchor, constant: Constants.Sizes.countersOffset),
            hitCounterLabel.trailingAnchor.constraint(equalTo: missileLaunchButton.leadingAnchor, constant: -Constants.Sizes.countersOffset),
            crashCounterLabel.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor),
            crashCounterLabel.heightAnchor.constraint(equalTo: controlsView.heightAnchor),
            crashCounterLabel.leadingAnchor.constraint(equalTo: missileLaunchButton.trailingAnchor, constant: Constants.Sizes.countersOffset),
            crashCounterLabel.trailingAnchor.constraint(equalTo: moveRightButton.leadingAnchor, constant: -Constants.Sizes.countersOffset),
            controlsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controlsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controlsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.Sizes.controlsOffset),
            controlsView.heightAnchor.constraint(equalToConstant: Constants.Sizes.controlsViewHeight),
            closeButton.leadingAnchor.constraint(equalTo: gameView.leadingAnchor, constant: Constants.Sizes.controlsOffset),
            closeButton.topAnchor.constraint(equalTo: gameView.topAnchor, constant: Constants.Sizes.controlsOffset),
            closeButton.heightAnchor.constraint(equalToConstant: Constants.Sizes.controlsViewHeight),
            closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor),
            moveLeftButton.leadingAnchor.constraint(equalTo: controlsView.leadingAnchor, constant: Constants.Sizes.controlsOffset),
            moveLeftButton.heightAnchor.constraint(equalTo: controlsView.heightAnchor),
            moveLeftButton.widthAnchor.constraint(equalTo: controlsView.heightAnchor),
            moveRightButton.trailingAnchor.constraint(equalTo: controlsView.trailingAnchor, constant: -Constants.Sizes.controlsOffset),
            moveRightButton.heightAnchor.constraint(equalTo: controlsView.heightAnchor),
            moveRightButton.widthAnchor.constraint(equalTo: controlsView.heightAnchor),
            missileLaunchButton.centerXAnchor.constraint(equalTo: controlsView.centerXAnchor),
            missileLaunchButton.heightAnchor.constraint(equalTo: controlsView.heightAnchor),
            missileLaunchButton.widthAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 2.0)
        ])
    }
    
    @objc func tappedOnScreen(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: view)
        let leftHalf = CGRect(x: 0, y: 0, width: view.frame.width / 2, height: view.frame.height)
        let rightHalf = CGRect(x: view.frame.width / 2, y: 0, width: view.frame.width / 2, height: view.frame.height)

        if leftHalf.contains(tapLocation) { moveFighterLeft() }
        if rightHalf.contains(tapLocation) { moveFighterRight() }
    }
    
    private func fighterWillAppear() {
        fighter.center.x = gameView.center.x
        fighter.frame.origin.y = gameView.frame.height - fighter.frame.height - Constants.Sizes.fighterOffset
        fighter.isHidden = false
    }

    private func ufoWillAppear() {
        let ufo: UIImageView = {
            let iv = UIImageView(image: Constants.Images.ufoImage)
            iv.frame = Constants.Frames.ufoFrame
            iv.contentMode = .scaleAspectFit
            iv.layer.shadowOpacity = Constants.Sizes.unitsShadowOpacity
            iv.layer.shadowOffset = Constants.Sizes.unitsShadowOffset
            
            let ufoXMovementBounds = Int.random(in: 0 ... Int(self.gameView.frame.width - iv.frame.width * 2 - Constants.Sizes.canyonSafeArea))

            iv.frame.origin.x = iv.frame.width + CGFloat(ufoXMovementBounds)
            iv.frame.origin.y = -iv.frame.height
            return iv
        }()
        
        gameView.addSubview(ufo)
        ufos.append(ufo)

        var ufoSpeed = Constants.Settings.ufoSpeed
        if Constants.Settings.doubleSpeedUfo { ufoSpeed *= 2 }
        
        UIView.animate(withDuration: (view.frame.height / ufo.frame.height) / ufoSpeed,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
            ufo.frame.origin.y = self.view.frame.height

            if Constants.Settings.xAxisUfoMovement {
                let ufoXMovementBounds = Int.random(in: 0 ... Int(self.gameView.frame.width - ufo.frame.width * 2 - Constants.Sizes.canyonSafeArea))
                ufo.frame.origin.x = ufo.frame.width + CGFloat(ufoXMovementBounds)
            }
        })
    }
    
    private func ufoWillDissapear(_ ufo: UIView) {
        UIView.animate(withDuration: Constants.Settings.fadeTime,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
            ufo.alpha = 0.0
        }) { _ in
            ufo.removeFromSuperview()
        }
    }
    
    @objc private func moveFighterLeft() {
        if fighter.center.x < fighter.frame.width || fighter.frame.origin.x < Constants.Sizes.canyonSafeArea { return }
        UIView.animate(withDuration: 1) {
            self.fighter.center.x = self.fighter.center.x - self.fighter.frame.width / 2
        }
    }
    
    @objc private func moveFighterRight() {
        if gameView.frame.width - fighter.center.x < fighter.frame.width || fighter.frame.origin.x > gameView.frame.width - fighter.frame.width - Constants.Sizes.canyonSafeArea { return }
        UIView.animate(withDuration: 1) {
            self.fighter.center.x = self.fighter.center.x + self.fighter.frame.width / 2
        }
    }
    
    private func fighterDamaged() {
        UIView.animate(withDuration: Constants.Settings.fadeTime,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
            self.fighter.alpha = 0.0
        })

        UIView.animate(withDuration: Constants.Settings.fadeTime,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
            self.fighter.alpha = 1.0
        })
    }

    @objc private func missileWillAppear() {
        guard let fighterPositionX = fighter.layer.presentation()?.position.x else { return }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        let missile: UIImageView = {
            let iv = UIImageView(image: Constants.Images.missileImage)
            iv.frame = Constants.Frames.missileFrame
            iv.center.x = fighterPositionX
            iv.frame.origin.y = fighter.frame.origin.y - iv.frame.height
            iv.layer.shadowOpacity = Constants.Sizes.unitsShadowOpacity
            iv.layer.shadowOffset = Constants.Sizes.unitsShadowOffset
            return iv
        }()

        gameView.addSubview(missile)
        missiles.append(missile)

        let missileSpeed = Constants.Settings.missileSpeed
        UIView.animate(withDuration: (view.frame.height / missile.frame.height) / missileSpeed,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
            missile.frame.origin.y = -missile.frame.height
        })
    }
    
    private func missileWillDissapear(_ missile: UIView) {
        UIView.animate(withDuration: Constants.Settings.fadeTime,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
            missile.alpha = 0.0
        }, completion: { _ in
            missile.removeFromSuperview()
        })
    }
    
    private func beamWillAppear(_ ufo: UIView) {
        guard let ufoPositionX = ufo.layer.presentation()?.position.x else { return }
        guard let ufoFrame = ufo.layer.presentation()?.frame else { return }

        let beam: UIImageView = {
            let iv = UIImageView(image: Constants.Images.beamImage)
            iv.frame = Constants.Frames.beamFrame
            iv.center.x = ufoPositionX
            iv.frame.origin.y = ufoFrame.origin.y + ufoFrame.height + iv.frame.height
            iv.layer.shadowOpacity = Constants.Sizes.unitsShadowOpacity
            iv.layer.shadowOffset = Constants.Sizes.unitsShadowOffset
            return iv
        }()

        gameView.addSubview(beam)
        beams.append(beam)

        var beamSpeed = Constants.Settings.beamSpeed
        if Constants.Settings.doubleSpeedUfo { beamSpeed *= 2 }

        UIView.animate(withDuration: ((view.frame.height - beam.frame.origin.y) / beam.frame.height) / beamSpeed,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
            beam.frame.origin.y = self.view.frame.height
        })
    }
    
    private func beamWillDissapear(_ beam: UIView) {
        UIView.animate(withDuration: Constants.Settings.fadeTime,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
            beam.alpha = 0.0
        }, completion: { _ in
            beam.removeFromSuperview()
        })
    }
    
    private func canyonMovement() {
        UIView.animate(withDuration: Constants.Settings.canyonMovementDuration, delay: 0, options: [.curveLinear, .repeat], animations: {
            self.canyon.frame.origin.y = self.canyon.frame.origin.y + self.view.frame.height
        }, completion: { _ in
            self.canyon.frame.origin.y = -self.view.frame.height

        })
    }
    
    private func cleanUp() {
        self.ufos.removeAll { ufo in
            !ufo.isDescendant(of: self.gameView)
        }

        self.missiles.removeAll { missile in
            !missile.isDescendant(of: self.gameView)
        }

        self.beams.removeAll { beam in
            !beam.isDescendant(of: self.gameView)
        }
    }
    
    private func collisionCheck() {
        guard let fighterFrame = fighter.layer.presentation()?.frame else { return }

        missiles.forEach { missile in
            guard let missileFrame = missile.layer.presentation()?.frame else { return }

            ufos.forEach { ufo in
                guard let ufoFrame = ufo.layer.presentation()?.frame else { return }
                
                if missileFrame.intersects(ufoFrame) {
                    hitCounter += 1
                    hitCounterLabel.text = String(hitCounter)
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    missileWillDissapear(missile)
                    ufoWillDissapear(ufo)
                }
            }

            beams.forEach { beam in
                guard let beamFrame = beam.layer.presentation()?.frame else { return }
                
                if missileFrame.intersects(beamFrame) {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    missileWillDissapear(missile)
                    beamWillDissapear(beam)
                }
            }
            
            if !missileFrame.intersects(view.frame) {
                missileWillDissapear(missile)
            }
        }
        
        beams.forEach { beam in
            guard let beamFrame = beam.layer.presentation()?.frame else { return }

            if Constants.Settings.ufoFriendlyFire {
                ufos.forEach { ufo in
                    guard let ufoFrame = ufo.layer.presentation()?.frame else { return }
                    
                    if beamFrame.intersects(ufoFrame) {
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        beamWillDissapear(beam)
                        ufoWillDissapear(ufo)
                    }
                }
            }
            
            if beamFrame.intersects(fighterFrame) {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                fighterDamaged()
                beamWillDissapear(beam)
                crashCounter -= 1
                crashCounterLabel.text = String(crashCounter)
                if crashCounter <= 0 {
                    gameOver()
                }
            }
            
            if beamFrame.origin.y > view.frame.height {
                beamWillDissapear(beam)
            }
        }
        
        ufos.forEach { ufo in
            guard let ufoFrame = ufo.layer.presentation()?.frame else { return }
            
            if ufoFrame.intersects(fighterFrame) {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                ufoWillDissapear(ufo)
                fighterDamaged()
                crashCounter -= 1
                crashCounterLabel.text = String(crashCounter)
                if crashCounter <= 0 {
                    gameOver()
                }
            }
            
            if ufoFrame.origin.y > view.frame.height {
                ufoWillDissapear(ufo)
            }
        }
    }

    private func removeObjects() {
        
        ufos.forEach { ufo in
            ufo.removeFromSuperview()
        }
        
        missiles.forEach { missile in
            missile.removeFromSuperview()
        }
        
        beams.forEach { beam in
            beam.removeFromSuperview()
        }
    }
                           
    private func gameOver() {
        removeObjects()
        
        let alert = UIAlertController(title: Constants.Texts.alertGameOverTitle, message: nil, preferredStyle: .alert)
        alert.addTextField()
        let textField = alert.textFields?[0]
        textField?.autocapitalizationType = .words
        let next = UIAlertAction(title: Constants.Texts.alertGameOverNext, style: .default) { [weak alert] (_) in
            var name = alert?.textFields?[0].text ?? ""
            if name.isEmpty { name = Constants.Texts.defaultUserName }
            self.saveScore(name: name)
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(next)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func saveScore(name: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        let date = dateFormatter.string(from: Date())
        let result = Player(date: date, name: name, score: hitCounter)
        let userDefaults = UserDefaults.standard
        let jsonDecoder = JSONDecoder()
        let jsonEncoder = JSONEncoder()
        
        if userDefaults.object(forKey: "scores") == nil {
            let firstData = try? jsonEncoder.encode(HighScore(players: [Player(date: date, name: name, score: hitCounter)]))
            userDefaults.set(firstData, forKey: "scores")
            return
        }
        
        let data = userDefaults.value(forKey: "scores") as? Data

        if let data = data {
            var decodedData = try? jsonDecoder.decode(HighScore.self, from: data)
            decodedData?.players?.append(result)
            
            let encodedData = try? jsonEncoder.encode(decodedData)
            userDefaults.set(encodedData, forKey: "scores")
        }
    }
    
    @objc private func closeButtonPress() {
        crashCounter = Int.zero
        crashCounterLabel.text = String(crashCounter)
        gameOver()
    }
}
