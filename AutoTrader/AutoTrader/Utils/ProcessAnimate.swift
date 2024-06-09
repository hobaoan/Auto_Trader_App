//
//  ProcessAnimate.swift
//  AutoTrader
//
//  Created by An Bảo on 09/06/2024.
//

import UIKit
import ProgressHUD

class ProgressAnimate {
    private var progressValue: Float = 0.0
    
    func simulateProgress(completion: @escaping () -> Void) {
        let totalTime: TimeInterval = 2.0
        let updateInterval: TimeInterval = 0.03
        let numberOfSteps = Int(totalTime / updateInterval)
        let stepValue = 1.0 / Float(numberOfSteps)
        
        for step in 0...numberOfSteps {
            let delay = Double(step) * updateInterval
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.progressValue += stepValue
                self.updateProgress()
                if step == numberOfSteps {
                    completion()
                }
            }
        }
    }
    
    private func updateProgress() {
        DispatchQueue.main.async {
            if self.progressValue >= 1.0 {
                ProgressHUD.dismiss()
                ProgressHUD.remove()
                self.progressValue = 0.0
            } else {
                ProgressHUD.progress("Predicting...", CGFloat(self.progressValue))
            }
        }
    }
}
