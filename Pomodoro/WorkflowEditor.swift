//
//  Editor.swift
//  Pomodoro
//
//  Created by Misha Vrana on 09.02.2023.
//

import SwiftUI

struct WorkflowEditor: View {
    @Binding var sessions: Int
    @Binding var constantWorkTime: Int
    @Binding var constantBreakTime: Int
    
    var body: some View {
        Form {
            sessionsEditor
            workMinutesEditor
            breakMinutesEditor
        }
    }
    
    var sessionsEditor: some View {
        Section(header: Text("Sessions")) {
            Stepper("Sessions: \(sessions)", onIncrement: {
                sessions += 1
            }, onDecrement: {
                if sessions > 1 {
                    sessions -= 1
                }
            })
        }
    }
    
    var workMinutesEditor: some View {
        Section(header: Text("Minutes to work")) {
            TextField("Minutes to work", value: $constantWorkTime, format: .number)
                .keyboardType(.decimalPad)
        }
    }
    
    var breakMinutesEditor: some View {
        Section(header: Text("Minutes to break")) {
            TextField("Minutes to break", value: $constantBreakTime, format: .number)
                .keyboardType(.decimalPad)
        }
    }
}

struct Editor_Previews: PreviewProvider {
    static var previews: some View {
        WorkflowEditor (
            sessions: .constant(2),
            constantWorkTime: .constant(2),
            constantBreakTime: .constant(2))
    }
}
