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

extension StoredLocation: Codable {
	enum CodingKeys: String, CodingKey { case date, latitude, longitude, altitude, horizontalAccuracy, verticalAccuracy, course, courseAccuracy, speed, speedAccuracy, timestamp }
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		try container.encode(date, forKey: .date)
		
		try container.encode(location.coordinate.latitude, forKey: .latitude)
		try container.encode(location.coordinate.longitude, forKey: .longitude)

		try container.encode(location.horizontalAccuracy, forKey: .horizontalAccuracy)
		try container.encode(location.altitude, forKey: .altitude)
		try container.encode(location.verticalAccuracy, forKey: .verticalAccuracy)
		try container.encode(location.course, forKey: .course)
		try container.encode(location.courseAccuracy, forKey: .courseAccuracy)
		try container.encode(location.speed, forKey: .speed)
		try container.encode(location.speedAccuracy, forKey: .speedAccuracy)

		try container.encode(location.horizontalAccuracy, forKey: .horizontalAccuracy)
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		date = try container.decode(Date.self, forKey: .date)
		location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: try container.decode(Double.self, forKey: .latitude), longitude: try container.decode(Double.self, forKey: .longitude)), altitude: try container.decode(Double.self, forKey: .altitude), horizontalAccuracy: try container.decode(Double.self, forKey: .horizontalAccuracy), verticalAccuracy: try container.decode(Double.self, forKey: .verticalAccuracy), course: try container.decode(Double.self, forKey: .course), courseAccuracy: try container.decode(Double.self, forKey: .courseAccuracy), speed: try container.decode(Double.self, forKey: .speed), speedAccuracy: try container.decode(Double.self, forKey: .speedAccuracy), timestamp: try container.decode(Date.self, forKey: .date))

	}
}

extension Array where Element == StoredLocation {
	func totalDistance(requiredAccuracy: Double = .greatestFiniteMagnitude) -> Double {
		let source = filter { $0.location.horizontalAccuracy < requiredAccuracy }
		guard var current = source.first else { return 0 }
		var total: Double = 0
		
		for point in source.dropFirst() {
			let legDistance = point.location.distance(from: current.location)
			
			total += legDistance
			current = point
		}
		return total
	}
	
	func since(date: Date) -> [Element] {
		filter { $0.date >= date }
	}
	
	func accuracy(since: Date?) -> Double? {
		let source = since == nil ? self : self.since(date: since!)
		if source.isEmpty { return nil }
		
		let total = source.map { $0.location.horizontalAccuracy }.reduce(0) { $0  + $1 }
		
		return total / Double(source.count)
	}
}
