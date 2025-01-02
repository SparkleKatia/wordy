//
//  QuizOptionCell 2.swift
//  Wordy
//
//  Created by Kateryna on 02/01/2025.
//
import UIKit

class QuizOptionCell: UICollectionViewCell {
    
    private let wordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Style the cell background
        contentView.backgroundColor = .systemBlue
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(wordLabel)
        
        wordLabel.anchor(leading: contentView.leadingAnchor,
                         trailing: contentView.trailingAnchor,
                         paddingLeading: 8,
                         paddingTrailing: -8)
        
        wordLabel.centerX(inView: contentView)
        wordLabel.centerY(inView: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with word: Word) {
        wordLabel.text = word.text
    }
}
