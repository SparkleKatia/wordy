//
//  WordDetailViewController.swift
//  Wordy
//
//  Created by Kateryna on 01/01/2025.
//

import UIKit

class WordDetailViewController: UIViewController {
    
    //MARK: - Properties
    var selectedWord: Word?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let definitionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 4
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        view.backgroundColor = UIColor.systemGray6
        setupLayout()
        
        title = selectedWord?.text
         
         definitionLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
         definitionLabel.textColor = .darkGray
         
         if let word = selectedWord {
             definitionLabel.text = word.definition
         }
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
            image: UIImage(systemName: "pencil"),
            style: .plain,
            target: self,
            action: #selector(editWord)
        ),
         UIBarButtonItem(
         image: UIImage(systemName: "trash"), 
         style: .plain,
         target: self,
         action: #selector(deleteWord)
         )
        ]
    }
    
    private func setupLayout() {
        view.addSubview(cardView)
        cardView.addSubview(definitionLabel)
        
        cardView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                        leading: view.leadingAnchor,
                        trailing: view.trailingAnchor,
                        paddingTop: 20,
                        paddingLeading: 16,
                        paddingTrailing: -16)
        definitionLabel.anchor(top: cardView.topAnchor,
                               bottom: cardView.bottomAnchor,
                               leading: cardView.leadingAnchor,
                               trailing: cardView.trailingAnchor,
                               paddingTop: 16,
                               paddingBottom: -16,
                               paddingLeading: 16,
                               paddingTrailing: -16)
    }
    
    //MARK: - Edit Action
    @objc func editWord() {
        guard let word = selectedWord else { return }
        
        var wordField = UITextField()
        var definitionField = UITextField()
        
        let alert = UIAlertController(title: "Edit Word", message: "Update your word and definition", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = word.text
            wordField = textField
        }
        
        alert.addTextField { textField in
            textField.text = word.definition
            definitionField = textField
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            guard let newWordText = wordField.text,
                  let newDefinition = definitionField.text
            else { return }
            
            WordDataService.shared.updateWord(word, newText: newWordText, newDefinition: newDefinition)
            
            self.title = newWordText
            self.definitionLabel.text = newDefinition
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    //MARK: - Delete Action
    @objc func deleteWord() {
        guard let word = selectedWord else { return }
        
        let conformationAlert = UIAlertController(title: "Delete word", message: "Are you sure you want to delete \"\(word.text ?? "")\"?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            WordDataService.shared.deleteWord(word)
            self.navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            conformationAlert.dismiss(animated: true)
        }
        
        conformationAlert.addAction(deleteAction)
        conformationAlert.addAction(cancelAction)
        present(conformationAlert, animated: true)
    }
}
