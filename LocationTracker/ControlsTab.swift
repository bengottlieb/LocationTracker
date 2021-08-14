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
	public let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
	@State var isFileSaved = FileManager.default.fileExists(at: .document(named: Self.filename))
	static let filename = "saved.txt"
	
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

				HStack() {
					Button("Save") {
						gps.save(to: Self.filename)
						isFileSaved = FileManager.default.fileExists(at: .document(named: Self.filename))
					}
					.padding(.horizontal)
					
					if isFileSaved {
						Button("Share") {
							UIApplication.shared.currentScene?.frontWindow?.rootViewController?.presentedest.share(something: [URL.document(named: Self.filename)])
						}
						.padding(.horizontal)

						Button("Load") {
							gps.load(from: Self.filename)
						}
						.padding(.horizontal)
					}
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

struct ControlsTab_Previews: PreviewProvider {
	static var previews: some View {
		ControlsTab()
	}
}
