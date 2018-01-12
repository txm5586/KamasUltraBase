//
//  ABCViewController.swift
//  KamasUltraBase
//
//  Created by Tassio Moreira Marques on 19/12/2017.
//  Copyright © 2017 Tassio Marques. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ActionViewController: UIViewController, CAAnimationDelegate {
    var isTouchActive = false
    
    var gradientLayer: CAGradientLayer!
    var fromValue = [MoodConfig.gradientColor1,
                     MoodConfig.gradientColor2,
                     MoodConfig.gradientColor3,
                     MoodConfig.gradientColor4]
    var toValue = [MoodConfig.gradientColor3,
                   MoodConfig.gradientColor4,
                   MoodConfig.gradientColor1,
                   MoodConfig.gradientColor2]
    
    private var appDelegate: AppDelegate!
    
    override func viewWillAppear(_ animated: Bool) {
        if Global.isHost() {
            self.isTouchActive = false
        } else {
            let dataInfo = DataProtocol.prepareToChangeToAction()
            let _ = self.appDelegate.ppService.send(dataInfo: dataInfo)
            self.isTouchActive = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.isTouchActive = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(ActionViewController.lostConnectionWithPeer(notification:)), name:Notifications.DidLostConnectionWithPeer, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(ActionViewController.didReceiveDataFromPeer(notification:)), name:Notifications.MPCDidReceiveData, object: nil);
        
        changeBackground()
        transitionGradients()
    }

    
    @objc func didReceiveDataFromPeer(notification: NSNotification) {
        Global.log(className: self.theClassName, msg: "Received Data")
        let userInfo = NSDictionary(dictionary: notification.userInfo!)
        
        let peerID = userInfo.object(forKey: Notifications.keyPeerID) as! MCPeerID
        let data = userInfo.object(forKey: Notifications.keyData) as! String
        
        if let peer = Global.shared.connectedPeer, peer == peerID {
            let dictionary = DataProtocol.decodeData(data: data)
            let data = String(describing:dictionary["data"]!)
            if data == DataProtocol.actionScreenFinished {
                findRouteForSegue()
            } else if data == DataProtocol.guestChangedToAction {
                self.isTouchActive = true
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func lostConnectionWithPeer(notification: NSNotification) {
        unwindByLostOfConnection()
    }
    
    func unwindByLostOfConnection() {
        Global.log(className: self.theClassName, msg: "Is going to Unwind")
        performSegue(withIdentifier: "unwindFromActionToPlay", sender: self)
    }
    
    func findRouteForSegue() {
        // The change turn is going to be performed only after the unwind works (on the unwind function)
        // For "restarts", or normal flow, the turn changes at this same function
        //Global.shared.isMasterTurn = !Global.shared.isMasterTurn
        
        if Global.shared.isMaster {
            // Check Turn
            // IF TURN
            // UNWIND AS HOST
            if !Global.shared.isMasterTurn {
                Global.log(className: self.theClassName, msg: "Is going to unwind as Host")
                performSegue(withIdentifier: "unwindAsHostSegue", sender: self)
            } else {
                Global.log(className: self.theClassName, msg: "Is going to restart as guest")
                Global.shared.isMasterTurn = !Global.shared.isMasterTurn
                if Global.shared.turnCounter == 0 {
                    Global.shared.turnCounter += 1
                    performSegue(withIdentifier: "restartAsGuestSegue", sender: self)
                }
                else {
                    performSegue(withIdentifier: "unwindAsGuestSegue", sender: self)
                }
            }
            // IF NOT TURN
        } else {
            // Check Turn
            // IF TURN
            
            if !Global.shared.isGuestTurn {
                Global.log(className: self.theClassName, msg: "Is going to restart as host")
                Global.shared.isGuestTurn = !Global.shared.isGuestTurn
                if Global.shared.turnCounter == 0 {
                    Global.shared.turnCounter += 1
                    performSegue(withIdentifier: "restartAsHostSegue", sender: self)
                }
                else {
                    performSegue(withIdentifier: "unwindAsHostSegue", sender: self)
                }
                
            } else {
                // IF NOT TURN
                // UNWIND AS GUEST
                Global.log(className: self.theClassName, msg: "Is going to uwind as Guest")
                performSegue(withIdentifier: "unwindAsGuestSegue", sender: self)
            }
            
        }
    }
    
    @IBAction func keepPlayingTapped(_ sender: Any) {
        if !self.isTouchActive {
            return
        }
        
        let dataInfo = DataProtocol.prepareToFinishAction()
        let _ = self.appDelegate.ppService.send(dataInfo: dataInfo)
        
        findRouteForSegue()
    }
    
    func changeBackground () {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [MoodConfig.gradientColor1,
                                MoodConfig.gradientColor2,
                                MoodConfig.gradientColor3,
                                MoodConfig.gradientColor4]
        gradientLayer.locations = [0,0.45,0.55,1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.addSublayer(gradientLayer)
    }
    
    func transitionGradients () {
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.delegate = self
        gradientChangeAnimation.duration = 5.0
        gradientChangeAnimation.fromValue = fromValue
        gradientChangeAnimation.toValue = toValue
        gradientChangeAnimation.fillMode = kCAFillModeForwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradientLayer.add(gradientChangeAnimation, forKey: "colorChange")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let swapFromValue = fromValue
        fromValue = toValue
        toValue = swapFromValue
        transitionGradients()
    }
    
    @IBAction func unwindToActionFlow(segue:UIStoryboardSegue) {
        
    }
    
}
