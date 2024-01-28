//
//  ViewController.swift
//  EggTimer
//
//  Created by Oko-osi Korede on 28/01/2024.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    let eggTime: [String: Float] = [
        "Soft": 3,
        "Medium": 4,
        "Hard": 7
    ]
    var secondsPassed: Float = 0
    var timer = Timer()
    var totalTime: Float = 0
    var player: AVPlayer?
    
    @IBOutlet weak var eggInfoLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        timer.invalidate()
        guard let title = sender.currentTitle, let secondsRemaining = eggTime[title] else {
            return
        }
        eggInfoLabel.text = title
        totalTime = secondsRemaining
        secondsPassed = 0
        progressBar.progress = 0
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if secondsPassed < totalTime {
            print(secondsPassed)
            secondsPassed += 1
            progressBar.progress = secondsPassed / totalTime
        } else {
            timer.invalidate()
            eggInfoLabel.text = "Done"
            guard let url = Bundle.main.url(forResource: "alarms", withExtension: "mp3") else {
                return
            }
            
            do {
                player = AVPlayer(url: url)
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                player?.play()
            } catch {
                print("Error loading sound file: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
                guard let self else { return }
                eggInfoLabel.text = "How do you like your eggs?"
                progressBar.progress = 0
            }
        }
    }
    
}

