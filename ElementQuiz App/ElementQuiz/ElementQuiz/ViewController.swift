//
//  ViewController.swift
//  ElementQuiz
//
//  Created by Administrator on 8/18/22.
//

import UIKit

enum Mode {
    case flashCard
    case quiz
}

enum State {
    case question
    case answer
    case score
}



class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var modeSelector: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var showAnswerButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    
    let fixedElementList = ["Carbon", "Gold", "Chlorine", "Sodium"]
    var elementList: [String] = []
    
    var currentElementIndex = 0
    
    var mode: Mode = .flashCard {
        didSet {
            updateUI()
        }
    }

    var state: State = .question
    
    // Quiz-specific state
    var answerIsCorrect = false
    var correctAnswerCount = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mode = .flashCard

    }
    
    // Updates the app's UI in flash card mode.
    func updateFlashCardUI(elementName: String) {
        // Text field and keyboard
        textField.isHidden = true
        textField.resignFirstResponder()
        
        // Buttons
        showAnswerButton.isHidden = false
        nextButton.isEnabled = true
        nextButton.setTitle("Next Element", for: .normal)
        
        // Answer label
        if state == .answer {
            answerLabel.text = elementName
        } else {
            answerLabel.text = "?"
        }
    }
    
    // Updates the app's UI in quiz mode.
    func updateQuizUI(elementName: String) {
        // Text field and keyboard
        textField.isHidden = false
        switch state {
        case .question:
            textField.isEnabled = true
            textField.text = ""
            textField.becomeFirstResponder()
        case .answer:
            textField.isEnabled = false
            textField.resignFirstResponder()
        case .score:
            textField.isHidden = true
            textField.resignFirstResponder()
        }

        
        // Buttons
        showAnswerButton.isHidden = true
        if currentElementIndex == elementList.count - 1 {
            nextButton.setTitle("Show Score", for: .normal)
        } else {
            nextButton.setTitle("Next Question", for: .normal)
        }
        switch state {
        case .question:
            nextButton.isEnabled = false
        case .answer:
            nextButton.isEnabled = true
        case .score:
            nextButton.isEnabled = false
        }

        
        switch state {
            case .score:
                textField.isHidden = true
                textField.resignFirstResponder()
           case .question:
               textField.text = ""
               textField.becomeFirstResponder()
           case .answer:
               textField.resignFirstResponder()
           }
        
        // Answer label
        switch state {
        case .score:
            answerLabel.text = "❌\nCorrect Answer: " + elementName
            print("Your score is \(correctAnswerCount) out of \(elementList.count).")
        case .question:
            answerLabel.text = ""
        case .answer:
            if answerIsCorrect {
                answerLabel.text = "Correct!"
            } else {
                answerLabel.text = "❌"
            }
            
            
            // Segmented control
            modeSelector.selectedSegmentIndex = 0
        }
    }
    
    // Updates the app's UI based on its mode and state.
    func updateUI() {
        let elementName = fixedElementList[currentElementIndex]
        let image = UIImage(named: elementName)
        imageView.image = image
        // Segmented control
        modeSelector.selectedSegmentIndex = 1

        switch mode {
        case .flashCard:
            updateFlashCardUI(elementName: elementName)
        case .quiz:
            updateQuizUI(elementName: elementName)
        }
    }
    
    // Runs after the user hits the Return key on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Get the text from the text field
        let textFieldContents = textField.text!

        // Determine whether the user answered correctly and update appropriate quiz
        // state
        if textFieldContents.lowercased() == elementList[currentElementIndex].lowercased() {
            
            if answerIsCorrect {
                print("Correct!")
            } else {
                print("❌")
            }

        }

        // The app should now display the answer to the user
        state = .answer

        updateUI()

        return true
    }
    
    // Shows an iOS alert with the user's quiz score.
    func displayScoreAlert() {
        let alert = UIAlertController(title: "Quiz Score", message: "Your score is \(correctAnswerCount) out of \(elementList.count).", preferredStyle: .alert)

        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: scoreAlertDismissed(_:))
        alert.addAction(dismissAction)

        present(alert, animated: true, completion: nil)
    }

    func scoreAlertDismissed(_ action: UIAlertAction) {
        mode = .flashCard
    }

    // Sets up a new flash card session.
    func setupFlashCards() {
        
        state = .question
        currentElementIndex = 0
        elementList = fixedElementList

    }

    // Sets up a new quiz.
    func setupQuiz() {
        state = .question
        currentElementIndex = 0
        answerIsCorrect = false
        correctAnswerCount = 0
        elementList = fixedElementList.shuffled()

    }
    
    

    @IBAction func showAnswer(_ sender: Any) {
    
        updateUI()
        
    }
    
    @IBAction func next(_ sender: Any) {
    
        currentElementIndex += 1
        if currentElementIndex >= elementList.count {
            currentElementIndex = 0
            if mode == .quiz {
                state = .score
                updateUI()
                return
            }
        }
    }
    
    @IBAction func switchModes(_ sender: Any) {
        if modeSelector.selectedSegmentIndex == 0 {
            mode = .flashCard
        } else {
            mode = .quiz
        }

    }

}
