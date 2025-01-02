//
//  ViewController.swift
//  Wordy
//
//  Created by Kateryna on 01/01/2025.
//

import UIKit
import CoreData

class WordsTableViewController: UITableViewController {
    
    // MARK: - properties
    var words: [Word] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - View Lifecycle Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemGreen
        appearance.titleTextAttributes = [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 20, weight: .bold)
            ]
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.tintColor = .white
        
        tableView.register(WordCellView.self, forCellReuseIdentifier: "WordCell")
        self.view.backgroundColor = .systemGroupedBackground
        self.title = "Word List"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewWord))
          
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Quiz", style: .plain, target: self, action: #selector(startQuiz))

        
        fetchAndReload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchAndReload()
    }
    
    @objc func startQuiz() {
        let quizVC = QuizViewController()
        quizVC.allWords = words
        navigationController?.pushViewController(quizVC, animated: true)
    }
    
    // MARK: - Fetch Logic
    private func fetchAndReload() {
        words = WordDataService.shared.fetchWords()
        tableView.reloadData()
    }
    
    // MARK: - Add Logic
    @objc func addNewWord() {
        var alertTextField = UITextField()
        var alertDefinitionField = UITextField()
        
        let alert = UIAlertController(title: "Add a New Word", message: "", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "New Word"
            alertTextField = textField
        }
        alert.addTextField { textField in
            textField.placeholder = "Definition"
            alertDefinitionField = textField
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            if let newWord = alertTextField.text, let definition = alertDefinitionField.text {
                WordDataService.shared.createWord(text: newWord, definition: definition)
                self.fetchAndReload()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
    
    // MARK: - Edit Logic
    func editWord(at indexPath: IndexPath) {
        let word = words[indexPath.row]
        
        let alert = UIAlertController(
            title: "Edit Word",
            message: "Update your word and definition",
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.text = word.text
        }
        alert.addTextField { textField in
            textField.text = word.definition
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard
                let self = self,
                let newWordText = alert.textFields?[0].text,
                let newDefinition = alert.textFields?[1].text
            else { return }
            
            WordDataService.shared.updateWord(word, newText: newWordText, newDefinition: newDefinition)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    // MARK: - Delete Logic
    func deleteWord(at indexPath: IndexPath) {
        let wordToDelete = words[indexPath.row]
        
        let conformationAlert = UIAlertController(title: "Delete word", message: "Are you sure you want to delete \"\(wordToDelete.text ?? "")\"?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            WordDataService.shared.deleteWord(wordToDelete)
            self.words.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            conformationAlert.dismiss(animated: true)
        }
        
        conformationAlert.addAction(deleteAction)
        conformationAlert.addAction(cancelAction)
        present(conformationAlert, animated: true)
    }
    
    // MARK: - Data Source Actions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        words.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath) as? WordCellView
        else {
            return UITableViewCell()
        }
        let word = words[indexPath.row]
        cell.configure(with: word)
        return cell
    }
    
    // MARK: - Select Actions
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedWord = words[indexPath.row]
        let wordDetailViewController = WordDetailViewController()
        wordDetailViewController.selectedWord = selectedWord
        navigationController?.pushViewController(wordDetailViewController, animated: true)
    }
    
    // MARK: - Swipe Actions
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // EDIT
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] _, _, completionHandler in
            self?.editWord(at: indexPath)
            completionHandler(true)
        }
        editAction.backgroundColor = .systemBlue
        
        // DELETE
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            self?.deleteWord(at: indexPath)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
