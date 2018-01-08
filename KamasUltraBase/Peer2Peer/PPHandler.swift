// Copyright 2016-2017, Ralf Ebert
// License   https://opensource.org/licenses/MIT
// Source    https://www.ralfebert.de/tutorials/ios-swift-multipeer-connectivity/

import Foundation
import MultipeerConnectivity

class PPHandler : NSObject {
    // MARK: Properties
    private let serviceType = "appKamasultra"
    
    private var myPeerId : MCPeerID
    
    private var serviceAdvertiser : MCNearbyServiceAdvertiser
    private var serviceBrowser : MCNearbyServiceBrowser
    
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    override init() {
        // Check user configurations
        let userDefaults = UserDefaults.standard
        let peerName = userDefaults.object(forKey: UserKey.peerName) as? String
        self.myPeerId = MCPeerID(displayName: peerName!)
        
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: self.serviceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: self.serviceType)
        
        super.init()
        
        //NSLog("%@", "Started Adversiting")
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        //NSLog("%@", "Started Adversiting")
        
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
        //NSLog("%@", "Started Browsing")
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    // MARK: Internal Functions
    func send(dataInfo : String) -> Bool {
        //NSLog("%@", "sendColor: \(dataInfo) to \(session.connectedPeers.count) peers")
        
        if session.connectedPeers.count > 0 {
            do {
                try self.session.send(dataInfo.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
            }
            catch let error {
                //NSLog("%@", "Error for sending: \(error)")
                return false
            }
            return true
        }
        return false
    }
    
    func invitePeer(peerID: MCPeerID) {
        Global.shared.isMaster = true
        self.serviceBrowser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
    }
    
    func receivedInvitationAlert(peerID: MCPeerID, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        if Global.shared.connectedPeer != nil {
            invitationHandler(false, self.session)
        } else {
            let alert = UIAlertController(title: "Invite from \(peerID.displayName)", message: "\(peerID.displayName) wants to play with you.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { _ in
                invitationHandler(true, self.session)
                Global.shared.connectedPeer = peerID
                Global.shared.isMaster = false
                DispatchQueue.main.async { NotificationCenter.default.post(name: Notifications.UpdateConnectedStatus, object: nil, userInfo: nil) }
            }))
            
            alert.addAction(UIAlertAction(title: "Refuse", style:.cancel, handler: { _ in
                invitationHandler(false, self.session)
            }))
            
            presentAtTopViewController(view: alert)
        }
    }
    
    func lostConnectionAlert(peerID: MCPeerID) {
        let alert = UIAlertController(title: "Lost connection", message: "\(peerID.displayName) disconnected", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            DispatchQueue.main.async { NotificationCenter.default.post(name: Notifications.UpdateConnectedStatus, object: nil, userInfo: nil) }
            DispatchQueue.main.async { NotificationCenter.default.post(name: Notifications.DidLostConnectionWithPeer, object: nil, userInfo: nil) }
        }))
        
        presentAtTopViewController(view: alert)
    }
    
    func disconnectPeer() {
        self.session.disconnect()
        Global.shared.connectedPeer = nil
    }
    
    func adversiteSelf(adverstise: Bool) {
        if adverstise {
            self.serviceAdvertiser.startAdvertisingPeer()
        } else {
            self.serviceAdvertiser.stopAdvertisingPeer()
        }
    }
    
    func resetPeerID(newDisplayName: String) {
        self.myPeerId = MCPeerID(displayName: newDisplayName)
        
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: self.serviceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: self.serviceType)
        self.session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
        
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
        self.session.delegate = self
    }
    
    func presentAtTopViewController(view: UIViewController) {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            // topController should now be your topmost view controller
            topController.present(view, animated: true, completion: nil)
        }
    }
}

// MARK: Advertiser Delegate
extension PPHandler : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        //NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        //NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        self.receivedInvitationAlert(peerID: peerID, invitationHandler: invitationHandler)
    }
    
}

// MARK: Browser Delegate
extension PPHandler : MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        //NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        //NSLog("%@", "foundPeer: \(peerID)")
        
        let isPeerOnList = Global.shared.peers.contains(where: { $0.peerID == peerID })
        
        if !isPeerOnList {
            Global.shared.peers.append(Peer(peerID: peerID))
            // Send Notification
            DispatchQueue.main.async { NotificationCenter.default.post(name: Notifications.MPCFoundPeer, object: nil, userInfo: nil) }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        //NSLog("%@", "lostPeer: \(peerID)")
        
        
        let allPeersButLostOne = Global.shared.peers.filter({$0.peerID != peerID})
        Global.shared.peers = allPeersButLostOne
        
        if let cp = Global.shared.connectedPeer, cp == peerID {
            lostConnectionAlert(peerID: peerID)
            Global.shared.connectedPeer = nil
        } else if let cp = Global.shared.connectingPeer, cp == peerID {
            Global.shared.connectingPeer = nil
        }
        
        DispatchQueue.main.async { NotificationCenter.default.post(name: Notifications.MPCLostPeer, object: nil, userInfo: nil) }
    }
    
}

// MARK: Session Delegate
extension PPHandler : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        //NSLog("%@", "peer \(peerID) didChangeState: \(state.rawValue)")
        let userInfo = [Notifications.keyPeerID : peerID, Notifications.keyState : state.rawValue] as [String : Any]
        
        Global.shared.connectingPeer = nil
        
        if state == MCSessionState.connected {
            Global.shared.connectedPeer = peerID
        } else if state == MCSessionState.notConnected, peerID == Global.shared.connectedPeer {
            Global.shared.connectedPeer = nil
            
            // Alert lost connection
            self.lostConnectionAlert(peerID: peerID)
        }
        
        DispatchQueue.main.async { NotificationCenter.default.post(name: Notifications.MPCDidChangeState, object: nil, userInfo: userInfo) }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        //NSLog("%@", "didReceiveData: \(data)")
        
        let str = String(data: data, encoding: .utf8)!
        let userInfo = [Notifications.keyPeerID : peerID, Notifications.keyData : str] as [String : Any]
        DispatchQueue.main.async { NotificationCenter.default.post(name: Notifications.MPCDidReceiveData, object: nil, userInfo: userInfo) }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        //NSLog("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        //NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        //NSLog("%@", "didFinishReceivingResourceWithName")
    }
    
}
