//
//  TodayViewController.swift
//  TodayWidget
//
//  Created by Jackie Norstrom on 1/16/19.
//  Copyright © 2019 LAS. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData
import Seam3

class TodayViewController: UIViewController, NCWidgetProviding {
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
