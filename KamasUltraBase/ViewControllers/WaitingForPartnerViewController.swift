//
//  WaitingForPartnerViewController.swift
//  KamasUltra
//
//  Created by Cristiano Maria Coppotelli on 15/12/17.
//  Copyright © 2017 Tassio Marques. All rights reserved.
//

import UIKit

class WaitingForPartnerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateDot()
        countdownTick(self)
        countdownTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            sleep(15)
            UIView.animate(withDuration: 2.5, animations: {
                self.tipsLabel.alpha = 0.0
            })
        }
        
        if countdown == 0 {
            countdown = sexualTips.count
        }
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
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
