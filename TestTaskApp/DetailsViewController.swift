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
    
    @IBOutlet weak var constraintImageViewHeight: NSLayoutConstraint!
    
    
    //MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelName.font = UIFont(name: Constants.Font.RobotoLight, size: 18)
        labelIntro.font = UIFont(name: Constants.Font.RobotoLight, size: 18)
        labelWelcomeMessage.font = UIFont(name: Constants.Font.RobotoLight, size: 17)
        labelOpenedStatus.font = UIFont(name: Constants.Font.RobotoLight, size: 18)
        
        self.constraintImageViewHeight.constant = UIScreen.main.bounds.width * 2/3
        
        SVProgressHUD.show()
        CommunicationService.sharedInstace.fetchRestaurantInformation {
            (restaurant, errorMessage) in
            if errorMessage != nil {
                SVProgressHUD.showError(withStatus: errorMessage!)
            } else {
                SVProgressHUD.dismiss()
                DispatchQueue.main.sync {
                    if (restaurant != nil) {
                        self.updateScreen(restaurant: restaurant!)
                    }
                }
            }
        }
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
    
    
    //MARK: - Utilities
    
    
    func updateScreen(restaurant:Restaurant) {
        self.labelWelcomeMessage.text = restaurant.welcomeMessage
        self.labelIntro.text = restaurant.intro
        self.labelName.text = restaurant.name
        var status = "Closed"
        if restaurant.is_open {
            status = "Opened"
        }
        self.labelOpenedStatus.text = status
        if let url = restaurant.thumbnailImageUrl {
            self.imageViewThumbnail.sd_setImage(with: URL(string: url))
        }
    }
    
}
