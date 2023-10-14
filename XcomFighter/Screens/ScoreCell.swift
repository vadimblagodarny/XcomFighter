//
//  ScoreCell.swift
//  XcomFighter
//
//  Created by Vadim Blagodarny on 22.09.2023.
//

import UIKit

final class ScoreCell: UITableViewCell {

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        return label
    }()

    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError(Constants.Other.coderError)
    }

    private func setupCell() {
        addSubview(dateLabel)
        addSubview(nameLabel)
        addSubview(scoreLabel)
    }
    
    private func setupConstraints() {
        dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Sizes.customCellLeadingTrailingOffset).isActive = true
        dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.Sizes.customCellTopBottomOffset).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.Sizes.customCellTopBottomOffset).isActive = true
        
        nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.Sizes.customCellTopBottomOffset).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.Sizes.customCellTopBottomOffset).isActive = true

        scoreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Sizes.customCellLeadingTrailingOffset).isActive = true
        scoreLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.Sizes.customCellTopBottomOffset).isActive = true
        scoreLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.Sizes.customCellTopBottomOffset).isActive = true
    }

    func configure(model: Player?) {
        dateLabel.text = model?.date
        nameLabel.text = model?.name
        scoreLabel.text = model?.score.description
    }
}
