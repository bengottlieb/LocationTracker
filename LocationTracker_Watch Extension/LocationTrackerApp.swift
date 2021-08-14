//
//  LocationTrackerApp.swift
//  LocationTracker_Watch Extension
//
//  Created by Ben Gottlieb on 8/13/21.
//

import SwiftUI
import Portal

@main
struct LocationTrackerApp: App {
	init() {
		DevicePortal.verboseErrorMessages = true
		PortalToPhone.setup(messageHandler: MessageHandler.instance)
		DevicePortal.instance.connect()
		GPSManager.instance.sendToCounterpart = true
	}

	var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}
