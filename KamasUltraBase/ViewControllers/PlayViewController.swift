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
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(PlayViewController.didReceiveData(notification:)), name:Notifications.MPCDidReceiveData, object: nil);
    }
    
    // MARK: - Actions
    @IBAction func tappedChangeBack(_ sender: Any) {
        appDelegate.ppService.send(dataInfo: "color")
    }
    
    // MARK: - Notifications objc funcs
    @objc func didReceiveData(notification: NSNotification) {
        let userInfo = NSDictionary(dictionary: notification.userInfo!)
        
        let peerID = userInfo.object(forKey: Notifications.keyPeerID) as! MCPeerID
        let data = userInfo.object(forKey: Notifications.keyData) as! String
        
        if let peer = Global.shared.connectedPeer, peer == peerID {
            print("Changed by \(peer.displayName) with data \(data)")
            
            let rd = arc4random() % 5
            switch rd {
            case 0:
                self.view.backgroundColor = UIColor.cyan
            case 1:
                self.view.backgroundColor = UIColor.green
            case 2:
                self.view.backgroundColor = UIColor.blue
            case 3:
                self.view.backgroundColor = UIColor.brown
            case 4:
                self.view.backgroundColor = UIColor.purple
            case 5:
                self.view.backgroundColor = UIColor.gray
            default:
                self.view.backgroundColor = UIColor.black
            }
        }
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
    
    func pphandler(advertiser manager: PPHandler, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, manager.session)
    }
    
    func pphandler(browser manager: PPHandler, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
    }
    
    func pphandler(session manager: PPHandler, didReceived data: Data, fromPeer peerID: MCPeerID) {
        print("            ##### ##### ##### OK THIS LOOKS RIGHT")
        NSLog("%@", "didWentToChangeBackground: \(data)")
        OperationQueue.main.addOperation {
            self.view.backgroundColor = UIColor.purple
        }
    }
    
    func pphandler(browser manager: PPHandler, lostPeer peerID: MCPeerID) {
        
    }
}
