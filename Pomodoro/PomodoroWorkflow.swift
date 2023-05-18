//
//  PomodoroWorkflow.swift
//  Pomodoro
//
//  Created by Misha Vrana on 07.02.2023.
//

import SwiftUI

class PomodoroWorkflow: ObservableObject {
    @Published private var pomodoroSession: PomodoroSession = PomodoroSession() {
        didSet {
            storeInUserDefaults()
        }
    }
    
    private var userDefaultsKey = "PomodoroWorkflow"
    
    private var now = Date()
    
    var startTime: Date? = nil {
        didSet {
            pauseTime = 0
        }
    }
    var startPuaseTime: Date? = nil
    var pauseTime: TimeInterval = 0
    
    var workflowIsStarted = false
    var workflowIsPaused: Bool {
        get { return pomodoroSession.isPaused}
        set { pomodoroSession.isPaused = newValue }
    }
    
    var isWorkTime: Bool {
        return pomodoroSession.isWorkTime
    }
    
    var constantSessions: Int {
        get {
            return pomodoroSession.constantTimesToRepeat
        }
        set {
            pomodoroSession.constantTimesToRepeat = newValue
            sessions = newValue
        }
    }
    var sessions: Int {
        get {
            return pomodoroSession.timesToRepeat
        }
        set {
            pomodoroSession.timesToRepeat = newValue
        }
    }
    // MARK: - TIME
    
    var totalTimeInSeconds: Int {
        return(pomodoroSession.isWorkTime ? pomodoroSession.workDuration : pomodoroSession.breakDuration)
    }
    
    var constantTimeInSeconds: Int {
        if pomodoroSession.isWorkTime {
            return pomodoroSession.constantWorkDuration
        } else {
            return pomodoroSession.constantBreakDuration
        }
    }
    
    var constantWorkTimeInSeconds: Int {
        get { return pomodoroSession.constantWorkDuration }
        set { pomodoroSession.constantWorkDuration = newValue * 60}
    }
    var constantBreakTimeInSeconds: Int {
        get { return pomodoroSession.constantBreakDuration}
        set { pomodoroSession.constantBreakDuration = newValue * 60 }
    }
    
    var constantWorkTimeInMinutes: Int {
        get { return pomodoroSession.constantWorkDuration / 60 }
        set { pomodoroSession.constantWorkDuration = newValue * 60}
    }
    var constantBreakTimeInMinutes: Int {
        get { return pomodoroSession.constantBreakDuration / 60}
        set { pomodoroSession.constantBreakDuration = newValue * 60 }
    }

    var clockMinutes: Int {
        get {
            return (pomodoroSession.isWorkTime ? constantWorkTimeInSeconds - pomodoroSession.workDuration : constantBreakTimeInSeconds - pomodoroSession.breakDuration) / 60
        }
    }
    var clockSeconds: Int {
        return (pomodoroSession.isWorkTime ? 60 - pomodoroSession.workDuration : 60 - pomodoroSession.breakDuration) % 60
    }

    var stringTime: String {
        let minutes = "\(clockMinutes >= 10 ? String(clockMinutes) : "0\(clockMinutes)")"
        let seconds = "\(clockSeconds >= 10 ? String(clockSeconds) : "0\(clockSeconds)")"
        return "\(minutes) : \(seconds)"
    }
    
    
    // MARK: - Intents
    func handleSession() {
        if sessions > 0 {
            now = Date()
            let elapsed = now.timeIntervalSince(startTime!) - pauseTime
            
            if isWorkTime {
                if Int(elapsed) >= constantWorkTimeInSeconds && !workflowIsPaused {
                    startTime = now
                }
                pomodoroSession.countDownWorktime(elapsed: elapsed)
            } else {
                if Int(elapsed) >= constantBreakTimeInSeconds && !workflowIsPaused {
                    startTime = now
                    sessions -= 1
                }
                pomodoroSession.countDownBreaktime(elapsed: elapsed)
            }
        } else {
            workflowIsStarted = false
            startNewWorkflow()
        }
    }
    
    func startNewWorkflow() {
        pomodoroSession =
        Self.createPomodoroSession(workTime: constantWorkTimeInSeconds, breakTime: constantBreakTimeInSeconds, sessions: constantSessions)
    }
    
    func starPause() {
        startPuaseTime = now
        pomodoroSession.isPaused = true
    }
    
    func finishPause() {
        pomodoroSession.isPaused = false
        let now = Date()
        if let date = startPuaseTime {
            let elapsed = now.timeIntervalSince(date)
            pauseTime += elapsed
        }
    }
    
    func handlePause() {
        let now = Date()
        if let date = startPuaseTime {
            let elapsed = now.timeIntervalSince(date)
            pauseTime = elapsed
        }
    }
    
    static private func createPomodoroSession(workTime: Int, breakTime: Int, sessions: Int) -> PomodoroSession {
        PomodoroSession(workDuration: workTime, breakDuration: breakTime, timesToRepeat: sessions)
    }
    
    // MARK: - UserDefaults
    
    private func storeInUserDefaults() {
        let setOfSettings: Array<Int> = [pomodoroSession.constantWorkDuration, pomodoroSession.constantBreakDuration, pomodoroSession.timesToRepeat]
        UserDefaults.standard.set(try? JSONEncoder().encode(setOfSettings), forKey: userDefaultsKey)
    }
    
    private func restoreFromUserDefaults() -> PomodoroSession? {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey) {
            if let restoredSettings = try? JSONDecoder().decode(Array<Int>.self, from: jsonData) {
                let decodedSession = PomodoroSession(workDuration: restoredSettings[0], breakDuration: restoredSettings[1], timesToRepeat: restoredSettings[2])
                return decodedSession
            }
        }
        return nil
    }

    // MARK: - Initializers
    
    init() {
        if let restoredSession = restoreFromUserDefaults() {
            pomodoroSession = restoredSession
        }
    }
}
