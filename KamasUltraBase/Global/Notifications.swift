//
//  Notifications.swift
//  KamasUltra
//
//  Created by Tassio Moreira Marques on 14/12/2017.
//  Copyright © 2017 Tassio Marques. All rights reserved.
//

import Foundation

public class Notifications {
    static let MPCFoundPeer = NSNotification.Name("MPC_FoundPeerNotification")
    static let MPCDidReceiveInvitationFromPeer = NSNotification.Name("MPC_DidReceiveInvitationFromPeerNotification")
    static let MPCDidChangeState = NSNotification.Name("MPC_DidChangeStateNotification")
    
    
    static let MPCReceiveData = NSNotification.Name("MPC_ReceiveDataNotification")
}
