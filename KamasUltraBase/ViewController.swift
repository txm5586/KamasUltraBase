//
//  ViewController.swift
//  KamasUltraBase
//
//  Created by Tassio Moreira Marques on 16/12/2017.
//  Copyright © 2017 Tassio Marques. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController {
    private var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.ppService.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changeBackTapped(_ sender: Any) {
        appDelegate.ppService.send(dataInfo: "Any")
    }
    
    func change() {
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = UIColor.green
        }
    }
    
}

extension ViewController : PPHandlerDelegate {
    func pphandler(session manager: PPHandler, didChange state: MCSessionState, peer peerID: MCPeerID) {
        
    }
    
    func pphandler(advertiser manager: PPHandler, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: (Bool, MCSession?)) {
        
    }
    
    func pphandler(browser manager: PPHandler, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
    }
    
    func pphandler(session manager: PPHandler, didReceived data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func pphandler(browser manager: PPHandler, lostPeer peerID: MCPeerID) {
        
    }
}

