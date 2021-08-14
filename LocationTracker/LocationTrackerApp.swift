//
//  LocationTrackerApp.swift
//  LocationTracker
//
//  Created by Ben Gottlieb on 8/13/21.
//

import SwiftUI
import Portal

@main
struct LocationTrackerApp: App {
	init() {
		PortalToWatch.setup(messageHandler: MessageHandler.instance)
		DevicePortal.instance.connect()
	}

	var body: some Scene {
		WindowGroup {
			ContentView()
		}
	}
}
