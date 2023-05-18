//
//  TimerRin.swift
//  Pomodoro
//
//  Created by Misha Vrana on 14.02.2023.
//

import SwiftUI

struct TimerRing: View {
    @EnvironmentObject var pomodoroWorkflow: PomodoroWorkflow
    
    var timeLeft: CGFloat
    var startTime: CGFloat
    var content: String
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 1)
                .stroke(Color.black.opacity(0.09), style: StrokeStyle(lineWidth: 35, lineCap: .round))
                .padding(35)
            Circle()
                .trim(from: 0, to: 1 - (timeLeft / startTime))
                .stroke(
                    pomodoroWorkflow.isWorkTime ? Color.red.opacity(0.8): Color.green.opacity(0.8),
                    style: StrokeStyle(lineWidth: 35, lineCap: .round)
                )
                .padding(35)
            Text(content)
                .rotationEffect(Angle(degrees: 90))
                .font(.system(size: 50))
                .animation(.none, value: content)
        }
        .rotationEffect(.init(degrees: -90))
    }
}

struct TimerRin_Previews: PreviewProvider {
    static var previews: some View {
        TimerRing(timeLeft: 100, startTime: 180, content: "25 : 30")
    }
}
