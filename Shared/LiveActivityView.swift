//
//  LiveActivityView.swift
//  Weight Control
//
//  Created by 杨林青 on 2022/11/29.
//

import SwiftUI
import ActivityKit
import WidgetKit

struct LiveActivityView: View {
    var weight: Double
    
    var body: some View {
        HStack {
            Text("减肥!!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
            Spacer()
            VStack(alignment: .leading) {
                Text("体重")
                Text(String(format: "%.2f", weight))
                    .font(.title)
                    .fontWeight(.bold)
                    .monospacedDigit()
            }
            Image(systemName: "arrowshape.forward.fill")
                .imageScale(.large)
            VStack(alignment: .trailing) {
                Text("目标")
                Text(String(format: "%.2f", 70.0))
                    .font(.title)
                    .fontWeight(.bold)
                    .monospacedDigit()
            }
        }
        .padding()
    }
}

struct LiveActivityView_Previews: PreviewProvider {
    static var previews: some View {
        LiveActivityView(weight: 77.5)
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/400.0/*@END_MENU_TOKEN@*/, height: 70.0))
    }
}
