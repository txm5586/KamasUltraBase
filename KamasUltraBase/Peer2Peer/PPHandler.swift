// Copyright 2016-2017, Ralf Ebert
// License   https://opensource.org/licenses/MIT
// Source    https://www.ralfebert.de/tutorials/ios-swift-multipeer-connectivity/

import Foundation
import MultipeerConnectivity

// MARK: Protocol
protocol PPHandlerDelegate {
    func pphandler(browser manager : PPHandler, foundPeer peerID : MCPeerID, withDiscoveryInfo info: [String : String]?)
    func pphandler(browser manager : PPHandler, lostPeer peerID: MCPeerID)
    func pphandler(advertiser manager : PPHandler, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void)
    func pphandler(session manager : PPHandler, didReceived data: Data, fromPeer peerID: MCPeerID)
    func pphandler(session manager : PPHandler, didChange state: MCSessionState, peer peerID: MCPeerID)
}

class PPHandler : NSObject {
    // MARK: Properties
    private let serviceType = "kamasultraapp"
    
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    
    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    private let serviceBrowser : MCNearbyServiceBrowser
    
    var delegate : PPHandlerDelegate?
    
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    override init() {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: self.serviceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: self.serviceType)
        
        super.init()
        
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    // MARK: Internal Functions
    func send(dataInfo : String) {
        NSLog("%@", "sendColor: \(dataInfo) to \(session.connectedPeers.count) peers")
        
        if session.connectedPeers.count > 0 {
            do {
                try self.session.send(dataInfo.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
            }
            catch let error {
                NSLog("%@", "Error for sending: \(error)")
            }
        }
        
    }
    
    func invitePeer(peerID: MCPeerID) {
        self.serviceBrowser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
    }
    
    func receivedInvitationAlert(peerID: MCPeerID, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        if Global.shared.connectedPeer != nil {
            invitationHandler(false, self.session)
        } else {
            let alert = UIAlertController(title: "Invite from \(peerID.displayName)", message: "\(peerID.displayName) wants to play with you.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { _ in
                invitationHandler(true, self.session)
            }))
            
            alert.addAction(UIAlertAction(title: "Refuse", style:.cancel, handler: { _ in
                invitationHandler(false, self.session)
            }))
            
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
}

// MARK: Advertiser Delegate
extension PPHandler : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        //invitationHandler(true, self.session)
        self.receivedInvitationAlert(peerID: peerID, invitationHandler: invitationHandler)
    }
    
}

// MARK: Browser Delegate
extension PPHandler : MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
        //browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
        
        let isPeerOnList = Global.shared.peers.contains(where: { $0.peerID == peerID })
        
        if !isPeerOnList {
            Global.shared.peers.append(Peer(peerID: peerID))
            //self.delegate?.pphandler(browser: self, foundPeer: peerID, withDiscoveryInfo: info)
            // Send Notification
            DispatchQueue.main.async { NotificationCenter.default.post(name: Notifications.MPCFoundPeer, object: nil, userInfo: nil) }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
        
        let allPeersButLostOne = Global.shared.peers.filter({$0.peerID == peerID})
        Global.shared.peers = allPeersButLostOne
        
        if let cp = Global.shared.connectedPeer, cp == peerID {
            Global.shared.connectedPeer = nil
        } else if let cp = Global.shared.connectingPeer, cp == peerID {
            Global.shared.connectingPeer = nil
        }
        
        //self.delegate?.pphandler(browser: self, lostPeer: peerID)
        DispatchQueue.main.async { NotificationCenter.default.post(name: Notifications.MPCLostPeer, object: nil, userInfo: nil) }
    }
    
}

// MARK: Session Delegate
extension PPHandler : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state.rawValue)")
        
        Global.shared.connectingPeer = nil
        Global.shared.connectedPeer = session.connectedPeers.first
        
        //self.delegate?.pphandler(session: self, didChange: state, peer: peerID)
        
        let userInfo = [Notifications.keyPeerID : peerID, Notifications.keyState : state.rawValue] as [String : Any]
        DispatchQueue.main.async { NotificationCenter.default.post(name: Notifications.MPCDidChangeState, object: nil, userInfo: userInfo) }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
        
        //self.delegate?.pphandler(session: self, didReceived: data, fromPeer: peerID)
        
        let str = String(data: data, encoding: .utf8)!
        let userInfo = [Notifications.keyPeerID : peerID, Notifications.keyData : str] as [String : Any]
        DispatchQueue.main.async { NotificationCenter.default.post(name: Notifications.MPCDidReceiveData, object: nil, userInfo: userInfo) }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
    
}
