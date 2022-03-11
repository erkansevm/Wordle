//
//  ViewController.swift
//  Wordle
//
//  Created by Erkan Sevim on 10.03.2022.
//

import UIKit

class ViewController: UIViewController {
    let answers = [
        "after",
        "later",
        "water",
        "charm",
        "adult",
        "agent",
        "apple",
        "award",
        "bread",
        "board",
        "cause",
        "chest",
        "china",
        "depth",
        "doubt",
        "enemy",
        "event",
        "faith",
        "fault",
        "glass",
        "group",
        "heart",
        "light",
        "major",
        "north",
        "order",
    ]
    
    var answer = ""
    private var guesses: [[Character?]] = Array(repeating: Array(repeating: nil, count: 5), count: 6)

    let keyboardVC = KeyboardViewController()
    let boardVc = BoardViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        answer = answers.randomElement() ?? "after"
        view.backgroundColor = .systemGray6
        addChildren()
    }
    
    func addChildren() {
        addChild(keyboardVC)
        keyboardVC.didMove(toParent: self)
        keyboardVC.delegate = self
        keyboardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardVC.view)
        
        addChild(boardVc)
        boardVc.didMove(toParent: self)
        boardVc.datasource = self
        boardVc.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boardVc.view)
        
        addConstraints()
    }

    func addConstraints(){
        NSLayoutConstraint.activate([
            boardVc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            boardVc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            boardVc.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            boardVc.view.bottomAnchor.constraint(equalTo: keyboardVC.view.topAnchor),
            boardVc.view.heightAnchor.constraint(equalTo:view.heightAnchor, multiplier: 0.6),
            
            keyboardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}



extension ViewController: KeyboardViewControllerDelegate {
    func keyboardViewController(_ vc: KeyboardViewController, didTapKey letter: Character) {
        var stop = false
        
        for i in 0..<guesses.count {
            for j in 0..<guesses[i].count{
                if guesses[i][j] == nil {
                    guesses[i][j] = letter
                    stop = true
                    break
                }
            }
            if stop {
                break
            }
        }
        
        
        boardVc.reloadData()
    }
}

extension ViewController: BoardViewControllerDatasource {
    var currentGuesses: [[Character?]] {
        return guesses
    }
    
    func boxColor(at indexPath: IndexPath) -> UIColor? {
        let rowIndex = indexPath.section
        
        let count = guesses[rowIndex].compactMap({ $0 }).count
        guard count == 5 else {
            return nil
        }
        let indexedAnswer = Array(answer)
        
        guard let letter = guesses[indexPath.section][indexPath.row],
              indexedAnswer.contains(letter) else {
            return nil
        }
        
        if indexedAnswer[indexPath.row] == letter {
            return .systemGreen
        }
        
        
        
        return .systemOrange
    }
    
}
