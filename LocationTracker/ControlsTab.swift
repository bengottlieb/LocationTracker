//
//  ControlsTab.swift
//  ControlsTab
//
//  Created by Ben Gottlieb on 8/14/21.
//

import SwiftUI
import HealthKit

struct ControlsTab: View {
	@ObservedObject var gps = GPSManager.instance
	@ObservedObject var files = SavedData.instance
	public let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
	
	var body: some View {
		VStack() {
			Toggle("Counterpart", isOn: $gps.useCounterpartLocations).padding()
			
			Button("Authorize Healthkit") {
				HKHealthStore().requestAuthorization(toShare: [HKObjectType.workoutType()], read: [HKObjectType.workoutType(), heartRateType, HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!, HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!]) { success, error in
					if let err = error {
						print("Error when authorizing HealthKit: \(err)")
					}
				}
			}

			if gps.isAllowed {
				Group() {
					Text("Total distance: \(String(format: "%.02f ±%.03f", gps.trackedDistance, gps.recentAccuracy ?? 0)) m")
				}
				.padding()

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
				
				Button("Reset") {
					gps.reset()
				}
				.padding()

				Button("Save") {
					if gps.save(to: SavedData.filename) {
						files.savedPhoneDataURL = .document(named: SavedData.filename)
					}
				}
				.padding()

				if files.savedPhoneDataURL != nil || files.savedWatchDataURL != nil {
					HStack() {
						Text("Load")
						if let url = files.savedPhoneDataURL {
							Button("Phone") { gps.load(from: url) }
								.padding(.horizontal)
						}

						if let url = files.savedWatchDataURL {
							Button("Watch") { gps.load(from: url) }
								.padding(.horizontal)
						}
					}
					.padding()

					HStack() {
						Text("Share")
							if let url = files.savedPhoneDataURL {
								Button("Phone") {
									UIApplication.shared.currentScene?.frontWindow?.rootViewController?.presentedest.share(something: [url])
								}
								.padding(.horizontal)
							}

						if let url = files.savedWatchDataURL {
							Button("Watch") {
								UIApplication.shared.currentScene?.frontWindow?.rootViewController?.presentedest.share(something: [url])
							}
							.padding(.horizontal)
						}
					}
					.padding()
				}
			} else {
				Button("Request Location Permission") {
					gps.requestPermissions()
				}
			}
		}
	}
}

struct ControlsTab_Previews: PreviewProvider {
	static var previews: some View {
		ControlsTab()
	}
}
