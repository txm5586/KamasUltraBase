//
//  GlobalVariables.swift
//  KamasUltra
//
//  Created by Tassio Moreira Marques on 15/12/2017.
//  Copyright © 2017 Tassio Marques. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class Global {
    // These are the properties you can store in your singleton
    var peers = [Peer]()
    
    var connectingPeer : MCPeerID?
    var connectedPeer : MCPeerID?
    
    // Here is how you would get to it without there being a global collision of variables.
    // , or in other words, it is a globally accessable parameter that is specific to the
    // class.
    class var shared: Global {
        struct Static {
            static let instance = Global()
        }
        return Static.instance
    }
}

enum PeerState : String {
    case connected = "Connected"
    case connecting = "Connecting"
    case declined = "Declined"
}

public class Notifications {
    static let MPCFoundPeer = NSNotification.Name("MPC_FoundPeerNotification")
    static let MPCLostPeer = NSNotification.Name("MPC_LostPeerNotification")
    static let MPCDidReceiveInvitationFromPeer = NSNotification.Name("MPC_DidReceiveInvitationFromPeerNotification")
    static let MPCDidChangeState = NSNotification.Name("MPC_DidChangeStateNotification")
    static let MPCDidReceiveData = NSNotification.Name("MPC_ReceiveDataNotification")
    
    static let keyPeerID = "peerID"
    static let keyState = "state"
    static let keyData = "data"
}

