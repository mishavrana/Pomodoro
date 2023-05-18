//
//  ActionBar.swift
//  Pomodoro
//
//  Created by Misha Vrana on 08.02.2023.
//

import SwiftUI

struct ActionBar: View {
    @EnvironmentObject var pomodoroWorkflow: PomodoroWorkflow
    
    @State private var managing: Bool = false
    @Binding var workflowStarted: Bool
    @Binding var sessions: Int
    @Binding var constantWorkTime: Int
    @Binding var constantBreakTime: Int
    
    var body: some View {
        HStack {
            settings
            Spacer()
            restart
            start
                .sheet(isPresented: $managing) {
                    WorkflowEditor (
                        sessions: $sessions,
                        constantWorkTime: $constantWorkTime,
                        constantBreakTime: $constantBreakTime
                    )
                        .font(.none)
                }
        }
        .font(.system(size: 20))
        .padding(.horizontal)
    }
    
    var start: some View {
        Button {
            if !pomodoroWorkflow.workflowIsStarted {
                pomodoroWorkflow.startTime = Date()
                workflowStarted.toggle()
            } else {
                if !pomodoroWorkflow.workflowIsPaused {
                    pomodoroWorkflow.starPause()
                } else {
                    pomodoroWorkflow.finishPause()
//                    pomodoroWorkflow.startTime! += pomodoroWorkflow.pauseTime!
//                    pomodoroWorkflow.pauseTime! = 0
                    
                }
            }
            
        } label: {
            HStack {
                Image(systemName: "playpause")
            }
            .foregroundColor(.white)
            .padding()
        }
        .padding()
        .background(Color.blue)
        .clipShape(Circle())
    }
    
    var restart: some View {
        Button {
            workflowStarted = false
            pomodoroWorkflow.startNewWorkflow()
        } label: {
            Image(systemName: "restart")
                .foregroundColor(.white)
                .padding()
        }
        .padding()
        .background(Color.blue)
        .clipShape(Circle())
    }
    
    var settings: some View {
        Button {
            managing = true
        } label: {
            HStack {
                Image(systemName: "slider.horizontal.3")
                Text("Settings")
            }
            .foregroundColor(.white)
            .padding()
            
        }
        .background(Color.blue)
        .clipShape(Capsule())
    }
}

//struct ActionBar_Previews: PreviewProvider {
//    static var previews: some View {

//    }
//}
