//
//  PlayViewController.swift
//  KamasUltra
//
//  Created by Tassio Moreira Marques on 14/12/2017.
//  Copyright © 2017 Tassio Marques. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class PlayViewController: UIViewController, SettingsTableViewControllerDelegate {
    private var appDelegate: AppDelegate!
    
    var gradientLayer : CAGradientLayer!
    var layerCounter = 1
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var playButtonView: UIView!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var connectButton: UIButton!
    
    var timer = Timer()
    
    override func viewWillAppear(_ animated: Bool) {
        verifyConnectedState()
        setButtonsTranformation()
        setGradientBackground()
        self.navigationController?.isNavigationBarHidden = true
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
        playButtonView.layer.cornerRadius = 40.0
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
        let colorA = UIColor(hex: 0xFC466B).cgColor
        let colorB = UIColor(hex: 0x3F5EFB).cgColor
        
        gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y:0.0)
        gradientLayer.endPoint = CGPoint(x:0.0, y:1.0)
        gradientLayer.colors = [ colorA, colorB]
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //self.backgroundView.insertSubview(blurEffectView, at: 0)
    }
    
    @objc func getRandomColor() {
        print("Oi")
        var red   = CGFloat((arc4random() % 56) + 200) / 255.0
        var green = CGFloat((arc4random() % 256) + 0) / 255.0
        var blue  = CGFloat((arc4random() % 256) + 0) / 255.0
        
        let colorTop = UIColor(red: red, green: green, blue: blue, alpha: 1.0).cgColor
        
        red   = CGFloat((arc4random() % 256) + 0) / 255.0
        green = CGFloat((arc4random() % 256) + 0) / 255.0
        blue  = CGFloat((arc4random() % 56) + 200) / 255.0
        
        let colorBottom = UIColor(red: red, green: green, blue: blue, alpha: 1.0).cgColor
        
        gradientLayer.colors = [ colorTop, colorBottom, colorTop]
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        UIView.animate(withDuration: 1, delay: 0.0, options:[.transitionCrossDissolve], animations: {
            self.backgroundView.layer.insertSublayer(self.gradientLayer, at: UInt32(self.layerCounter))
        }, completion:nil)
        layerCounter += 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.navigationController?.isNavigationBarHidden = true
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(PlayViewController.didReceiveData(notification:)), name:Notifications.MPCDidReceiveData, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(PlayViewController.updateConnectedStatus(notification:)), name:Notifications.UpdateConnectedStatus, object: nil);
        
        setGradientBackground()
        //scheduledTimerWithTimeInterval()
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 7,
                             target: self,
                             selector: #selector(self.getRandomColor),
                             userInfo: nil,
                             repeats: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Actions
    func tappedChangeBack(_ sender: Any) {
        appDelegate.ppService.send(dataInfo: "color")
    }
    
    @IBAction func pantoneMoodTapped(_ sender: Any) {
    
    }
    
    @IBAction func setttingsTapped(_ sender: Any) {
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        
        self.overlayBlurredBackgroundView()
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
    
    func overlayBlurredBackgroundView() {
        
        let blurredBackgroundView = UIVisualEffectView()
        
        blurredBackgroundView.frame = view.frame
        blurredBackgroundView.effect = UIBlurEffect(style: .dark)
        
        view.addSubview(blurredBackgroundView)
        
    }
    
    func removeBlurredBackgroundView() {
        
        for subview in view.subviews {
            if subview.isKind(of: UIVisualEffectView.self) {
                subview.removeFromSuperview()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "SettingTableView" {
                if let viewController = segue.destination as? SettingsTableViewController {
                    viewController.delegate = self
                    viewController.modalPresentationStyle = .overFullScreen
                }
            }
        }
    }

}
