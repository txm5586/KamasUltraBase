//
//  NearbyPeersTableViewController.swift
//  KamasUltra
//
//  Created by Tassio Moreira Marques on 14/12/2017.
//  Copyright © 2017 Tassio Marques. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class NearbyPeersTableViewController: UITableViewController {
    @IBOutlet weak var cancelButtonItem: UIBarButtonItem!
    @IBOutlet weak var doneButtomItem: UIBarButtonItem!
    
    // MARK: Properties
    private var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.ppService.delegate = self
        
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        self.tableView.reloadData()
        
        self.doneButtomItem.isEnabled = false
        
        // MARK: Notifications Observers
        NotificationCenter.default.addObserver(self, selector: #selector(NearbyPeersTableViewController.foundPeer(notification:)), name:Notifications.MPCFoundPeer, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(NearbyPeersTableViewController.lostPeer(notification:)), name:Notifications.MPCLostPeer, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(NearbyPeersTableViewController.didChangeState(notification:)), name:Notifications.MPCDidChangeState, object: nil);
    }
    
    // MARK: Actions
    @IBAction func cancelTapped(_ sender: Any) {
        Global.shared.connectingPeer = nil
        //self.presentingViewController?.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Notifications objc funcs
    @objc func foundPeer(notification: NSNotification) {
        self.tableView.reloadData()
    }
    
    @objc func lostPeer(notification: NSNotification) {
        self.tableView.reloadData()
    }
    
    @objc func didChangeState(notification: NSNotification) {
        let userInfo = NSDictionary(dictionary: notification.userInfo!)
        
        let peerID = userInfo.object(forKey: Notifications.keyPeerID) as! MCPeerID
        let state = userInfo.object(forKey: Notifications.keyState) as! Int
        
        if state == MCSessionState.notConnected.rawValue {
            self.updateDeclinedPeer(peerID: peerID)
        } else if state == MCSessionState.connected.rawValue {
            self.doneButtomItem.isEnabled = true
        }
        
        self.tableView.reloadData()
    }
    
    func updateDeclinedPeer(peerID: MCPeerID) {
        let peer = Global.shared.peers.filter({$0.peerID == peerID}).first!
        peer.state = PeerState.declined.rawValue
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Global.shared.peers.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cellIdentifier = "SearchingTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            return cell
        }
        
        // Cell for earch peer
        let cellIdentifier = "NearbyPeersTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NearbyPeersTableViewCell  else {
            fatalError("The dequeued cell is not an instance of NearbyPeersTableViewCell.")
        }
        
        // Configure the cell...
        let peer = Global.shared.peers[indexPath.row - 1]
        
        cell.peerID = peer.peerID
        cell.peerNameLabel.text = peer.peerID.displayName
        
        if let cntngPeer = Global.shared.connectingPeer, cntngPeer == cell.peerID {
            cell.stateLabel.text = PeerState.connecting.rawValue
        } else if let cntdPeer = Global.shared.connectedPeer, cntdPeer == cell.peerID {
            cell.stateLabel.text = PeerState.connected.rawValue
        } else if peer.state == PeerState.declined.rawValue {
            cell.stateLabel.text = PeerState.declined.rawValue
        } else {
            cell.stateLabel.text = ""
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Global.shared.connectingPeer != nil {
            return
        }
        
        tableView.reloadData()
        
        if indexPath.row > 0 {
            guard let cell = tableView.cellForRow(at: indexPath) as? NearbyPeersTableViewCell
                else { fatalError("The dequeued cell is not an instance of NearbyPeersTableViewCell.") }
            
            cell.stateLabel.text = PeerState.connecting.rawValue
            Global.shared.connectingPeer = cell.peerID
            
            let peers = Global.shared.peers.filter({$0.peerID == cell.peerID})
            let peer = peers.first!
            peer.state = PeerState.connecting.rawValue
            
            if let mcPeer = cell.peerID {
                //self.appDelegate.mpcHandler.invitePeer(peerID: mcPeer)
                self.appDelegate.ppService.invitePeer(peerID: mcPeer)
            }
            
            
        }
    }
}

extension NearbyPeersTableViewController : PPHandlerDelegate {
    func pphandler(browser manager: PPHandler, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
    }
    
    func pphandler(browser manager: PPHandler, lostPeer peerID: MCPeerID) {
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }
    }
    
    func pphandler(advertiser manager: PPHandler, didReceiveInvitationFromPeer peerID: MCPeerID,
                   withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
    }
    
    func pphandler(session manager: PPHandler, didReceived data: Data, fromPeer peerID: MCPeerID) {
    
    }
    
    func pphandler(session manager: PPHandler, didChange state: MCSessionState, peer peerID: MCPeerID) {
        OperationQueue.main.addOperation {
            if state == MCSessionState.notConnected {
                self.updateDeclinedPeer(peerID: peerID)
            } else {
                self.doneButtomItem.isEnabled = true
            }
            self.tableView.reloadData()
        }
    }
}

