//
//  ContentView.swift
//  LocationTracker_Watch Extension
//
//  Created by Ben Gottlieb on 8/13/21.
//

import SwiftUI

struct ContentView: View {
	@ObservedObject var gps = GPSManager.instance
	var body: some View {
		VStack() {
			if gps.isAllowed {
				if gps.isTracking {
					Button("Stop Tracking") {
						gps.stop()
					}
					.padding()
				} else {
					Button("Start Tracking") {
						gps.start()
					}
					.padding()
				}
				
				Text("Total: \(gps.trackedDistance) m")
					.padding()
				
				Button("Reset") {
					gps.reset()
				}
				.padding()
			} else {
				Button("Request Location Permission") {
					gps.requestPermissions()
				}
			}
			
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
