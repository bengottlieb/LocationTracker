//
//  GPSManager.swift
//  LocationTracker
//
//  Created by Ben Gottlieb on 8/13/21.
//

import Foundation
import CoreLocation
import Suite

public class GPSManager: NSObject, ObservableObject {
	public static let instance = GPSManager()
	public var isTracking: Bool { trackCount > 0 }
	public var isAllowed = false
	public var trackedDistance: Double { locations.totalDistance(requiredAccuracy: requiredAccuracy) }
	public var requiredAccuracy = 20.0
	
	let locationManager = CLLocationManager()
	
	var locations: [StoredLocation] = []
	var counterpartLocations: [StoredLocation] = []
	
	override init() {
		super.init()
		locationManager.delegate = self
		updatePermissions()
	}
	
	var trackCount = 0
	
	public func requestPermissions() {
		if isAllowed { return }
		
		locationManager.requestAlwaysAuthorization()
	}
	
	public func received(counterpartLocation: StoredLocation) {
		DispatchQueue.main.async {
			self.objectWillChange.send()
			self.counterpartLocations.append(counterpartLocation)
		}
	}
	
	public func save(to filename: String) {
		guard locations.isNotEmpty, let data = try? JSONEncoder().encode(locations) else { return }
		
		let url = URL.document(named: filename)
		try? data.write(to: url)
	}
	
	public func load(from filename: String) {
		guard
			let data = try? Data(contentsOf: URL.document(named: filename)),
			let locs = try? JSONDecoder().decode([StoredLocation].self, from: data) else { return }
		
		objectWillChange.send()
		self.locations = locs
	}
	
	func updatePermissions() {
		isAllowed = CLLocationManager.locationServicesEnabled() && (locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse)
	}
	
	public func reset() {
		objectWillChange.send()
		locations = []
		counterpartLocations = []
	}
	
	public func start() {
		trackCount += 1
		if trackCount > 1 { return }

		objectWillChange.send()
		print("Starting location query: \(locationManager.desiredAccuracy) \(locationManager.distanceFilter)")
		locationManager.desiredAccuracy = 1
		locationManager.distanceFilter = 0.1
		locationManager.startUpdatingLocation()
	}
	
	public func stop() {
		trackCount -= 1
		if trackCount > 0 { return }
		
		objectWillChange.send()
		locationManager.stopUpdatingLocation()
		print("Done with location query")
	}
	
	public var recentAccuracy: Double? {
		locations.accuracy(since: Date(timeIntervalSinceNow: -30))
	}
}

extension GPSManager: CLLocationManagerDelegate {
	public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.last,
				location.horizontalAccuracy != -1,
				abs(location.timestamp.timeIntervalSinceNow) < 10 {
					DispatchQueue.main.async {
						self.objectWillChange.send()
						self.locations.append(StoredLocation(location: location, date: Date()))
					}
			}
	}
	
	public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		
	}
	
	public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		DispatchQueue.main.async {
			self.objectWillChange.send()
			self.updatePermissions()
		}
	}
	
	#if os(iOS)
	public func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
		
	}
	#endif
	
}
