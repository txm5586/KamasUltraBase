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
    var viewControllerToInsertBelow : UIViewController?
    
    // MARK: Properties
    private var appDelegate: AppDelegate!
    
    var gradientLayer : CAGradientLayer!
    var lastGradientLayer = CAGradientLayer()
    
    var layerCounter = 1
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var waitWarningLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    
    var timer = Timer()
    
    // MARK: Override functions
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.waitWarningLabel.isHidden = true
        self.playButton.isEnabled = true
        
        verifyConnectedState()
        setButtonsTranformation()
        setGradientBackground()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.navigationController?.isNavigationBarHidden = true
        
        Global.shared.isMasterTurn = true
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(PlayViewController.didReceiveData(notification:)), name:Notifications.MPCDidReceiveData, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(PlayViewController.updateConnectedStatus(notification:)), name:Notifications.UpdateConnectedStatus, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(PlayViewController.updateConnectedStatus(notification:)), name:Notifications.MPCLostPeer, object: nil);
        
        self.backgroundView.layer.insertSublayer(lastGradientLayer, at: 0)
        setGradientBackground()
        //scheduledTimerWithTimeInterval()
    }
    
    // MARK: Internal functions
    func verifyConnectedState() {
        if let peer = Global.shared.connectedPeer {
            self.connectButton.setTitle("Playing with \(peer.displayName)", for: .normal)
            
            if Global.shared.isMaster {
                // Activate Play Button
                self.playButton.isEnabled = true
                self.waitWarningLabel.isHidden = true
            } else {
                self.playButton.isEnabled = false
                // Set label waiting for partner...
                self.waitWarningLabel.text = Constants.waitingPartnerWarning
                self.waitWarningLabel.isHidden = false
            }
            
        } else {
            self.waitWarningLabel.isHidden = true
            self.playButton.isEnabled = true
            self.connectButton.setTitle("Connect", for: .normal)
        }
    }
    
    func setButtonsTranformation() {
        self.connectButton.titleLabel?.textColor = UIColor.white
        self.connectButton.layer.shadowColor = UIColor.black.cgColor
        self.connectButton.layer.shadowOpacity = 1
        self.connectButton.layer.shadowOffset = CGSize.zero
        self.connectButton.layer.shadowRadius = 10
    }
    
    func setGradientBackground() {
        gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y:0.0)
        gradientLayer.endPoint = CGPoint(x:0.0, y:1.0)
        gradientLayer.colors = MoodConfig.getScreenGradient()
        
        if gradientLayer.colors?.count == 2 {
            gradientLayer.locations = [ 0.0, 1.0]
        } else if gradientLayer.colors?.count == 3 {
            gradientLayer.locations = [ 0.0, 0.5, 1.0]
        } else {
            gradientLayer.locations = [ 0.0, 0.25, 0.5, 0.75]
        }
        //gradientLayer.colors = [MoodConfig.gradientColor1,MoodConfig.gradientColor2]
        gradientLayer.frame = self.view.bounds
        
        //self.backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        self.backgroundView.layer.replaceSublayer(lastGradientLayer, with: gradientLayer)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.lastGradientLayer = self.gradientLayer
        //self.backgroundView.insertSubview(blurEffectView, at: 0)
    }
    
    @objc func getRandomColor() {
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
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 7,
                             target: self,
                             selector: #selector(self.getRandomColor),
                             userInfo: nil,
                             repeats: true)
    }
    
    // MARK: - Actions
    func tappedChangeBack(_ sender: Any) {
        //appDelegate.ppService.send(dataInfo: "color")
    }
    
    @IBAction func pantoneMoodTapped(_ sender: Any) {
    
    }
    
    @IBAction func setttingsTapped(_ sender: Any) {
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        
        self.overlayBlurredBackgroundView()
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        if Global.shared.connectedPeer == nil {
            self.waitWarningLabel.text = Constants.connectFirstWarning
            self.waitWarningLabel.isHidden = false
            return
        } else {
            let willStartPlaying = DataProtocol.prepareToStartGame()
            if self.appDelegate.ppService.send(dataInfo: willStartPlaying) {
                performSegue(withIdentifier: "startHostFlowSegue", sender: self)
            } else {
                self.waitWarningLabel.text = "Something happened, try again..."
            }
        }
    }
    
    // MARK: - Notifications objc funcs
    @objc func didReceiveData(notification: NSNotification) {
        let userInfo = NSDictionary(dictionary: notification.userInfo!)
        
        let peerID = userInfo.object(forKey: Notifications.keyPeerID) as! MCPeerID
        let data = userInfo.object(forKey: Notifications.keyData) as! String
        
        if let peer = Global.shared.connectedPeer, peer == peerID {
            let dictionary = DataProtocol.decodeData(data: data)
            
            let data = String(describing:dictionary["data"]!)
            
            if data == DataProtocol.gameStarted {
                performSegue(withIdentifier: "startGuestFlowSegue", sender: self)
            }
        }
    }
    
    @objc func updateConnectedStatus(notification: NSNotification) {
        verifyConnectedState()
    }
    
    
    // MARK: Segue preparation
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
    
    // MARK: Unwind Segues
    @IBAction func unwindToTeste(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindToPlayLostConnection(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func changeMood(_ sender: Any) {
        MoodConfig.changeMood(mood: .Excitement)
        self.setGradientBackground()
    }
}
