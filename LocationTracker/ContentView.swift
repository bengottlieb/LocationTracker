//
//  ContentView.swift
//  LocationTracker
//
//  Created by Ben Gottlieb on 8/13/21.
//

import Suite
import HealthKit

struct ContentView: View {
	
	var body: some View {
		TabView() {
			ControlsTab()
				.tabItem() { Label("Controls", systemImage: "switch.2") }
			MapTab()
				.tabItem() { Label("Map", systemImage: "location.viewfinder") }
		}
		.accentColor(.red)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
