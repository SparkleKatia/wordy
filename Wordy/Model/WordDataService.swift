//
//  WordDataService.swift
//  Wordy
//
//  Created by Kateryna on 02/01/2025.
//

import UIKit
import CoreData

class WordDataService {
    
    static let shared = WordDataService()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchWords() -> [Word] {
        let request: NSFetchRequest<Word> = Word.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching words: \(error)")
            return []
        }
    }
    
    @discardableResult
    func createWord(text: String, definition: String) -> Word? {
        let newWord = Word(context: context)
        newWord.text = text
        newWord.definition = definition
        do {
            try context.save()
            return newWord
        } catch {
            print("Error saving new word: \(error)")
            return nil
        }
    }
    
    func updateWord(_ word: Word, newText: String, newDefinition: String) {
        word.text = newText
        word.definition = newDefinition
        
        do {
            try context.save()
        } catch {
            print("Error updating word: \(error)")
        }
    }
    
    func deleteWord(_ word: Word) {
        context.delete(word)
        do {
            try context.save()
        } catch {
            print("Error deleting word: \(error)")
        }
    }
}
