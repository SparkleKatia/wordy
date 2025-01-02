//
//  WordCell.swift
//  Wordy
//
//  Created by Kateryna on 02/01/2025.
//

import UIKit

class WordCellView: UITableViewCell {
    // MARK: - Subviews
    let wordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    let definitionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add subviews
        contentView.addSubview(wordLabel)
        contentView.addSubview(definitionLabel)
        
        // Layout constraints
        wordLabel.anchor(top: contentView.topAnchor,
                         leading: contentView.leadingAnchor,
                         trailing: contentView.trailingAnchor,
                         paddingTop: 8,
                         paddingLeading: 16,
                         paddingTrailing: -16)
        
        definitionLabel.anchor(top: wordLabel.bottomAnchor,
                               bottom: contentView.bottomAnchor,
                               leading: wordLabel.leadingAnchor,
                               trailing: wordLabel.trailingAnchor,
                               paddingTop: 4,
                               paddingBottom: -8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    func configure(with word: Word) {
        wordLabel.text = word.text
        // Show short snippet if definition is long
        if let definition = word.definition, !definition.isEmpty {
            definitionLabel.text = definition.count > 50
                ? String(definition.prefix(50)) + "..."
                : definition
        } else {
            definitionLabel.text = "No definition"
        }
    }
}
