//
//  Constants.swift
//  XcomFighter
//
//  Created by Vadim Blagodarny on 21.09.2023.
//

import Foundation
import UIKit

enum Constants {
    enum Texts {
        static let closeButtonTitle: String = "ⓧ"
        static let moveLeftButtonTitle: String = "◀"
        static let moveRightButtonTitle: String = "▶"
        static let missileLaunchButtonText: String = "ATTACK"
        static let alertGameOverTitle: String = "GAME 👽 OVER\nThe Earth is ours\nWhat was your name?"
        static let alertGameOverNext: String = "Next"
        static let startButtonText: String = "Start"
        static let settingsButtonText: String = "Settings"
        static let scoreTitle: String = "Leaderboard"
        static let defaultUserName: String = "Anonymous"
        static let scoreDeleteTitle: String = "Erase the leaderboard"
        static let scoreDeleteMessage: String = "Are you sure?"
        static let scoreDeleteOk: String = "Ok"
        static let scoreDeleteCancel: String = "Cancel"
        static let settingsTitle: String = "Settings"
        static let settingsFullScreenTapControls: String = "Full Screen Tap Controls"
        static let settingsDoubleSpeedUfo: String = "Double UFO Speed"
        static let settingsXaxisUfoMovement: String = "X-Axis UFO Movement"
        static let settingsUfoFriendlyFire: String = "UFO Friendly Fire"
    }
    
    enum Images {
        static let ufoImage = UIImage(named: "UFO")
        static let fighterImage = UIImage(named: "Fighter")
        static let canyonImage = UIImage(named: "Canyon")
        static let beamImage = UIImage(named: "UFObeam")
        static let missileImage = UIImage(named: "FighterMissile")
        static let clearScoreButtonImage = UIImage(systemName: "xmark.square")
    }
    
    enum Frames {
        static let ufoFrame = CGRect(x: 0, y: 0, width: 100, height: 36)
        static let beamFrame = CGRect(x: 0, y: 0, width: 10, height: 30)
        static let fighterFrame = CGRect(x: 0, y: 0, width: 80, height: 88)
        static let missileFrame = CGRect(x: 0, y: 0, width: 10, height: 60)
    }
    
    enum Sizes {
        static let unitsShadowOffset = CGSize(width: 10.0, height: 10.0)
        static let unitsShadowOpacity: Float = 0.3
        static let controlsViewHeight: CGFloat = 50.0
        static let canyonSafeArea: CGFloat = 60.0
        static let fighterOffset: CGFloat = 30.0
        static let controlsOffset: CGFloat = 40.0
        static let countersOffset: CGFloat = 10.0
        static let mainMenuButtonWidth: CGFloat = 150.0
        static let mainMenuButtonHeight: CGFloat = 50.0
        static let mainMenuButtonOffset: CGFloat = 75.0
        static let globalCornerRadius: CGFloat = 8.0
        static let customCellTopBottomOffset: CGFloat = 10.0
        static let customCellLeadingTrailingOffset: CGFloat = 20.0
    }
    
    enum Colors {
        static let semiTransparent: UIColor = UIColor(white: 1.0, alpha: 0.5)
    }
    
    enum Settings {
        static let ufoSpeed: CGFloat = 2.0
        static let beamSpeed: CGFloat = 5.0
        static let missileSpeed: CGFloat = 4.0
        static let canyonMovementDuration = 30.0
        static let randomizer: Int = 5
        static let fadeTime: CGFloat = 0.1
        static var fighterArmor: Int = 5
        static var collisionTimerInterval = 0.2
        static var beamFireTimerInterval = 1.0
        static var ufoAppearTimerInterval = 2.0
        
        static var fullScreenTapControls: Bool = false
        static var doubleSpeedUfo: Bool = false
        static var xAxisUfoMovement: Bool = true
        static var ufoFriendlyFire: Bool = true
    }
    
    enum SettingsKeys {
        static let fullScreenTapControls = "fullScreenTapControls"
        static let doubleSpeedUfo = "doubleSpeedUfo"
        static let xAxisUfoMovement = "xAxisUfoMovement"
        static let ufoFriendlyFire = "ufoFriendlyFire"
    }
    
    enum Other {
        static let coderError = "init(coder:) has not been implemented"
        static let cellId = "CellId"
        static let settingsKey = "scores"
    }
}
