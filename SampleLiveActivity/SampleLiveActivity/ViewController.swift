//
//  ViewController.swift
//  SampleLiveActivity
//
//  Created by Christeena John on 05/05/2023.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    let activitymanager = LiveActivityManager.shared
    private var cancellables: Set<AnyCancellable> = []
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.text = "Status: Waiting.."
        
        activitymanager.$status.sink {[weak self] status in
            DispatchQueue.main.async {
                self?.statusLabel.text = "Status: " + (status ?? "")
            }
        }.store(in: &cancellables)
    }

    @IBAction func startActivity(_ sender: Any) {
        activitymanager.startLiveActivity()
    }
    
    @IBAction func updateActivity(_ sender: Any) {
        activitymanager.updateActivity()
    }
    
    @IBAction func endActivity(_ sender: Any) {
        activitymanager.endActivity()
    }
    
}

