//
//  ContentView.swift
//  Weight Control
//
//  Created by 杨林青 on 2022/11/29.
//

import SwiftUI
import ActivityKit

struct ContentView: View {
    @State private var weight = 0.0
    private let formatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    @FocusState private var isFocused: Bool
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        VStack {
            Text("修改体重")
                .bold()
            TextField("体重", value: $weight, formatter: formatter)
                .focused($isFocused)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .bold()
                .monospacedDigit()
            Spacer()
            buttonCard("开始", action: startLiveActivity)
            buttonCard("更新", action: updateLiveActivity)
            buttonCard("结束", action: endLiveActivity)
            buttonCard("运行快捷指令记录体重", action: runShortcut)
        }
        .padding()
        .background {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func buttonCard(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding(12)
                .background {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.background)
                }
        }
        
    }
    
    func startLiveActivity() {
        let attributes = WidgetsAttributes(name: "减肥！")
        let initialState = WidgetsAttributes.ContentState(value: weight)
        do {
            let _ = try Activity.request(attributes: attributes, contentState: initialState)
        } catch (let error) {
            print("Error requesting live activity \(error.localizedDescription)")
        }
    }
    
    func updateLiveActivity() {
        isFocused = false
        for activity in Activity<WidgetsAttributes>.activities {
            Task {
                var state = activity.contentState
                state.value = weight
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
    
    func runShortcut() {
        openURL(URL(string: "shortcuts://run-shortcut?name=cn.ylq-dev.LogWeight&input=text&text=\(weight)")!)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
