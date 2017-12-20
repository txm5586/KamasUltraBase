//
//  ViewController.swift
//  KamasUltraBase
//
//  Created by Tassio Moreira Marques on 17/12/2017.
//  Copyright © 2017 Tassio Marques. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToPlay", sender: self)
    }

}
