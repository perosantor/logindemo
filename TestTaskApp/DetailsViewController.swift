//
//  DetailsViewController.swift
//  TestTaskApp
//
//  Created by Petar Santor on 3/29/17.
//  Copyright © 2017 Petar Santor. All rights reserved.
//

import UIKit
import SVProgressHUD

class DetailsViewController: UIViewController {

    
    //MARK: Outlets
    
    @IBOutlet weak var imageViewThumbnail: UIImageView!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelWelcomeMessage: UILabel!
    @IBOutlet weak var labelOpenedStatus: UILabel!
    @IBOutlet weak var labelIntro: UILabel!
    
    
    //MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        CommunicationService.sharedInstace.fetchRestaurantInformation { (restaurant, errorMessage) in
            if errorMessage != nil {
                SVProgressHUD.showError(withStatus: errorMessage!)
            } else {
                SVProgressHUD.dismiss()
                if restaurant != nil {
                    
                }
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Actions
    
    
    @IBAction func handleTapOnLogoutButton(_ sender: UIBarButtonItem) {
        Utilities.removeAccessToken()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setInitialViewController()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
