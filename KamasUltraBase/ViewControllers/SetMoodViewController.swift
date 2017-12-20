//
//  SetMoodViewController.swift
//  KamasUltra
//
//  Created by Miky Pane on 15/12/17.
//  Copyright © 2017 Tassio Marques. All rights reserved.
//

import UIKit

class SetMoodViewController: UIViewController {
    
    @IBOutlet weak var TickImage: UIImageView!
    
//    @IBAction func defaultButton(_ sender: Any) {
//        Mood.gradientColor1 = UIColor(red: 25/255, green: 42/255, blue: 240/255, alpha: 1).cgColor
//        Mood.gradientColor2 = UIColor(red: 248/255, green: 26/255, blue: 53/255, alpha: 1).cgColor
//        Mood.gradientColor3 = UIColor(red: 248/255, green: 26/255, blue: 53/255, alpha: 1).cgColor
//        Mood.gradientColor4 = UIColor(red: 25/255, green: 42/255, blue: 240/255, alpha: 1).cgColor
//        Mood.moodGif = "default"
//        TickImage.frame.origin.x = CGFloat(25)
//        TickImage.frame.origin.y = CGFloat(79)
//    }
//
//    @IBAction func luxury(_ sender: Any) {
//        Mood.gradientColor1 = UIColor(red: 3/255, green: 0/255, blue: 30/255, alpha: 1).cgColor
//        Mood.gradientColor2 = UIColor(red: 115/255, green: 3/255, blue: 192/255, alpha: 1).cgColor
//        Mood.gradientColor3 = UIColor(red: 236/255, green: 56/255, blue: 188/255, alpha: 1).cgColor
//        Mood.gradientColor4 = UIColor(red: 253/255, green: 239/255, blue: 249/255, alpha: 1).cgColor
//        Mood.moodGif = "luxury"
//        TickImage.frame.origin.x = CGFloat(211)
//        TickImage.frame.origin.y = CGFloat(79)
//    }
//
//    @IBAction func misteryButton(_ sender: Any) {
//        Mood.gradientColor1 = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
//        Mood.gradientColor2 = UIColor(red: 83/255, green: 52/255, blue: 109/255, alpha: 1).cgColor
//        Mood.gradientColor3 = UIColor(red: 83/255, green: 52/255, blue: 109/255, alpha: 1).cgColor
//        Mood.gradientColor4 = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
//        Mood.moodGif = "mistery"
//        TickImage.frame.origin.x = CGFloat(25)
//        TickImage.frame.origin.y = CGFloat(224)
//    }
//
//    @IBAction func relaxingButton(_ sender: Any) {
//        Mood.gradientColor1 = UIColor(red: 119/255, green: 161/255, blue: 211/255, alpha: 1).cgColor
//        Mood.gradientColor2 = UIColor(red: 121/255, green: 203/255, blue: 202/255, alpha: 1).cgColor
//        Mood.gradientColor3 = UIColor(red: 121/255, green: 203/255, blue: 202/255, alpha: 1).cgColor
//        Mood.gradientColor4 = UIColor(red: 230/255, green: 132/255, blue: 174/255, alpha: 1).cgColor
//        Mood.moodGif = "relaxing"
//        TickImage.frame.origin.x = CGFloat(211)
//        TickImage.frame.origin.y = CGFloat(224)
//    }
//
//    @IBAction func romanticButton(_ sender: Any) {
//        Mood.gradientColor1 = UIColor(red: 204/255, green: 43/255, blue: 94/255, alpha: 1).cgColor
//        Mood.gradientColor4 = UIColor(red: 204/255, green: 43/255, blue: 94/255, alpha: 1).cgColor
//        Mood.gradientColor3 = UIColor(red: 117/255, green: 58/255, blue: 136/255, alpha: 1).cgColor
//        Mood.gradientColor2 = UIColor(red: 117/255, green: 58/255, blue: 136/255, alpha: 1).cgColor
//        Mood.moodGif = "romantic"
//        TickImage.frame.origin.x = CGFloat(25)
//        TickImage.frame.origin.y = CGFloat(378)
//    }
//
//    @IBAction func funButton(_ sender: Any) {
//        Mood.gradientColor1 = UIColor(red: 64/255, green: 224/255, blue: 208/255, alpha: 1).cgColor
//        Mood.gradientColor2 = UIColor(red: 255/255, green: 140/255, blue: 0/255, alpha: 1).cgColor
//        Mood.gradientColor3 = UIColor(red: 255/255, green: 140/255, blue: 0/255, alpha: 1).cgColor
//        Mood.gradientColor4 = UIColor(red: 255/255, green: 0/255, blue: 128/255, alpha: 1).cgColor
//        Mood.moodGif = "fun"
//        TickImage.frame.origin.x = CGFloat(211)
//        TickImage.frame.origin.y = CGFloat(378)
//    }
//
//    @IBAction func excitementButton(_ sender: Any) {
//        Mood.gradientColor1 = UIColor(red: 0/255, green: 242/255, blue: 96/255, alpha: 1).cgColor
//        Mood.gradientColor2 = UIColor(red: 5/255, green: 117/255, blue: 230/255, alpha: 1).cgColor
//        Mood.gradientColor3 = UIColor(red: 5/255, green: 117/255, blue: 230/255, alpha: 1).cgColor
//        Mood.gradientColor4 = UIColor(red: 0/255, green: 242/255, blue: 96/255, alpha: 1).cgColor
//        Mood.moodGif = "excitement"
//        TickImage.frame.origin.x = CGFloat(25)
//        TickImage.frame.origin.y = CGFloat(526)
//    }
//
//    @IBAction func crazyButton(_ sender: Any) {
//        Mood.gradientColor1 = UIColor(red: 69/255, green: 104/255, blue: 220/255, alpha: 1).cgColor
//        Mood.gradientColor2 = UIColor(red: 176/255, green: 106/255, blue: 179/255, alpha: 1).cgColor
//        Mood.gradientColor3 = UIColor(red: 176/255, green: 106/255, blue: 179/255, alpha: 1).cgColor
//        Mood.gradientColor4 = UIColor(red: 69/255, green: 104/255, blue: 220/255, alpha: 1).cgColor
//        Mood.moodGif = "crazy"
//        TickImage.frame.origin.x = CGFloat(211)
//        TickImage.frame.origin.y = CGFloat(526)
//    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
