//
//  ABCViewController.swift
//  KamasUltraBase
//
//  Created by Tassio Moreira Marques on 19/12/2017.
//  Copyright © 2017 Tassio Marques. All rights reserved.
//

import UIKit

class ActionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("whats happenings?")
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(ActionViewController.lostConnectionWithPeer(notification:)), name:Notifications.DidLostConnectionWithPeer, object: nil);
        
        skipActionScreen()
    }
    
    func skipActionScreen() {
        Global.shared.isMasterTurn = !Global.shared.isMasterTurn
        
        if Global.shared.isMaster {
            // Check Turn
            // IF TURN
            // UNWIND AS HOST
            if Global.shared.isMasterTurn {
                print("----- Is going unwind as Host ------")
                performSegue(withIdentifier: "unwindAsHostSegue", sender: self)
            } else {
                print("----- Is going to restard as guest ------")
                performSegue(withIdentifier: "restartAsGuestSegue", sender: self)
            }
            // IF NOT TURN
            
        } else {
            // Check Turn
            // IF TURN
            if !Global.shared.isMasterTurn {
                performSegue(withIdentifier: "restartAsHostSegue", sender: self)
                // IF NOT TURN
                // UNWIND AS GUEST
            } else {
                performSegue(withIdentifier: "unwindAsGuestSegue", sender: self)
            }
        }
    }
    
    @objc func lostConnectionWithPeer(notification: NSNotification) {
        print(" -------- Is going to Unwind -------- ")
        unwindByLostOfConnection()
    }
    
    func unwindByLostOfConnection() {
        performSegue(withIdentifier: "unwindFromActionToPlay", sender: self)
    }
    
    @IBAction func keepPlayingTapped(_ sender: Any) {
        Global.shared.isMasterTurn = !Global.shared.isMasterTurn
        
        if Global.shared.isMaster {
            // Check Turn
            // IF TURN
                // UNWIND AS HOST
            if Global.shared.isMasterTurn {
                print("----- Is going unwind as Host ------")
                performSegue(withIdentifier: "unwindAsHostSegue", sender: self)
            } else {
                print("----- Is going to restard as guest ------")
                performSegue(withIdentifier: "restartAsGuestSegue", sender: self)
            }
            // IF NOT TURN
            
        } else {
            // Check Turn
            // IF TURN
            if !Global.shared.isMasterTurn {
                performSegue(withIdentifier: "restartAsHostSegue", sender: self)
            // IF NOT TURN
                // UNWIND AS GUEST
            } else {
                performSegue(withIdentifier: "unwindAsGuestSegue", sender: self)
            }
        }
    }
    
    @IBAction func unwindToActionFlow(segue:UIStoryboardSegue) {
        
    }

}
