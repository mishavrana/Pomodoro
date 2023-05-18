//
//  ContentView.swift
//  Pomodoro
//
//  Created by Misha Vrana on 07.02.2023.
//

import CoreHaptics
import BackgroundTasks
import UserNotifications
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var pomodoroWorkflow: PomodoroWorkflow
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                TimerRing(timeLeft: CGFloat(pomodoroWorkflow.totalTimeInSeconds), startTime: CGFloat(pomodoroWorkflow.constantTimeInSeconds), content: pomodoroWorkflow.stringTime)
                    .onReceive(timer) { time in
                        if pomodoroWorkflow.workflowIsStarted && !pomodoroWorkflow.workflowIsPaused {
                            withAnimation() {
                                pomodoroWorkflow.handleSession()
                            }
                        }
                    }
                    .onChange(of: pomodoroWorkflow.workflowIsStarted) { newValue in
                        if !pomodoroWorkflow.workflowIsStarted {
                            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        }
                    }
                    .onChange(of: pomodoroWorkflow.startTime) { newValue in
                        if(pomodoroWorkflow.sessions > 0) {
                            notifyForWorkAndRestTime(timeInterval: pomodoroWorkflow.isWorkTime ? pomodoroWorkflow.constantWorkTimeInSeconds : pomodoroWorkflow.constantBreakTimeInSeconds)
                        }
                    }
                    .font(.title)
                    .textCase(.uppercase)
                Spacer()
                ActionBar (
                    workflowStarted: $pomodoroWorkflow.workflowIsStarted,
                    sessions: $pomodoroWorkflow.constantSessions,
                    constantWorkTime: $pomodoroWorkflow.constantWorkTimeInMinutes,
                    constantBreakTime: $pomodoroWorkflow.constantBreakTimeInMinutes
                )
                .environmentObject(pomodoroWorkflow)
            }
            .onAppear {
                UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) {(_, _)in}
            }
        }
        
    }
    func notifyForWorkAndRestTime(timeInterval: Int) {
        let content = UNMutableNotificationContent()
        content.title = pomodoroWorkflow.isWorkTime ? "Work is finished" : "Break is finished"
        content.body = "Click to continue"
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeInterval), repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PomodoroWorkflow())
    }
}
