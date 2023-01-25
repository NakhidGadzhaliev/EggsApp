//
//  ViewController.swift
//  EggApp
//
//  Created by Нахид Гаджалиев on 22.01.2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var player = AVAudioPlayer()
    let progressView = UIProgressView()
    var timer = Timer()
    
    let eggTimes = ["Soft": 300, "Medium": 420, "Hard": 720]
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "How do you like eggs?"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 30)
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var topView: UIView = {
        let viewTop = UIView()
        viewTop.addSubview(titleLabel)
        return viewTop
    }()
    
    let softEggButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "soft_egg"), for: .normal)
        button.setTitle("Soft", for: .normal)
        
        return button
    }()
    
    lazy var softEggView: UIView = {
        let softView = UIView()
        softEggButton.center = softView.center
        softView.addSubview(softEggButton)
        
        return softView
    }()
    
    let mediumEggButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "medium_egg"), for: .normal)
        button.setTitle("Medium", for: .normal)
        
        return button
    }()
    
    lazy var mediumEggView: UIView = {
        let mediumView = UIView()
        mediumView.addSubview(mediumEggButton)
        
        return mediumView
    }()
    
    let hardEggButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "hard_egg"), for: .normal)
        button.setTitle("Hard", for: .normal)
        
        return button
    }()
    
    lazy var hardEggView: UIView = {
        let hardView = UIView()
        hardView.addSubview(hardEggButton)
        
        return hardView
    }()
    
    lazy var eggsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [softEggView, mediumEggView, hardEggView])
        stack.spacing = 5
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        return stack
    }()
    
    lazy var timerView: UIView = {
        let viewBottom = UIView()
        viewBottom.addSubview(progressView)
        
        return viewBottom
    }()
    
    lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [topView, eggsStack, timerView])
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fillEqually
        
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewUpdates()
        setupConstraints()
    }
    
    private func viewUpdates() {
        view.backgroundColor = UIColor(named: "eggsBackgroundColor")
        view.addSubview(mainStack)
    }
    
    @objc private func timerAction(sender: UIButton) {
        guard let hardness = sender.titleLabel?.text else { return }
        guard let eggTime = eggTimes[hardness] else { return }
        
        timer.invalidate()
        self.progressView.progress = 0.0
        var timerTimeSeconds = Double(eggTime)
        let plusTime = 1.0 / timerTimeSeconds
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if timerTimeSeconds > 0 {
                self.titleLabel.text = "Your choice is \(hardness), please wait"
                timerTimeSeconds -= 1
                self.progressView.progress += Float(plusTime)
            } else {
                timer.invalidate()
                self.titleLabel.text = "Bon appetit! 🥳"
                self.playSound()
            }
        }
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        imageConstraints(button: softEggButton, toView: softEggView)
        imageConstraints(button: mediumEggButton, toView: mediumEggView)
        imageConstraints(button: hardEggButton, toView: hardEggView)
        
        NSLayoutConstraint.activate([
            
            mainStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStack.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            
            titleLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            
            progressView.centerYAnchor.constraint(equalTo: timerView.centerYAnchor),
            progressView.centerXAnchor.constraint(equalTo: timerView.centerXAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 5),
            progressView.widthAnchor.constraint(equalToConstant: 300),
            
        ])
    }
    
    private func playSound() {
        
        guard let path = Bundle.main.path(forResource: "alarm_sound", ofType: "mp3") else {
            return }
        let url = URL(fileURLWithPath: path)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func imageConstraints(button: UIButton, toView: UIView) {
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(timerAction(sender: )), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: toView.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: toView.centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: 120),
            button.widthAnchor.constraint(equalToConstant: 110)
        ])
        
    }
    
}

