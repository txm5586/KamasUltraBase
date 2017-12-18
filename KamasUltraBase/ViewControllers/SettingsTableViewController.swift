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

class SettingsTableViewController: UITableViewController {
    var delegate: SettingsTableViewControllerDelegate?
    
    // MARK: Actions
    
    
    
    // MARK: Override functions
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = true
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
