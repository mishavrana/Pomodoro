//
//  PomodoroApp.swift
//  Pomodoro
//
//  Created by Misha Vrana on 07.02.2023.
//

import SwiftUI

@main
struct PomodoroApp: App {
    @StateObject var pomodoroWorkflow: PomodoroWorkflow = PomodoroWorkflow()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(pomodoroWorkflow)
            
        }
    }
}
