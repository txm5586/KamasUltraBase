//
//  Peer.swift
//  KamasUltra
//
//  Created by Tassio Moreira Marques on 14/12/2017.
//  Copyright © 2017 Tassio Marques. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class Peer {
    // MARK: Properties
    var state: String
    var peerID: MCPeerID
    
    init(peerID: MCPeerID) {
        self.state = ""
        self.peerID = peerID
    }
}
