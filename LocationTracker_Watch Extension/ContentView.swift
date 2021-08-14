//
//  ContentView.swift
//  LocationTracker_Watch Extension
//
//  Created by Ben Gottlieb on 8/13/21.
//

import SwiftUI
import WatchWorkout

struct ContentView: View {
	@ObservedObject var gps = GPSManager.instance
	@ObservedObject var workouts = WatchWorkoutManager.instance
	var body: some View {
		ScrollView() {
			VStack() {
				if workouts.currentWorkout == nil {
					Button("Start Workout") {
						workouts.currentWorkout = WatchWorkout(activity: .walking)
						workouts.currentWorkout?.start() { error in
							if error != nil { workouts.currentWorkout = nil }
						}
					}
				} else {
					Button("End Workout") {
						workouts.currentWorkout?.end() { error in
							workouts.currentWorkout = nil
						}
					}
				}
				
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
					
					Group() {
						Text("Total distance: \(gps.trackedDistance) m")
						if let accuracy = gps.recentAccuracy {
							Text("±\(accuracy) m")
						}
					}
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
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
