//
//  EggsSecondViewController.swift
//  EggApp
//
//  Created by Нахид Гаджалиев on 22.01.2023.
//

import UIKit
import AVFoundation

class EggsSecondViewController: UIViewController {
    
    let eggTimes = ["Soft": 5, "Medium": 7, "Hard": 12]
    var timer = Timer()
    var player = AVAudioPlayer()
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        guard let hardness = sender.titleLabel?.text else { return }
        guard let eggTime = eggTimes[hardness] else { return }
        
        timer.invalidate()
        self.progressView.progress = 0.0
        var timerTimeSeconds = Double(eggTime)
        let plusTime = 1.0 / timerTimeSeconds
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if timerTimeSeconds > 0 {
                self.timerLabel.text = "Your choice is \(hardness), please wait"
                timerTimeSeconds -= 1
                self.progressView.progress += Float(plusTime)
            } else {
                timer.invalidate()
                self.timerLabel.text = "Bon appetit! 🥳"
                self.playSound()
            }
        }
        
    }
    
    func playSound() {
        
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
    
}
