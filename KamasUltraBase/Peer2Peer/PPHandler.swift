// Copyright 2016-2017, Ralf Ebert
// License   https://opensource.org/licenses/MIT
// Source    https://www.ralfebert.de/tutorials/ios-swift-multipeer-connectivity/

import Foundation
import MultipeerConnectivity

// MARK: Protocol
protocol PPHandlerDelegate {
    func pphandler(browser manager : PPHandler, foundPeer peerID : MCPeerID, withDiscoveryInfo info: [String : String]?)
    func pphandler(browser manager : PPHandler, lostPeer peerID: MCPeerID)
    func pphandler(advertiser manager : PPHandler, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: (Bool, MCSession?))
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
    
}

// MARK: Advertiser Delegate
extension PPHandler : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, self.session)
    }
    
}

// MARK: Browser Delegate
extension PPHandler : MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
        NSLog("%@", "invitePeer: \(peerID)")
        //browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
        
        let isPeerOnList = Global.shared.peers.contains(where: { $0.peerID == peerID })
        
        if !isPeerOnList {
            Global.shared.peers.append(Peer(peerID: peerID))
            self.delegate?.pphandler(browser: self, foundPeer: peerID, withDiscoveryInfo: info)
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
        
        let lostPeers = Globals.shared.peers.filter({$0.peerID == peerID})
        Globals.shared.peers = peers
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: Notifications.MPCFoundPeer, object: nil, userInfo: nil)
        }
    }
    
}

// MARK: Session Delegate
extension PPHandler : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state)")
        //self.delegate?.connectedDevicesChanged(manager: self, connectedDevices:
        //    session.connectedPeers.map{$0.displayName})
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
        let str = String(data: data, encoding: .utf8)!
        //self.delegate?.dataSent(manager: self, dataInfo: str)
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
