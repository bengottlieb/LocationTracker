//
//  MapTab.swift
//  MapTab
//
//  Created by Ben Gottlieb on 8/14/21.
//

import SwiftUI

struct MapTab: View {
	@ObservedObject var gps = GPSManager.instance

	var body: some View {
		let locations = gps.useCounterpartLocations ? gps.counterpartLocations : gps.locations
		MapView(path: locations.map { $0.location })
	}
}

struct MapTab_Previews: PreviewProvider {
	static var previews: some View {
		MapTab()
	}
}
