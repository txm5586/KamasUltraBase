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
   
    @IBOutlet weak var myView: UIView!
    
    public func checkActionReceived() {
        Global.log(className: self.theClassName, msg: "Checking action \(Global.shared.actionReceived)")
        
        self.actionReceivedImage.image = UIImage(named: "\(Global.shared.actionReceived!)")
        bodyPartLabel.text = Global.shared.bodyPartReceived.rawValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkActionReceived()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(ReceiveNudesViewController.lostConnectionWithPeer(notification:)), name:Notifications.DidLostConnectionWithPeer, object: nil);
        
        createGradientLayer()
        
    }
    
    var gradientLayer: CAGradientLayer!
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = myView.bounds
        gradientLayer.colors = [MoodConfig.gradientColor1,MoodConfig.gradientColor2, MoodConfig.gradientColor3,MoodConfig.gradientColor4]
        myView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @objc func lostConnectionWithPeer(notification: NSNotification) {
        unwindByLostOfConnection()
    }
    
    func unwindByLostOfConnection() {
        Global.log(className: self.theClassName, msg: "Is going to Unwind")
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
