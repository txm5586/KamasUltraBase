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
    var connecting : Bool = false
    private var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.ppService.delegate = self
    
        // Setup Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(NearbyPeersTableViewController.foundPeer(notification:)),
                                               name:Notifications.MPCFoundPeer, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(NearbyPeersTableViewController.didChangeState(notification:)),
                                               name:Notifications.MPCDidChangeState, object: nil);
        
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        self.tableView.reloadData()
        
        self.doneButtomItem.isEnabled = false
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    // MARK: - Handles table found and lost peers notifications
    
    @objc func foundPeer(notification: NSNotification) {
        self.tableView.reloadData()
        
        /*
        let userInfo = NSDictionary(dictionary: notification.userInfo!)
        let peerID = userInfo.object(forKey: "peerID") as! MCPeerID
        
        print("We are in: \(peerID.displayName)")
        
        appDelegate.peers.append(Peer(peerID: peerID))
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath(row: appDelegate.peers.count-1, section: 0)], with: .automatic)
        self.tableView.endUpdates()*/
    }
    
    @objc func didChangeState(notification: NSNotification) {
        //let userInfo = NSDictionary(dictionary: notification.userInfo!)
        
        //let state = userInfo.object(forKey: "state") as! Int
        //let peerID = userInfo.object(forKey: "peerID") as! MCPeerID
        self.tableView.reloadData()
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
        cell.stateLabel.text = peer.state
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if connecting {
            return
        }
        
        tableView.reloadData()
        
        if indexPath.row > 0 {
            guard let cell = tableView.cellForRow(at: indexPath) as? NearbyPeersTableViewCell
                else { fatalError("The dequeued cell is not an instance of NearbyPeersTableViewCell.") }
            
            cell.stateLabel.text = PeerState.connecting.rawValue
            
            self.connecting = true
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
        
    }
    
    func pphandler(advertiser manager: PPHandler, didReceiveInvitationFromPeer peerID: MCPeerID,
                   withContext context: Data?, invitationHandler: (Bool, MCSession?)) {
        
    }
    
    func pphandler(session manager: PPHandler, didReceived data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func pphandler(session manager: PPHandler, didChange state: MCSessionState, peer peerID: MCPeerID) {
        
    }
}

