//
//  GPSManager.swift
//  LocationTracker
//
//  Created by Ben Gottlieb on 8/13/21.
//

import Foundation
import CoreLocation


public class GPSManager: NSObject, ObservableObject {
	public static let instance = GPSManager()
	public var isTracking: Bool { trackCount > 0 }
	public var isAllowed = false
	public var trackedDistance: Double { locations.totalDistance() }
	
	let locationManager = CLLocationManager()
	
	var locations: [StoredLocation] = []
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
	
	func updatePermissions() {
		isAllowed = CLLocationManager.locationServicesEnabled() && (locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse)
	}
	
	public func reset() {
		objectWillChange.send()
		locations = []
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
}

extension GPSManager: CLLocationManagerDelegate {
	public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		DispatchQueue.main.async {
			self.objectWillChange.send()
			self.locations += locations.map { StoredLocation(location: $0, date: Date()) }
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
