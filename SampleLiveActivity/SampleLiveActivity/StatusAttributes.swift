//
//  StatusAttributes.swift
//  SampleLiveActivity
//
//  Created by Christeena John on 09/05/2023.
//

import Foundation
import ActivityKit

struct StatusAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var currentStep: Int
        var status: String
    }
    
    // Fixed non-changing properties about your activity go here!
    let totalSteps: Int
    let orderId: String
}
