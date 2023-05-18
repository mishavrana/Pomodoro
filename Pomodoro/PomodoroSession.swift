//
//  Pomodoro.swift
//  Pomodoro
//
//  Created by Misha Vrana on 07.02.2023.
//

import Foundation

struct PomodoroSession: Codable, Hashable {
    var constantWorkDuration: Int
    var constantBreakDuration: Int
    var constantTimesToRepeat: Int
    
    var workDuration: Int = 0
    var breakDuration: Int = 0
    
    var timesToRepeat: Int
     
    var isWorkTime = true
    var isPaused = false
    
    // MARK: - Intents
    
    mutating func countDownWorktime(elapsed: TimeInterval) {
        if Int(elapsed) < constantWorkDuration {
            workDuration = Int(elapsed)
        } else {
            isWorkTime = false
        }
    }
    
    mutating func countDownBreaktime(elapsed: TimeInterval) {
        if Int(elapsed) < constantBreakDuration {
            breakDuration = Int(elapsed)
        } else {
            if timesToRepeat > 0 {
                isWorkTime = true
            }
        }
    }
    
    init(workDuration: Int, breakDuration: Int, timesToRepeat: Int, isWorkTime: Bool = true) {
        self.constantWorkDuration = workDuration
        self.constantBreakDuration = breakDuration
        self.timesToRepeat = timesToRepeat
        self.constantTimesToRepeat = timesToRepeat
        self.isWorkTime = isWorkTime
    }
    init() {
        self.constantWorkDuration = 1500
        self.constantBreakDuration = 300
        self.timesToRepeat = 2
        self.constantTimesToRepeat = 2
        self.isWorkTime = true
    }
    
}
