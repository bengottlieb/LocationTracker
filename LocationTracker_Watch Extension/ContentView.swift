//
//  ContentView.swift
//  LocationTracker_Watch Extension
//
//  Created by Ben Gottlieb on 8/13/21.
//

import Suite
import WatchWorkout
import Portal

struct ContentView: View {
	@ObservedObject var gps = GPSManager.instance
	@ObservedObject var workouts = WatchWorkoutManager.instance
	
	func sendFile() {
		let file = FileManager.tempFileURL(extension: "txt")
		if gps.save(to: file) {
			DevicePortal.instance.send(file)
		}
	}

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
						Button("Stop Tracking") { gps.stop() }
						.padding()
					} else {
						Button("Start Tracking") { gps.start() }
						.padding()
					}
					
					Group() {
						Text("Total distance: \(gps.trackedDistance) m")
						if let accuracy = gps.recentAccuracy {
							Text("±\(accuracy) m")
						}
					}
						.padding()

					if gps.locations.isNotEmpty {
						HStack() {
							Button("Transfer") { sendFile() }
								.padding(.horizontal)
							Button("Reset") { gps.reset() }
							.padding(.horizontal)
						}
						.padding(.vertical)
					}
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
