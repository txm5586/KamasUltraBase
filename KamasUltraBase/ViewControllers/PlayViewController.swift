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
    
    
    @IBOutlet weak var playButtonView: UIView!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var connectButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        verifyConnectedState()
        setButtonsTranformation()
        setGradientBackground()
    }
    
    func verifyConnectedState() {
        if let peer = Global.shared.connectedPeer {
            connectButton.setTitle("Playing with \(peer.displayName)", for: .normal)
        } else {
            connectButton.setTitle("Connect", for: .normal)
        }
    }
    
    func setButtonsTranformation() {
        playButtonView.backgroundColor = UIColor.white
        playButtonView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 0.25)
        playButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi * 0.25)
        
        playButtonView.layer.shadowColor = UIColor.black.cgColor
        playButtonView.layer.shadowOpacity = 1
        playButtonView.layer.shadowOffset = CGSize.zero
        playButtonView.layer.shadowRadius = 10
        
        connectButton.titleLabel?.textColor = UIColor.white
        connectButton.layer.shadowColor = UIColor.black.cgColor
        connectButton.layer.shadowOpacity = 1
        connectButton.layer.shadowOffset = CGSize.zero
        connectButton.layer.shadowRadius = 10
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 252.0/255.0, green: 70.0/255.0, blue: 107.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 63.0/255.0, green: 94.0/255.0, blue: 251.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.navigationController?.isNavigationBarHidden = true
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(PlayViewController.didReceiveData(notification:)), name:Notifications.MPCDidReceiveData, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(PlayViewController.updateConnectedStatus(notification:)), name:Notifications.UpdateConnectedStatus, object: nil);
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
    
    @objc func updateConnectedStatus(notification: NSNotification) {
        verifyConnectedState()
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
