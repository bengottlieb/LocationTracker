//
//  MessageHandler.swift
//  MessageHandler
//
//  Created by Ben Gottlieb on 8/14/21.
//

import Foundation
import Portal

extension PortalMessage.Kind {
	static let coordinate = PortalMessage.Kind(rawValue: "coordinate")
}

extension PortalMessage {
	
}

class MessageHandler: PortalMessageHandler {
	static let instance = MessageHandler()
	
	func didReceive(message: PortalMessage) -> [String: Any]? {
		switch message.kind {
		case .coordinate:
			
		}
		return nil
	}
	
	func didReceive(file: URL, fileType: PortalFileKind?, metadata: [String: Any]?, completion: @escaping () -> Void) {
		completion()
	}
	
	func didReceive(userInfo: [String: Any]) {
		
	}

}
