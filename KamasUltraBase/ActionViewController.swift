//
//  ABCViewController.swift
//  KamasUltraBase
//
//  Created by Tassio Moreira Marques on 19/12/2017.
//  Copyright © 2017 Tassio Marques. All rights reserved.
//

import UIKit

class ActionViewController: UIViewController, CAAnimationDelegate {
    
    var gradientLayer: CAGradientLayer!
    var fromValue = [MoodConfig.gradientColor1,
                     MoodConfig.gradientColor2,
                     MoodConfig.gradientColor3,
                     MoodConfig.gradientColor4]
    var toValue = [MoodConfig.gradientColor3,
                   MoodConfig.gradientColor4,
                   MoodConfig.gradientColor1,
                   MoodConfig.gradientColor2]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("whats happenings?")
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(ActionViewController.lostConnectionWithPeer(notification:)), name:Notifications.DidLostConnectionWithPeer, object: nil);
        
        changeBackground()
        transitionGradients()
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
