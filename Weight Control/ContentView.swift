//
//  ContentView.swift
//  Weight Control
//
//  Created by 杨林青 on 2022/11/29.
//

import SwiftUI
import ActivityKit

struct ContentView: View {
    var body: some View {
        VStack {
            LiveActivityView(weight: 77.5)
            Button("开始") {
                startLiveActivity()
            }
            Button("更新") {
                updateLiveActivity()
            }
            Button("结束") {
                endLiveActivity()
            }
        }
        .padding()
    }
    
    func startLiveActivity() {
        let attributes = WidgetsAttributes(name: "DJB")
        let initialState = WidgetsAttributes.ContentState(value: 0)
        do {
            let _ = try Activity.request(attributes: attributes, contentState: initialState)
        } catch (let error) {
            print("Error requesting live activity \(error.localizedDescription)")
        }
    }
    
    func updateLiveActivity() {
        for activity in Activity<WidgetsAttributes>.activities {
            Task {
                var state = activity.contentState
                state.value += 1
                let alertConfiguration = AlertConfiguration(
                    title: "实时活动更新",
                    body: "id: \(activity.id)\nname: \(activity.attributes.name)\nvalue: \(activity.contentState.value)",
                    sound: .default
                )
                await activity.update(using: state, alertConfiguration: alertConfiguration)
            }
        }
    }
    
    func endLiveActivity() {
        for activity in Activity<WidgetsAttributes>.activities {
            Task {
                var state = activity.contentState
                state.value += 1
                await activity.end(using: state, dismissalPolicy: .default)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
