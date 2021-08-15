//
//  SavedData.swift
//  LocationTracker
//
//  Created by Ben Gottlieb on 8/14/21.
//

import Foundation

class SavedData: ObservableObject {
	static let instance = SavedData()
	
	
	static let filename = "saved_phone.txt"
	static let watchFilename = "saved_watch.txt"
	

	@Published var savedPhoneDataURL: URL?
	@Published var savedWatchDataURL: URL?
	
	init() {
		let phoneURL = URL.document(named: Self.filename)
		if FileManager.default.fileExists(at: phoneURL) {
			self.savedPhoneDataURL = phoneURL
		}

		let watchURL = URL.document(named: Self.watchFilename)
		if FileManager.default.fileExists(at: watchURL) {
			self.savedWatchDataURL = watchURL
		}
	}
}
