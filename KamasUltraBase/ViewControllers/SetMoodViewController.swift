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
    
    
    
    @IBAction func defaultButton(_ sender: Any) {
        MoodConfig.changeMood(mood: .Sexy)
        TickImage.frame.origin.x = CGFloat(25)
        TickImage.frame.origin.y = CGFloat(79)
    }

    @IBAction func luxury(_ sender: Any) {
        MoodConfig.changeMood(mood: .Luxury)
        TickImage.frame.origin.x = CGFloat(211)
        TickImage.frame.origin.y = CGFloat(79)
    }

    @IBAction func misteryButton(_ sender: Any) {
        MoodConfig.changeMood(mood: .Mistery)
        TickImage.frame.origin.x = CGFloat(25)
        TickImage.frame.origin.y = CGFloat(224)
    }

    @IBAction func relaxingButton(_ sender: Any) {
        MoodConfig.changeMood(mood: .Relaxing)
        TickImage.frame.origin.x = CGFloat(211)
        TickImage.frame.origin.y = CGFloat(224)
    }

    @IBAction func romanticButton(_ sender: Any) {
        MoodConfig.changeMood(mood: .Romantic)
        TickImage.frame.origin.x = CGFloat(25)
        TickImage.frame.origin.y = CGFloat(378)
    }

    @IBAction func funButton(_ sender: Any) {
        MoodConfig.changeMood(mood: .Fun)
        TickImage.frame.origin.x = CGFloat(211)
        TickImage.frame.origin.y = CGFloat(378)
    }

    @IBAction func excitementButton(_ sender: Any) {
        MoodConfig.changeMood(mood: .Excitement)
        TickImage.frame.origin.x = CGFloat(25)
        TickImage.frame.origin.y = CGFloat(526)
    }

    @IBAction func crazyButton(_ sender: Any) {
        MoodConfig.changeMood(mood: .Crazy)
        TickImage.frame.origin.x = CGFloat(211)
        TickImage.frame.origin.y = CGFloat(526)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let mood = MoodConfig.currentMood
        switch mood {
        case .Sexy:
            self.defaultButton(self)
        case .Luxury:
            self.luxury(self)
        case .Mistery:
            self.misteryButton(self)
        case .Relaxing:
            self.relaxingButton(self)
        case .Romantic:
            self.romanticButton(self)
        case .Fun:
            self.funButton(self)
        case .Excitement:
            self.excitementButton(self)
        case .Crazy:
            self.crazyButton(self)
        }
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
