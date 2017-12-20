//
//  SettingsTableViewController.swift
//  KamasUltraBase
//
//  Created by Tassio Moreira Marques on 18/12/2017.
//  Copyright © 2017 Tassio Marques. All rights reserved.
//

import UIKit

protocol SettingsTableViewControllerDelegate {
    func removeBlurredBackgroundView()
}

class SettingsTableViewController: UITableViewController, UITextFieldDelegate {
    // MARK: Properties
    private var appDelegate: AppDelegate!
    var delegate: SettingsTableViewControllerDelegate?
    
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var namePeerTextField: UITextField!
    @IBOutlet weak var bodyImageView: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    // MARK: Actions
    @IBAction func segmentTapped(_ sender: Any) {
        if self.genderSegment.selectedSegmentIndex == Constants.male {
            self.bodyImageView.image = #imageLiteral(resourceName: "WhiteBodyMan")
        } else if self.genderSegment.selectedSegmentIndex == Constants.female {
            self.bodyImageView.image = #imageLiteral(resourceName: "WhiteBodyWoman")
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        
        self.appDelegate.ppService.adversiteSelf(adverstise: false)
        
        var namePeer = namePeerTextField.text!
        if namePeer == "" {
            namePeer = UIDevice.current.name
        }
        
        userDefaults.set(namePeer, forKey: UserKey.peerName)
        userDefaults.set(genderSegment.selectedSegmentIndex, forKey: UserKey.gender)
        
        self.appDelegate.ppService.resetPeerID(newDisplayName: namePeer)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.tableView.tableFooterView?.backgroundColor = UIColor.black
        self.tableView.tableHeaderView?.backgroundColor = UIColor.black
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .clear
        self.tableView.tableFooterView = UIView()
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.navigationBar.backgroundColor = .clear
        
        namePeerTextField.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = true
        
        let userDefaults = UserDefaults.standard
        self.namePeerTextField.text = userDefaults.object(forKey: UserKey.peerName) as? String
        self.genderSegment.selectedSegmentIndex = (userDefaults.object(forKey: UserKey.gender) as? Int)!
        
        if self.genderSegment.selectedSegmentIndex == Constants.male {
            self.bodyImageView.image = #imageLiteral(resourceName: "WhiteBodyMan")
        } else if self.genderSegment.selectedSegmentIndex == Constants.female {
            self.bodyImageView.image = #imageLiteral(resourceName: "WhiteBodyWoman")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.delegate?.removeBlurredBackgroundView()
    }
    
    override func viewDidLayoutSubviews() {
        view.backgroundColor = UIColor.clear
    }
    
    override  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer = view as! UITableViewHeaderFooterView
        footer.textLabel?.textColor = UIColor.white
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.namePeerTextField.resignFirstResponder()
        return true
    }
    

    // MARK: - Table view data source



    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
