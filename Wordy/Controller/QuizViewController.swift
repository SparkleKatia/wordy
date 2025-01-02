import UIKit

class QuizViewController: UIViewController {

    var allWords: [Word] = []

    private var currentOptions: [Word] = []
    
    private var correctWord: Word?

    private let definitionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        return label
    }()
    
    private var collectionView: UICollectionView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Quiz"
        view.backgroundColor = .systemBackground
        
        setupDefinitionLabel()
        setupCollectionView()
        
        generateNewQuestion()
    }
    
    // MARK: - Setup UI
    private func setupDefinitionLabel() {
        view.addSubview(definitionLabel)
        definitionLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                               leading: view.leadingAnchor,
                               trailing: view.trailingAnchor,
                               paddingTop: 20,
                               paddingLeading: 16,
                               paddingTrailing: -16)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
        collectionView.register(QuizOptionCell.self, forCellWithReuseIdentifier: "QuizOptionCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        collectionView.anchor(top: definitionLabel.bottomAnchor,
                              bottom: view.bottomAnchor,
                              leading: view.leadingAnchor,
                              trailing: view.trailingAnchor,
                              paddingTop: 20,
                              paddingLeading: 16,
                              paddingTrailing: -16)
    }
    
    // MARK: - Generate Question
    private func generateNewQuestion() {
        guard !allWords.isEmpty else {
            definitionLabel.text = "No words available."
            currentOptions = []
            collectionView.reloadData()
            return
        }
        
        let correctIndex = Int.random(in: 0..<allWords.count)
        let correct = allWords[correctIndex]
        correctWord = correct
        
        definitionLabel.text = correct.definition
        
        var optionsSet = Set<Word>()
        optionsSet.insert(correct)
        
        while optionsSet.count < 4 && optionsSet.count < allWords.count {
            let randomIndex = Int.random(in: 0..<allWords.count)
            optionsSet.insert(allWords[randomIndex])
        }
        
        currentOptions = Array(optionsSet).shuffled()
        collectionView.reloadData()
    }
    
    // MARK: - Handle Answer
    private func handleAnswerSelection(_ word: Word, at indexPath: IndexPath) {
        let isCorrect = (word == correctWord)
        
        let title = isCorrect ? "Correct!" : "Wrong!"
        let message = isCorrect
            ? "You chose the right word."
            : "The correct word was \"\(correctWord?.text ?? "")\"."
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let nextAction = UIAlertAction(title: "Next", style: .default) { _ in
            self.generateNewQuestion()
        }
        alert.addAction(nextAction)
        present(alert, animated: true)
    }
}

extension QuizViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuizOptionCell",
                                                            for: indexPath) as? QuizOptionCell else {
            return UICollectionViewCell()
        }
        
        let word = currentOptions[indexPath.item]
        cell.configure(with: word)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedWord = currentOptions[indexPath.item]
        handleAnswerSelection(selectedWord, at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalSpacing: CGFloat = 16
        let availableWidth = collectionView.bounds.width - totalSpacing
        let width = availableWidth / 2.0
        
        return CGSize(width: width, height: 80)
    }
}
