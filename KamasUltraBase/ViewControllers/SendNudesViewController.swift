//
//  SendNudesViewController.swift
//  KamasUltra
//
//  Created by Magali Granato on 18/12/2017.
//  Copyright © 2017 Tassio Marques. All rights reserved.
//

/*
 TODO:
 1. Remove - Reset Button
 3. Transition between screens - action and part of the body - INIT!
 4. Autolayout
 */

import UIKit
import AudioToolbox

class SendNudesViewController: UIViewController {
    var appDelegate: AppDelegate!
    
    var divisionParam: CGFloat!
    
    // GRADIENT COLORS
    var gradientStart = UIColor(red: 63/255.0, green: 94/255.0, blue: 251/255.0, alpha: 1)
    var gradientEnd = UIColor(red: 252/255.0, green: 70/255.0, blue: 107/255.0, alpha: 1)
    
   // @IBOutlet weak var waveVW: UIView!
     @IBOutlet weak var waveGif: UIImageView!
    @IBOutlet weak var semiCircleTrashButton: UIView!
    @IBOutlet weak var targetImageView: UIImageView!
    @IBOutlet weak var trashImageView: UIImageView!
    @IBOutlet weak var typeFire: UIImageView!
    @IBOutlet weak var typeActionImageView: UIImageView!
    @IBOutlet weak var partBodyLabel: UILabel!
    @IBOutlet weak var cardView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        configViews()
        configAction()
        configWave()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SendNudesViewController.lostConnectionWithPeer(notification:)), name:Notifications.DidLostConnectionWithPeer, object: nil);
    }
    
    @objc func lostConnectionWithPeer(notification: NSNotification) {
        print(" -------- Is going to Unwind -------- ")
        unwindByLostOfConnection()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configWave(){
        //wave gif - Rotated
        waveGif.transform = CGAffineTransform(rotationAngle: (
            CGFloat(Double.pi)))
        
        //Assing wave gif
        waveGif.loadGif(name: MoodConfig.currentMood.rawValue)
        waveGif.backgroundColor = UIColor.white
        waveGif.backgroundColor = UIColor.white
        
        //Target
        self.view.bringSubview(toFront: targetImageView)
        self.targetImageView.alpha = 0.2
        UIView.animate(withDuration: 1, delay: 0.8, options: [.curveLinear,.repeat, .autoreverse], animations: {
            self.targetImageView.alpha = 0.8 }, completion: nil)
    }
    
    func configAction(){
        partBodyLabel.text = Global.shared.selectedBodyPart.rawValue
        //let action = Globals.shared.selectedAction
        typeActionImageView.image = UIImage(named: "\(Global.shared.selectedAction!)")
        typeActionImageView.image = typeActionImageView.image!.withRenderingMode (UIImageRenderingMode.alwaysTemplate)
        typeActionImageView.tintColor = UIColor.white
    }
    
    func configCardView (){
        //CardView - Gradient
        let gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame.size = cardView.frame.size
        gradient.colors = MoodConfig.getScreenGradient()
        cardView.layer.insertSublayer(gradient, at: 0) //Position 0 => Back
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
    }
    
    func configViews(){
        divisionParam = (view.frame.size.width/2)/0.61
        
        //CardView
        cardView.layer.masksToBounds = true
        cardView.layer.cornerRadius = cardView.frame.size.width / 2
        self.view.sendSubview(toBack: cardView)
        
        configCardView()
        
        //Trash
        semiCircleTrashButton.layer.borderColor = UIColor.black.cgColor
        semiCircleTrashButton.layer.borderWidth = 1.5
        semiCircleTrashButton.layer.cornerRadius = semiCircleTrashButton.frame.width/2
        semiCircleTrashButton.clipsToBounds = true
        self.view.bringSubview(toFront: trashImageView)
   
    }
    
    func resetView() {
        cardView.center = self.view.center
        typeFire.image = #imageLiteral(resourceName: "fosforo")
        cardView.transform = .identity
    }
    
    @IBAction func panGestureValueChanged(_ sender: UIPanGestureRecognizer) {
        let cardView = sender.view!
        let translationPoint = sender.translation(in: view)
        
        cardView.center = CGPoint(x: view.center.x + translationPoint.x, y: view.center.y + translationPoint.y)
        
        let distanceMoved = cardView.center.y - view.center.y
        
        cardView.transform = CGAffineTransform(rotationAngle: distanceMoved/divisionParam)
        
        if sender.state == UIGestureRecognizerState.changed {
            let animation = CAKeyframeAnimation()
            animation.keyPath = "position.x"
            animation.values = [0, 10, -10, 10, -5, 5, -5, 0 ]
            animation.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1]
            animation.duration = 0.2
            animation.isAdditive = true
            
            cardView.layer.add(animation, forKey: "shake")
            
            if (cardView.center.y <  (view.frame.size.height/2)){ // UP
                configCardView()
                typeFire.image = #imageLiteral(resourceName: "fosforo")
             }else{
                configCardView()
                typeFire.image = #imageLiteral(resourceName: "fosforoOut")
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate) //Vibration
            }
        }
        
        if sender.state == UIGestureRecognizerState.ended {
            if (cardView.center.y <  (view.frame.size.height/2)){ // Moved to up
                UIView.animate(withDuration: 0.3, animations: {
                    cardView.center = CGPoint(x: cardView.center.x, y: cardView.center.y-550)
                })
                // MARK: Run Send Data App Delegate
                let data: String = DataProtocol.prepareToSendAction(action: Global.shared.selectedAction, body: Global.shared.selectedBodyPart)
                
                if self.appDelegate.ppService.send(dataInfo: data) {
                    performSegueCheckingFlow()
                } else {
                    // Reset View
                    resetView()
                }
                return
            }
            else if (cardView.center.y > (view.frame.size.height/4)) { // Moved to down
                UIView.animate(withDuration: 0.3, animations: {
                    cardView.center = CGPoint(x: cardView.center.x, y: cardView.center.y+600)
                })
                
                self.semiCircleTrashButton.alpha = 0.2
                UIView.animate(withDuration: 1, delay: 0.0, options: [.curveLinear, .autoreverse], animations: {
                    self.semiCircleTrashButton.alpha = 1.0 }, completion: nil)
                
                dismiss(animated: true, completion: nil)
                return
            }
        }
    }
    
    func performSegueCheckingFlow() {
        if Global.shared.isMaster {
            performSegue(withIdentifier: "goToActionFromHostSegue", sender: self)
        } else {
            // UNWIN TO WAITING SCREEN
            performSegue(withIdentifier: "unwindToActionFromSendSegue", sender: self)
        }
    }
    
    func unwindByLostOfConnection() {
        performSegue(withIdentifier: "uwindFromSendToPlay", sender: self)
    }
}
