//
//  WaitingForPartnerViewController.swift
//  KamasUltra
//
//  Created by Cristiano Maria Coppotelli on 15/12/17.
//  Copyright © 2017 Tassio Marques. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class WaitingForPartnerViewController: UIViewController {
    private var appDelegate: AppDelegate!
    @IBOutlet weak var waitingLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        self.waitingLabel.text = Global.shared.connectedPeer?.displayName ?? " "
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        animateDot()
        countdownTick(self)
        countdownTimer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(WaitingForPartnerViewController.lostConnectionWithPeer(notification:)), name:Notifications.DidLostConnectionWithPeer, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(WaitingForPartnerViewController.didReceiveDataFromPeer(notification:)), name:Notifications.MPCDidReceiveData, object: nil);
    }
    
    // It could be a protocol!
    @objc func lostConnectionWithPeer(notification: NSNotification) {
        unwindByLostOfConnection()
    }
    
    @objc func didReceiveDataFromPeer(notification: NSNotification) {
        Global.log(className: self.theClassName, msg: "Received Data")
        let userInfo = NSDictionary(dictionary: notification.userInfo!)
        
        let peerID = userInfo.object(forKey: Notifications.keyPeerID) as! MCPeerID
        let data = userInfo.object(forKey: Notifications.keyData) as! String
        
        if let peer = Global.shared.connectedPeer, peer == peerID {
            let dictionary = DataProtocol.decodeData(data: data)
            
            let data = String(describing:dictionary["data"]!)
            
            if data == DataProtocol.actionSent {
                Global.shared.actionReceived = dictionary["action"] as! Action
                Global.shared.bodyPartReceived = dictionary["body"] as! BodyPart
                
                performSegue(withIdentifier: "goToReceiveActionSegue", sender: self)
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func countdownTimer() {
        timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(WaitingForPartnerViewController.countdownTick), userInfo: nil, repeats: true)
    }
    
    
    @objc func countdownTick(_ sender: AnyObject) {
        countdown -= 1
        // fade in
        UIView.animate(withDuration: 2.5, animations: {
            let tipIndex = Int(arc4random()) % self.sexualTips.count
            self.tipsLabel.text = self.sexualTips[tipIndex]
            self.tipsLabel.alpha = 0.6
        })
        { (true) in
            // fade out
            //sleep(15)
            UIView.animate(withDuration: 2.5, animations: {
                self.tipsLabel.alpha = 0.0
            })
        }
        
        if countdown == 0 {
            countdown = sexualTips.count
        }
    }
    
    func unwindByLostOfConnection() {
        Global.log(className: self.theClassName, msg: "Is going to Unwind")
        performSegue(withIdentifier: "unwindFromWaitToPlay", sender: self)
    }
    
    @IBAction func disconnectTapped(_ sender: Any) {
        self.appDelegate.ppService.disconnectPeer()
        self.unwindByLostOfConnection()
    }
    
    @IBAction func unwindToWaitingBodyFlow(segue:UIStoryboardSegue) {
        Global.log(className: self.theClassName, msg: "<-- Did Unwind to Waiting")
        Global.shared.isMasterTurn = !Global.shared.isMasterTurn
        /*if Global.shared.isMaster {
            Global.log(className: self.theClassName, msg: "** Is NOT my turn")
            Global.shared.isMasterTurn = false
        } else {
            Global.log(className: self.theClassName, msg: "** IT IS MY TURN")
            Global.shared.isMasterTurn = true
        }*/
    }
    
    func animateDot () -> Void {
        let dotSpring = CASpringAnimation(keyPath: "transform.scale")
        dotSpring.duration = 0.6
        dotSpring.fromValue = 1.0
        dotSpring.toValue = 1.12
        dotSpring.autoreverses = true
        dotSpring.repeatCount = 1
        dotSpring.initialVelocity = 0.5
        dotSpring.damping = 0.8
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 2.7
        animationGroup.repeatCount = 1000
        animationGroup.animations = [dotSpring]
        springingDot.layer.add(animationGroup, forKey: "pulse")
    }
    
    @IBOutlet weak var springingDot: UIImageView!
    @IBOutlet weak var tipsLabel: UILabel!
    var sexualTips: [String] = ["Touching your partner increases intimacy.",
                                "Think about what surrounds and try to create an atmosphere for intimacy.",
                                "Eating fruits while foreplay increases enjoyness",
                                "Massaging the partner is a great way to increase intimacy and sensuality",
                                "Try keeping eye contact with your partner.\n\nIt is a great way to connect and create more intimacy"]
    var timer: Timer? = nil
    var countdown: Int = 5
}
