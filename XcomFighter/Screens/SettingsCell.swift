//
//  SettingsCell.swift
//  XcomFighter
//
//  Created by Vadim Blagodarny on 26.09.2023.
//

import UIKit

final class SettingsCell: UITableViewCell {

    private lazy var parameterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var parameterSwitch: UISwitch = {
        let sw = UISwitch(frame: .zero)
        sw.addTarget(self, action: #selector(switchAction), for: .valueChanged)
        return sw
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryView = parameterSwitch
        setupCell()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError(Constants.Other.coderError)
    }

    @objc private func switchAction(_ sender: UISwitch) {
        switch parameterLabel.text {
        case Constants.Texts.settingsFullScreenTapControls:
            Constants.Settings.fullScreenTapControls = sender.isOn
            UserDefaults.standard.set(sender.isOn, forKey: Constants.SettingsKeys.fullScreenTapControls)
        case Constants.Texts.settingsDoubleSpeedUfo:
            Constants.Settings.doubleSpeedUfo = sender.isOn
            UserDefaults.standard.set(sender.isOn, forKey: Constants.SettingsKeys.doubleSpeedUfo)
        case Constants.Texts.settingsXaxisUfoMovement:
            Constants.Settings.xAxisUfoMovement = sender.isOn
            UserDefaults.standard.set(sender.isOn, forKey: Constants.SettingsKeys.xAxisUfoMovement)
        case Constants.Texts.settingsUfoFriendlyFire:
            Constants.Settings.ufoFriendlyFire = sender.isOn
            UserDefaults.standard.set(sender.isOn, forKey: Constants.SettingsKeys.ufoFriendlyFire)
        case .none:
            print()
        case .some(_):
            print()
        }
    }
    
    private func setupCell() {
        addSubview(parameterLabel)
    }
    
    private func setupConstraints() {
        parameterLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Sizes.customCellLeadingTrailingOffset).isActive = true
        parameterLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.Sizes.customCellTopBottomOffset).isActive = true
        parameterLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.Sizes.customCellTopBottomOffset).isActive = true
        parameterLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    func configure(model: Settings) {
        parameterLabel.text = model.parameterName
        parameterSwitch.isOn = model.parameterValue
    }
}
