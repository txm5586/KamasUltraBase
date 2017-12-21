//
//  ViewController.swift
//  KamasUltraBase
//
//  Created by Tassio Moreira Marques on 17/12/2017.
//  Copyright © 2017 Tassio Marques. All rights reserved.
//

import UIKit

class ReceiveNudesViewController: UIViewController {
    @IBOutlet weak var actionReceivedImage: UIImageView!
    @IBOutlet weak var bodyPartLabel: UILabel!
    
    public func checkActionReceived() {
        print("--------------------------- 2")
        print("------ Checking action \(Global.shared.actionReceived)")
        
        self.actionReceivedImage.image = UIImage(named: "\(Global.shared.actionReceived!)")
        bodyPartLabel.text = Global.shared.bodyPartReceived.rawValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("---------------------------")
        checkActionReceived()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(ReceiveNudesViewController.lostConnectionWithPeer(notification:)), name:Notifications.DidLostConnectionWithPeer, object: nil);
    }
    
    @objc func lostConnectionWithPeer(notification: NSNotification) {
        print(" -------- Is going to Unwind -------- ")
        unwindByLostOfConnection()
    }
    
    func unwindByLostOfConnection() {
        performSegue(withIdentifier: "unwindFromReceiveToPlay", sender: self)
    }
    
    @IBAction func acceptActionTapped(_ sender: Any) {
        if Global.shared.isMaster {
            performSegue(withIdentifier: "unwindToActionFromReceiveSegue", sender: self)
        } else {
            performSegue(withIdentifier: "goToActionFromGuestSegue", sender: self)
        }
        
    }
    
}
