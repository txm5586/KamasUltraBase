//
//  AnimatedBodyViewController.swift
//  KamasUltra
//
//  Created by Giovanni Ranieri on 13/12/2017.
//  Copyright © 2017 Tassio Marques. All rights reserved.
//

import UIKit
import AudioToolbox

class AnimatedBodyViewController: UIViewController {
    private var appDelegate: AppDelegate!
    
    @IBOutlet weak var waveView: UIView!
    @IBOutlet var actionButtons: [UIButton]!
    
    @IBOutlet weak var selectActionLabel: UILabel!
    var enableSwipe = 1 //if 1 enable the swipe to move the gradient and select the body part
    var enableTouch = 0 //if 1 enable the tap on the body when it's small to return fullscreen
    
    //Outlets of the body, label with the body part selected and confirm button
    @IBOutlet weak var transparentBodyOutlet: UIImageView!
    
    @IBOutlet weak var bodyPartLabel: UILabel!
    @IBOutlet weak var bodyVIew: UIView!
    @IBOutlet weak var confirmOutlet: UIButton!
    @IBOutlet weak var waveGif: UIImageView!
    @IBOutlet weak var bodyImage: UIImageView!
    
    @IBOutlet weak var kiss: UIButton!
    @IBOutlet weak var lick: UIButton!
    @IBOutlet weak var suck: UIButton!
    @IBOutlet weak var touch: UIButton!
    @IBOutlet weak var random: UIButton!
    
    
    //Parameters to give a location to the gradient and move it on the body
    var a: NSNumber = 0.00
    var b: NSNumber = 0.45
    var c: NSNumber = 0.50
    var d: NSNumber = 0.55
    var e: NSNumber = 1.00
    
    override func viewWillAppear(_ animated: Bool) {
        funcTap()
        
        bodyPartLabel.frame.origin.y = CGFloat(truncating: c) * UIScreen.main.bounds.height - 10
        
        let userDefaults = UserDefaults.standard
        let gender = userDefaults.integer(forKey: UserKey.gender)
        
        if gender == Constants.male {
            bodyImage.image = #imageLiteral(resourceName: "TransparentBodyMan")
        } else if gender == Constants.female {
            bodyImage.image = #imageLiteral(resourceName: "TransparentBodyWoman")
        }
        
        //Assing wave gif
        //MoodConfig.changeMood(mood: <#T##Mood#>)
        let mood = UserDefaults.standard.string(forKey: UserKey.mood)
        
        waveGif.loadGif(name: mood!)
        waveGif.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        createGradientLayer()
       
        //Crate the tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(funcTap))
        self.bodyVIew.addGestureRecognizer(tap) //Add the tap gesture recognizerer to the body
        
        NotificationCenter.default.addObserver(self, selector: #selector(AnimatedBodyViewController.lostConnectionWithPeer(notification:)), name:Notifications.DidLostConnectionWithPeer, object: nil);
    }
    
    @objc func lostConnectionWithPeer(notification: NSNotification) {
        unwindByLostOfConnection()
    }
    
    //Hide the status bar
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var gradientLayer: CAGradientLayer!
    
    //func called in the viewDidLoad to create the gradient on the body
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = bodyVIew.bounds
        gradientLayer.colors = [MoodConfig.gradientColor1,MoodConfig.gradientColor2,UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor, MoodConfig.gradientColor3,MoodConfig.gradientColor4]
        gradientLayer.locations = [a,b,c,d,e]
        gradientLayer.speed = 1000 //made the speed of the gradient bigger to make it follow the tap without delay
        bodyVIew.layer.addSublayer(gradientLayer)
    }
    
    //func called when the user touches the body to move the gradient
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //if the swipe is enabled move the red line of the gradient depending on the y of the user's touch on the body
        if enableSwipe == 1 {
            for touch in touches {
                let touchLocation = touch.location(in: bodyVIew)
                if touchLocation.x < 190 && touchLocation.x > 0 {
                    if touchLocation.y < 620 && touchLocation.y > 3 {
                        c = touchLocation.y / 625 as NSNumber
                        b = Double(truncating: c) - 0.05 as NSNumber
                        d = Double(truncating: c) + 0.05 as NSNumber
                        gradientLayer.locations = [a,b,c,d,e]
                        
                        //made the label follow the red line
                        bodyPartLabel.frame.origin.y = CGFloat(Double(truncating: c) * 625 + 10)
                    }
                }
                
                //give differents body parts to the bodyPartLabel depending on the y of the white part of the gradient
                switch Double(truncating: c) {
                case 0..<0.07 :
                    bodyPartLabel.text = BodyPart.Head.rawValue
                case 0.07..<0.095 :
                    bodyPartLabel.text = BodyPart.Ears.rawValue
                case 0.095..<0.12 :
                    bodyPartLabel.text = BodyPart.Mouth.rawValue
                case 0.12..<0.16 :
                    bodyPartLabel.text = BodyPart.Neck.rawValue
                case 0.16..<0.22 :
                    bodyPartLabel.text = BodyPart.Shoulders.rawValue
                case 0.22..<0.31 :
                    bodyPartLabel.text = BodyPart.Chest.rawValue
                case 0.31..<0.36 :
                    bodyPartLabel.text = BodyPart.Arms.rawValue
                case 0.36..<0.42 :
                    bodyPartLabel.text = BodyPart.Abdomin.rawValue
                case 0.42..<0.52 :
                    bodyPartLabel.text = BodyPart.Waist.rawValue
                    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate) //Vibration
                case 0.52..<0.59 :
                    bodyPartLabel.text = BodyPart.Hands.rawValue
                case 0.59..<0.71 :
                    bodyPartLabel.text = BodyPart.Legs.rawValue
                case 0.71..<0.75 :
                    bodyPartLabel.text = BodyPart.Knees.rawValue
                case 0.75..<0.95 :
                    bodyPartLabel.text = BodyPart.Legs.rawValue
                case 0.95...1 :
                    bodyPartLabel.text = BodyPart.Feet.rawValue
                default:
                    break
                }
                
            }
        }
    }
    
    @IBAction func confirmButton(_ sender: UIButton) {
        let screenSize = UIScreen.main.bounds
        
        //Animations to make the body smaller when user clicks the confirm button and move it on the top of the screen
        UIView.animate(withDuration: 1, animations: {
            
            self.transparentBodyOutlet.transform = CGAffineTransform(scaleX: 0.73, y: 0.73)
            self.transparentBodyOutlet.frame.origin.y = CGFloat(20)
            
            self.bodyVIew.transform = CGAffineTransform(scaleX: 0.73, y: 0.73)
            self.bodyVIew.frame.origin.y = CGFloat(20)
            
            //The label follows the red line
            self.bodyPartLabel.frame.origin.y = CGFloat(Double(truncating: self.c) * 450 + 10)
            
            self.confirmOutlet.alpha = 0.0 //The button disappears
            
            
            self.waveView.frame.origin.y = screenSize.height - self.waveView.frame.height
            // self.selectActionLabel.frame.origin.y = CGFloat(620) //"Select the action" label appears from below
            //self.waveGif.frame.origin.y = CGFloat(497) //Wave appears from below
            
            //Buttons appear from below
            //self.kiss.frame.origin.y = CGFloat(558)
            //self.lick.frame.origin.y = CGFloat(558)
            //self.suck.frame.origin.y = CGFloat(555)
            //self.touch.frame.origin.y = CGFloat(555)
            //self.random.frame.origin.y = CGFloat(555)
        })
        
        enableSwipe = 0 //Disable the swipe of the red line
        enableTouch = 1 //Enable the touch to make the body bigger again
        
        Global.shared.selectedBodyPart = BodyPart(rawValue: bodyPartLabel.text!)
    }
    
    @IBAction func actionTapped(_ sender: UIButton) {
        Global.shared.selectedBodyPart = BodyPart(rawValue: bodyPartLabel.text!)
        
        if sender.tag == Action.random.rawValue {
            Global.shared.selectedAction = Action(rawValue: Int(arc4random() % 4))
        } else {
            Global.shared.selectedAction = Action(rawValue: sender.tag)
        }
        
        performSegue(withIdentifier: "goToSendActionSegue", sender: self)
    }
    
    
    //function of the tap gesture on the body to make it bigger and move it in the center of the screen
    @objc func funcTap() {
        let screenSize = UIScreen.main.bounds
        
        if enableTouch == 1 {
            UIView.animate(withDuration: 1, animations: {
                
                self.transparentBodyOutlet.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.transparentBodyOutlet.frame.origin.y = CGFloat(20)
                
                self.bodyVIew.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.bodyVIew.frame.origin.y = CGFloat(20)
                
                //The label follows the red line
                self.bodyPartLabel.frame.origin.y = CGFloat(Double(truncating: self.c) * 625 + 10)
                
                self.confirmOutlet.alpha = 1.0 //The confirm button appears
                
                self.waveView.frame.origin.y = screenSize.height
                
                //self.waveGif.frame.origin.y = CGFloat(667) //Wave goes down
                //self.selectActionLabel.frame.origin.y = CGFloat(700)
                
                //Buttons disappear below
                //self.kiss.frame.origin.y = CGFloat(755)
                //self.lick.frame.origin.y = CGFloat(755)
                //self.suck.frame.origin.y = CGFloat(755)
                //self.touch.frame.origin.y = CGFloat(755)
                //self.random.frame.origin.y = CGFloat(755)
            })
            enableSwipe = 1 //Enable the swipe of the red line
            enableTouch = 0 //Disable the touch to make the body bigger again
        }
    }
    
    func unwindByLostOfConnection() {
        Global.log(className: self.theClassName, msg: "Is going to Unwind")
        performSegue(withIdentifier: "uwindFromBodyToPlay", sender: self)
    }
    
    @IBAction func disconnectTapped(_ sender: Any) {
        self.appDelegate.ppService.disconnectPeer()
        self.unwindByLostOfConnection()
    }
    
    @IBAction func unwindToAnimatedBodyFlow(segue:UIStoryboardSegue) {
        Global.log(className: self.theClassName, msg: "<-- Did Unwind to Animeted Body")
        Global.shared.isMasterTurn = !Global.shared.isMasterTurn
        /*if Global.shared.isMaster {
            Global.shared.isMasterTurn = true
        } else {
            Global.shared.isMasterTurn = false
        }*/
    }
}
