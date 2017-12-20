//
//  GlobalVariables.swift
//  KamasUltra
//
//  Created by Tassio Moreira Marques on 15/12/2017.
//  Copyright © 2017 Tassio Marques. All rights reserved.
//

import Foundation
import MultipeerConnectivity

public class FirstLauch {
    init() {
        print("Opened")
        if(!UserDefaults.standard.bool(forKey: UserKey.firstLaunch)){
            print("Is a first launch")
            
            //Put any code here and it will be executed only once.
            let userDefaults = UserDefaults.standard
            
            userDefaults.set(true, forKey: UserKey.firstLaunch)
            userDefaults.set(UIDevice.current.name, forKey: UserKey.peerName)
            userDefaults.set(Constants.female, forKey: UserKey.gender)
        }
    }
}

class Action {
    static let kiss = 0
    static let lick = 1
    static let suck = 2
    static let touch = 3
    static let random = 4
}

class BodyPart {
    static let kiss = 0
    static let lick = 1
    static let suck = 2
    static let touch = 3
    static let random = 4
}

class Global {
    // MARK: Variables relative to P2P Connection
    var peers = [Peer]()
    var connectingPeer : MCPeerID?
    var connectedPeer : MCPeerID?
    var isMaster : Bool = false
    
    var selectedAction : Int!
    var selectedBodyPart : Int!
    
    // MARK: Relative to the settings of current user
    
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
    case declined = "Disconnected"
}

public class Constants {
    static let male = 0
    static let female = 1
    
    static let connectFirstWarning = "Try connecting with a partner first"
    static let waitingPartnerWarning = "Waiting for your partner to start"
}

public class UserKey {
    static let peerName = "peerName"
    static let gender = "gender"
    static let firstLaunch = "isFirstLaunch"
}

public class Notifications {
    static let MPCFoundPeer = NSNotification.Name("MPC_FoundPeerNotification")
    static let MPCLostPeer = NSNotification.Name("MPC_LostPeerNotification")
    static let MPCDidReceiveInvitationFromPeer = NSNotification.Name("MPC_DidReceiveInvitationFromPeerNotification")
    static let MPCDidChangeState = NSNotification.Name("MPC_DidChangeStateNotification")
    static let MPCDidReceiveData = NSNotification.Name("MPC_ReceiveDataNotification")
    static let UpdateConnectedStatus = NSNotification.Name("UpdateConnectedStateNotification")
    
    static let keyPeerID = "peerID"
    static let keyState = "state"
    static let keyData = "data"
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
}
