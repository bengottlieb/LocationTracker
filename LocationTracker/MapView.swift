//
//  MapView.swift
//  MapView
//
//  Created by Ben Gottlieb on 8/14/21.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
	var path: [CLLocation] = []
	
	func makeUIView(context: Context) -> MKMapView {
		context.coordinator.view
	}
	
	func updateUIView(_ uiView: MKMapView, context: Context) {
		if path.isNotEmpty {
			let view = context.coordinator.view
			let coords = path.map { $0.coordinate }
			let poly = MKGeodesicPolyline(coordinates: coords, count: coords.count)
			if let old = context.coordinator.poly {
				view.removeOverlay(old)
			}
			context.coordinator.poly = poly
			let bounding = view.mapRectThatFits(poly.boundingMapRect, edgePadding: UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30))
			view.setVisibleMapRect(bounding, animated: true)
			view.addOverlay(poly)
		}
	}
	
	typealias UIViewType = MKMapView
	
	
	class Coordinator: NSObject, MKMapViewDelegate {
		let view = MKMapView(frame: UIScreen.main.bounds)
		var poly: MKGeodesicPolyline?
		
		override init() {
			super.init()
			view.delegate = self
		}
		
		func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
			let renderer = MKPolylineRenderer(overlay: overlay)
			renderer.lineWidth = 5
			renderer.strokeColor = .red
			return renderer
		}
	}

	func makeCoordinator() -> Coordinator {
		Coordinator()
	}
	
}
