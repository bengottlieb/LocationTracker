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
		MapView(path: gps.locations.map { $0.location })
	}
}

struct MapTab_Previews: PreviewProvider {
	static var previews: some View {
		MapTab()
	}
}
