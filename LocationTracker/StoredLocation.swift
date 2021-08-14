//
//  StoredLocation.swift
//  LocationTracker
//
//  Created by Ben Gottlieb on 8/13/21.
//

import Foundation
import CoreLocation

struct StoredLocation {
	let location: CLLocation
	let date: Date
}

extension Array where Element == StoredLocation {
	func totalDistance() -> Double {
		guard var current = first else { return 0 }
		var total: Double = 0
		
		for point in self.dropFirst() {
			let legDistance = point.location.distance(from: current.location)
			
			total += legDistance
			current = point
		}
		return total
	}
}
