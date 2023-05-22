//
//  StatusLiveActivity.swift
//  status
//
//  Created by Christeena John on 05/05/2023.
//

import ActivityKit
import WidgetKit
import SwiftUI

func getPercentageForStep(_ step: Int) -> Float {
    switch step {
    case 1:
        return 0.2
    case 2:
        return 0.4
    case 3:
        return 0.6
    case 4:
        return 0.8
    default:
        return 1
    }
}


struct statusLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: StatusAttributes.self) { context in
            // Lock screen/banner UI goes here
            HStack {
                Image("logo").resizable().aspectRatio(contentMode: .fit).frame(width: 45, height: 45)
                VStack {
                    Text("Your order is").font(.system(size: 14, weight: .regular))
                    Text(context.state.status).font(.system(size: 14, weight: .bold))
                }
            }.padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Image("logo").resizable().aspectRatio(contentMode: .fit)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    CircularProgressView(percentage: getPercentageForStep(context.state.currentStep))
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack {
                        Text("Your order is").font(.system(size: 14, weight: .regular))
                        Text(context.state.status).font(.system(size: 14, weight: .bold))
                    }
                }
            } compactLeading: {
                Image("logo").resizable().aspectRatio(contentMode: .fit)
            } compactTrailing: {
                CircularProgressView(percentage: getPercentageForStep(context.state.currentStep))
            } minimal: {
                Image("logo").resizable().aspectRatio(contentMode: .fit)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

struct CircularProgressView: View {
    var percentage: Float
    
    var body: some View {
        ZStack {
            Circle().stroke(Color(red: 217.0/255.0, green: 230.0/255.0, blue: 252.0/255.0, opacity: 1), lineWidth: 3)
                .frame(width: 25, height: 25)
            Circle()
                .trim(from: 0, to: CGFloat(percentage))
                .stroke(.blue, lineWidth: 3).frame(width: 25, height: 25)
                .rotationEffect(.degrees(-90))
        }.padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 2))
    }
}


extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
