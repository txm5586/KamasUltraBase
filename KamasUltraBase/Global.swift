//
//  GlobalVariables.swift
//  KamasUltra
//
//  Created by Tassio Moreira Marques on 15/12/2017.
//  Copyright © 2017 Tassio Marques. All rights reserved.
//

import Foundation

class Global {
    // These are the properties you can store in your singleton
    var peers = [Peer]()
    
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

