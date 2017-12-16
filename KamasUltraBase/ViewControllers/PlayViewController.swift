//
//  PlayViewController.swift
//  KamasUltra
//
//  Created by Tassio Moreira Marques on 14/12/2017.
//  Copyright © 2017 Tassio Marques. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class PlayViewController: UIViewController {
    private var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.ppService.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(PlayViewController.receivedData(notification:)),
                                               name:Notifications.MPCReceiveData, object: nil);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedChangeBack(_ sender: Any) {
        self.appDelegate.ppService.send(dataInfo: "Any")
    }
    
    @objc func receivedData(notification: NSNotification) {
        self.view.backgroundColor = UIColor.green
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PlayViewController : PPHandlerDelegate {
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
