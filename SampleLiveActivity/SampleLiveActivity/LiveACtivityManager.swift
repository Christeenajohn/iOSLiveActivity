//
//  LiveACtivityManager.swift
//  SampleLiveActivity
//
//  Created by Christeena John on 09/05/2023.
//

import Foundation
import ActivityKit
import Combine


final class LiveActivityManager {
    static let shared = LiveActivityManager()
    private init() {}
    
    private var deliveryActivity: Activity<StatusAttributes>?
    @Published var status: String?
    
    func startLiveActivity() {
        // checking whether 'Live activities' is enabled for the app in settings
        if ActivityAuthorizationInfo().areActivitiesEnabled,
           deliveryActivity == nil {
            // Create the activity attributes and activity content objects.
            let initialContentState = StatusAttributes.ContentState(currentStep: 1, status: getStatusForStep(1))
            let activityAttributes = StatusAttributes(totalSteps: 5)
            do {
                // line 1: Start the Live Activity.
                deliveryActivity = try Activity<StatusAttributes>.request(attributes: activityAttributes,
                                                                              contentState: initialContentState)
                status = getStatusForStep(initialContentState.currentStep)
                Task {
                    for await data in deliveryActivity!.pushTokenUpdates {
                        let pushToken = data.map {String(format: "%02x", $0)}.joined()
                        //Update pushToken to server
                    }
                }
            } catch (let error) {
                print("Error requesting delivery Live Activity \(error.localizedDescription).")
                status = "failed"
            }
        }
    }
    
    func updateActivity() {
        Task {
            guard var step = deliveryActivity?.contentState.currentStep,
                  let totalSteps = deliveryActivity?.attributes.totalSteps else {return}
            if step < totalSteps {
                step = step + 1
                let activityContent = StatusAttributes.ContentState(currentStep: step,
                                                                    status: getStatusForStep(step))
                await deliveryActivity?.update(using: activityContent)
                status = getStatusForStep(step)
            }
        }
    }
    
    func endActivity() {
        let activityContent = StatusAttributes.ContentState(currentStep: 5, status: getStatusForStep(5))
        let dateAfter30Min = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
        Task {
            status = getStatusForStep(activityContent.currentStep)
            await deliveryActivity?.end(using: activityContent,
                                        dismissalPolicy: .after(dateAfter30Min))
            deliveryActivity = nil
        }
    }
    
    func getStatusForStep(_ step: Int) -> String {
        switch step {
        case 1:
            return "Placed"
        case 2:
            return "Accepted"
        case 3:
            return "Preparing"
        case 4:
            return "Enroute"
        case 5:
            return "Delivered"
        default:
            return "Cancelled"
        }
    }
}






