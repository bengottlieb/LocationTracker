//
//  MessageHandler.swift
//  MessageHandler
//
//  Created by Ben Gottlieb on 8/14/21.
//

import Suite
import Portal

extension PortalMessage.Kind {
	static let coordinate = PortalMessage.Kind(rawValue: "coordinate")
}

extension PortalMessage {
	init?(_ location: StoredLocation) {
		guard let json = try? location.asJSON() else {
			self.init(.ping)
			return nil
		}
		
		self.init(.coordinate, json)
	}
	
	var location: StoredLocation? {
		try? StoredLocation.load(from: body ?? [:])
	}
}

extension DevicePortal {
	func send(_ location: StoredLocation) {
		if let message = PortalMessage(location) {
			send(message)
		}
	}
}

class MessageHandler: PortalMessageHandler {
	static let instance = MessageHandler()
	
	func didReceive(message: PortalMessage) -> [String: Any]? {
		switch message.kind {
		case .coordinate:
			if let loc = message.location {
				GPSManager.instance.received(counterpartLocation: loc)
			}
			
		default: break
		}
		return nil
	}
	
	func didReceive(file: URL, fileType: PortalFileKind?, metadata: [String: Any]?, completion: @escaping () -> Void) {
		completion()
	}
	
	func didReceive(userInfo: [String: Any]) {
		
	}

}
