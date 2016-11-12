//
//  MainViewController.swift
//  ProximityContent
//
//  Created by avnt on 2016/11/12.
//  Copyright © 2016 Estimote, Inc. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var karmaLabel: UILabel!
    @IBOutlet weak var queuePosLabel: UILabel!
    @IBOutlet weak var queueEstimateLabel: UILabel!
    @IBOutlet weak var queueButton: UIButton!
    @IBOutlet weak var urgentButton: UIButton!
    
    var inQueue = false
    var aheadOfYou = 8
    var queueSize = 8
    var karmaPoints = 85
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urgentButton.isHidden = true
        queuePosLabel.text = "\(aheadOfYou)"
        queueEstimateLabel.text = "\(aheadOfYou * 3):00"
        karmaLabel.text = "\(karmaPoints)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func queueAction(_ sender: Any) {
        if inQueue {
            queueButton.setTitle("Enter Queue", for: .normal)
            queuePosLabel.textColor = UIColor.darkGray
            urgentButton.isHidden = true
            
            
            // Reset Queue
            aheadOfYou = 8
            queuePosLabel.text = "\(aheadOfYou)"
            queueEstimateLabel.text = "\(aheadOfYou * 3):00"
            
        } else {
            queueButton.setTitle("Leave Queue", for: .normal)
            queuePosLabel.textColor = UIColor(red: 131.0/255.0, green: 207.0/255.0, blue: 242.0/255.0, alpha: 1.0)
            urgentButton.isHidden = false
        }
        
        inQueue = !inQueue
    }
    
    @IBAction func urgentAction(_ sender: Any) {
        if aheadOfYou > 0 {
        aheadOfYou -= 1
        karmaPoints -= queueSize - aheadOfYou
        queuePosLabel.text = "\(aheadOfYou)"
        queueEstimateLabel.text = "\(aheadOfYou * 3):00"
        karmaLabel.text = "\(karmaPoints)"
        }
        
        if aheadOfYou == 0 {
            urgentButton.isHidden = true
        }
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
