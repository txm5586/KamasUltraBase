//
//  GlobalVariables.swift
//  KamasUltra
//
//  Created by Tassio Moreira Marques on 15/12/2017.
//  Copyright © 2017 Tassio Marques. All rights reserved.
//

import Foundation
import MultipeerConnectivity

// MARK: Launch and Global configurations class
public class FirstLauch {
    
    init() {
        let userDefaults = UserDefaults.standard
        
        if !userDefaults.bool(forKey: UserKey.isfirstLaunch) {
            //Put any code here and it will be executed only once.
            let userDefaults = UserDefaults.standard
            
            userDefaults.set(true, forKey: UserKey.isfirstLaunch)
            
            userDefaults.set(UIDevice.current.name, forKey: UserKey.peerName)
            userDefaults.set(Constants.female, forKey: UserKey.gender)
            
            MoodConfig.changeMood(mood: Mood.Sexy)
        } else {
            if userDefaults.bool(forKey: UserKey.mood) {
                let mood = Mood(rawValue: userDefaults.string(forKey: UserKey.mood)!)
                MoodConfig.changeMood(mood: mood!)
            } else {
                MoodConfig.changeMood(mood: Mood.Sexy)
            }
        }
    }
}

class Global {
    // MARK: Variables relative to P2P Connection
    var peers = [Peer]()
    var connectingPeer : MCPeerID?
    var connectedPeer : MCPeerID?
    var isMaster : Bool = false
    var isMasterTurn: Bool = true
    
    var selectedAction : Action!
    var selectedBodyPart : BodyPart!
    
    var actionReceived : Action!
    var bodyPartReceived : BodyPart!
    
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
    
    static func log(className: String, msg: String) {
        print("--- [\(className)] \(msg)")
    }
}

// MARK: Constatants
enum Action : Int {
    case kiss = 0
    case lick = 1
    case suck = 2
    case touch = 3
    case random = 4
}

enum BodyPart : String {
    case Head
    case Ears
    case Mouth
    case Neck
    case Shoulders
    case Chest
    case Arms
    case Abdomin
    case Waist
    case Hands
    case Legs
    case Knees
    case Feet
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
    static let isfirstLaunch = "isFirstLaunch"
    static let mood = "mood"
}

public class Notifications {
    static let MPCFoundPeer = NSNotification.Name("MPC_FoundPeerNotification")
    static let MPCLostPeer = NSNotification.Name("MPC_LostPeerNotification")
    static let MPCDidReceiveInvitationFromPeer = NSNotification.Name("MPC_DidReceiveInvitationFromPeerNotification")
    static let MPCDidChangeState = NSNotification.Name("MPC_DidChangeStateNotification")
    static let MPCDidReceiveData = NSNotification.Name("MPC_ReceiveDataNotification")
    static let UpdateConnectedStatus = NSNotification.Name("UpdateConnectedStateNotification")
    
    static let DidLostConnectionWithPeer = NSNotification.Name("MPC_DidLostConnectionWithPeer")
    
    static let keyPeerID = "peerID"
    static let keyState = "state"
    static let keyData = "data"
}

enum Mood : String {
    case Sexy
    case Luxury
    case Mistery
    case Relaxing
    case Romantic
    case Fun
    case Excitement
    case Crazy
    
    static var count: Int { return Mood.Crazy.hashValue + 1}
}

struct MoodConfig {
    static var currentMood : Mood = .Sexy
    static var gradientColor1 = UIColor(hex: 0xFC466B).cgColor//UIColor(red: 25/255, green: 42/255, blue: 240/255, alpha: 1).cgColor
    static var gradientColor2 = UIColor(red: 248/255, green: 26/255, blue: 53/255, alpha: 1).cgColor
    static var gradientColor3 = UIColor(red: 248/255, green: 26/255, blue: 53/255, alpha: 1).cgColor
    static var gradientColor4 = UIColor(red: 25/255, green: 42/255, blue: 240/255, alpha: 1).cgColor

    static func changeMood(mood: Mood) {
        Global.log(className: "MoodConfig", msg: "Is going to change to \(mood.rawValue)")
        UserDefaults.standard.set(mood.rawValue, forKey: UserKey.mood)
        currentMood = mood
        switch mood {
        case .Sexy:
            gradientColor1 = UIColor(hex: 0xFC466B).cgColor//UIColor(red: 25/255, green: 42/255, blue: 240/255, alpha: 1).cgColor
            gradientColor2 = UIColor(hex: 0x3F5EFB).cgColor//UIColor(red: 248/255, green: 26/255, blue: 53/255, alpha: 1).cgColor
            gradientColor3 = UIColor(hex: 0x3F5EFB).cgColor//UIColor(red: 248/255, green: 26/255, blue: 53/255, alpha: 1).cgColor
            gradientColor4 = UIColor(hex: 0xFC466B).cgColor//UIColor(red: 25/255, green: 42/255, blue: 240/255, alpha: 1).cgColor
        case .Luxury:
            gradientColor1 = UIColor(hex:0x03001e).cgColor//UIColor(red: 3/255, green: 0/255, blue: 30/255, alpha: 1).cgColor
            gradientColor2 = UIColor(hex:0x7303c0).cgColor//UIColor(red: 115/255, green: 3/255, blue: 192/255, alpha: 1).cgColor
            gradientColor3 = UIColor(hex:0xec38bc).cgColor//UIColor(red: 236/255, green: 56/255, blue: 188/255, alpha: 1).cgColor
            gradientColor4 = UIColor(hex:0xfdeff9).cgColor//UIColor(red: 253/255, green: 239/255, blue: 249/255, alpha: 1).cgColor
        case .Mistery:
            gradientColor1 = UIColor(hex:0x000000).cgColor// UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
            gradientColor2 = UIColor(hex:0x53346D).cgColor// UIColor(red: 83/255, green: 52/255, blue: 109/255, alpha: 1).cgColor
            gradientColor3 = UIColor(hex:0x53346D).cgColor// UIColor(red: 83/255, green: 52/255, blue: 109/255, alpha: 1).cgColor
            gradientColor4 = UIColor(hex:0x000000).cgColor// UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        case .Relaxing:
            gradientColor1 = UIColor(hex:0x77A1D3).cgColor//UIColor(red: 119/255, green: 161/255, blue: 211/255, alpha: 1).cgColor
            gradientColor2 = UIColor(hex:0x79CBCA).cgColor//UIColor(red: 121/255, green: 203/255, blue: 202/255, alpha: 1).cgColor
            gradientColor3 = UIColor(hex:0x79CBCA).cgColor//UIColor(red: 121/255, green: 203/255, blue: 202/255, alpha: 1).cgColor
            gradientColor4 = UIColor(hex:0xE684AE).cgColor//UIColor(red: 230/255, green: 132/255, blue: 174/255, alpha: 1).cgColor
        case .Romantic:
            gradientColor1 = UIColor(red: 204/255, green: 43/255, blue: 94/255, alpha: 1).cgColor
            gradientColor4 = UIColor(red: 204/255, green: 43/255, blue: 94/255, alpha: 1).cgColor
            gradientColor3 = UIColor(red: 117/255, green: 58/255, blue: 136/255, alpha: 1).cgColor
            gradientColor2 = UIColor(red: 117/255, green: 58/255, blue: 136/255, alpha: 1).cgColor
        case .Fun:
            gradientColor1 = UIColor(red: 64/255, green: 224/255, blue: 208/255, alpha: 1).cgColor
            gradientColor2 = UIColor(red: 255/255, green: 140/255, blue: 0/255, alpha: 1).cgColor
            gradientColor3 = UIColor(red: 255/255, green: 140/255, blue: 0/255, alpha: 1).cgColor
            gradientColor4 = UIColor(red: 255/255, green: 0/255, blue: 128/255, alpha: 1).cgColor
        case .Excitement:
            gradientColor1 = UIColor(red: 0/255, green: 242/255, blue: 96/255, alpha: 1).cgColor
            gradientColor2 = UIColor(red: 5/255, green: 117/255, blue: 230/255, alpha: 1).cgColor
            gradientColor3 = UIColor(red: 5/255, green: 117/255, blue: 230/255, alpha: 1).cgColor
            gradientColor4 = UIColor(red: 0/255, green: 242/255, blue: 96/255, alpha: 1).cgColor
        case .Crazy:
            gradientColor1 = UIColor(red: 69/255, green: 104/255, blue: 220/255, alpha: 1).cgColor
            gradientColor2 = UIColor(red: 176/255, green: 106/255, blue: 179/255, alpha: 1).cgColor
            gradientColor3 = UIColor(red: 176/255, green: 106/255, blue: 179/255, alpha: 1).cgColor
            gradientColor4 = UIColor(red: 69/255, green: 104/255, blue: 220/255, alpha: 1).cgColor
        }
    }
    
    static func getScreenGradient() -> [Any] {
        switch currentMood {
        case .Sexy:
            return [gradientColor1, gradientColor2]
        case .Luxury:
            return [gradientColor1, gradientColor2, gradientColor3, gradientColor4]
        case .Mistery:
            return [gradientColor1, gradientColor2]
        case .Relaxing:
            return [gradientColor1, gradientColor2, gradientColor4]
        case .Romantic:
            return [gradientColor1, gradientColor3]
        case .Fun:
            return [gradientColor1, gradientColor2, gradientColor4]
        case .Excitement:
            return [gradientColor1, gradientColor2]
        case .Crazy:
            return [gradientColor1, gradientColor2]
        }
    }
}

// MARK: Extensions
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

public class DataProtocol {
    static let separator : Character = "#"
    static let empty = "."
    
    static let gameStarted = "GS"
    static let actionSent = "AS"
    static let actionScreenFinished = "AF"
    
    static func prepareToStartGame() -> String {
        return gameStarted
    }
    
    static func prepareToFinishAction() -> String {
        return actionScreenFinished
    }
    
    static func prepareToSendAction(action: Action, body: BodyPart) -> String {
        return "\(actionSent)#\(action.rawValue)#\(body.rawValue)"
    }
    
    static func decodeData(data: String) -> [String : Any] {
        let dataArray = data.split(separator: separator)
        
        var dictionary = [String:Any]()
        
        if dataArray[0] == actionSent {
            let action = Action(rawValue: Int(dataArray[1])!)!
            let body = BodyPart(rawValue: String(dataArray[2]))!
            
            dictionary = ["data":dataArray[0], "action":action, "body":body]
        } else {
            dictionary = ["data":dataArray[0]]
        }
        
        return dictionary
    }
}

extension NSObject {
    var theClassName: String {
        return NSStringFromClass(type(of: self))
    }
}
