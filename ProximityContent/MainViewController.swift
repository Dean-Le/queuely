//
//  MainViewController.swift
//  ProximityContent
//
//  Created by avnt on 2016/11/12.
//  Copyright © 2016 Estimote, Inc. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, ESTBeaconManagerDelegate {

    @IBOutlet weak var karmaLabel: UILabel!
    @IBOutlet weak var queuePosLabel: UILabel!
    @IBOutlet weak var queueEstimateLabel: UILabel!
    @IBOutlet weak var queueButton: UIButton!
    @IBOutlet weak var urgentButton: UIButton!
    
    @IBOutlet weak var centerImage: UIImageView!
    
    var inQueue = false
    var pending = false
    var active = false
    var aheadOfYou = 3
    var queueSize = 3
    var karmaPoints = 85
    
    var countdownTimer: Timer!
    var countdownTime = 0
    var timePad = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 3. Set the beacon manager's delegate
        self.beaconManager.delegate = self
        // 4. We need to request this authorization for every beacon manager
        self.beaconManager.requestWhenInUseAuthorization()
        renderUI()
        // Do any additional setup after loading the view.
        countdownTime = aheadOfYou * 3 * 60

        
        urgentButton.isHidden = true
        queuePosLabel.text = "\(aheadOfYou)"
        if countdownTime % 60 < 10 {
            timePad = "0"
        } else {
            timePad = ""
        }
        queueEstimateLabel.text = "\(countdownTime / 60):\(timePad)\(countdownTime % 60)"
        karmaLabel.text = "\(karmaPoints)"
        
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func runTimedCode() {
        countdownTime -= 1
        
        if countdownTime < 0 {
            countdownTime = 0
        }
        
        if countdownTime % 60 < 10 {
            timePad = "0"
        } else {
            timePad = ""
        }
        queueEstimateLabel.text = "\(countdownTime / 60):\(timePad)\(countdownTime % 60)"
        
        // Update Queue Pos
        if ((aheadOfYou - 1) * 3 * 60) > countdownTime {
            aheadOfYou -= 1
            queuePosLabel.text = "\(aheadOfYou)"
        }
        
        if aheadOfYou == 0 && !pending {
            setPending()
        }
        
        if pending && countdownTime == 0 {
            setInActive()
        }
    }

    
    func setPending() {
        pending = true
        active = false
        queueEstimateLabel.isHidden = false
        queuePosLabel.isHidden = true
        urgentButton.isHidden = true
        
        centerImage.image = UIImage(named: "center_pending")
        
        countdownTime = 2 * 60
        queueEstimateLabel.textColor = UIColor(red: 98.0/255.0, green: 98.0/255.0, blue: 98.0/255.0, alpha: 1.0)
    }
    
    func setActive() {
        active = true
        pending = false
        queueEstimateLabel.isHidden = true
        queuePosLabel.isHidden = true
        centerImage.image = UIImage(named: "center_in")
    }
    
    func setInActive() {
        pending = false
        active = false
        centerImage.image = UIImage(named: "center")
        queueEstimateLabel.isHidden = false
        queuePosLabel.isHidden = false
        
        queueButton.setTitle("Enter Queue", for: .normal)
        queuePosLabel.textColor = UIColor.darkGray
        urgentButton.isHidden = true
        
        queueEstimateLabel.textColor = UIColor.white
        
        // Reset Queue
        aheadOfYou = 3
        queuePosLabel.text = "\(aheadOfYou)"
        countdownTime = aheadOfYou * 3 * 60

    }
    
    func setQueued() {
        pending = false
        active = false
        centerImage.image = UIImage(named: "center")
        queueEstimateLabel.isHidden = false
        queuePosLabel.isHidden = false
        
        queueButton.setTitle("Leave Queue", for: .normal)
        queuePosLabel.textColor = UIColor(red: 131.0/255.0, green: 207.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        urgentButton.isHidden = false
        
        queueEstimateLabel.textColor = UIColor.white
        
        
        
        if karmaPoints <= (queueSize - aheadOfYou) {
            urgentButton.isHidden = true
        }
    }

    @IBAction func queueAction(_ sender: UIButton) {
        inQueue = !inQueue
        renderUI()
    }
    
    @IBAction func urgentAction(_ sender: UIButton) {
        if aheadOfYou > 0 {
            aheadOfYou -= 1
            karmaPoints -= queueSize - aheadOfYou
            queuePosLabel.text = "\(aheadOfYou)"
            
            countdownTime = aheadOfYou * 3 * 60
            
            karmaLabel.text = "\(karmaPoints)"
        }
        
        if aheadOfYou == 0 || karmaPoints < (queueSize - aheadOfYou) {
            urgentButton.isHidden = true
        }
        
        if aheadOfYou == 0 {
            setPending()
        }
        
        renderUI()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    private func renderUI(){
        
        
        if !inQueue {
            setInActive()
        } else {
            setQueued()
        }
        
        
        if aheadOfYou == 0 {
            setPending()
//            queuePosLabel.text = "It's your turn"
//            urgentButton.isHidden = true
        }
    
    }
    
    
    let beaconManager = ESTBeaconManager()
    let beaconRegion = CLBeaconRegion(
        proximityUUID: NSUUID(uuidString: "8492E75F-4FD6-469D-B132-043FE94921D8")! as UUID,
        // major: 59823, minor: 46734,
        identifier: "ranged region")
    
    //B9407F30-F5F8-466E-AFF9-25556B57FE6D
    
    /*let arianRegion = CLBeaconRegion(
     proximityUUID: NSUUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")! as UUID,
     major: 10773, minor: 19987,
     identifier: "ranged region")
     
     let sinhRegion = CLBeaconRegion(
     proximityUUID: NSUUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")! as UUID,
     major: 8911, minor: 253,
     identifier: "ranged region")
     */
    var proximityContentManager: ProximityContentManager!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.beaconManager.startRangingBeacons(in: self.beaconRegion)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.beaconManager.startRangingBeacons(in: self.beaconRegion)
    }
    var current: String = ""
    var prev1: String = ""
    var prev2: String = ""
    func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for item in beacons {
            print("dis con meeee", item.major, item.proximity.rawValue, item.accuracy)
            
            switch item.proximity {
            case .immediate, .near:
                
                prev2 = prev1
                prev1 = current
                current = "in"
                if (prev2 == "in" && prev1 == "in" && current == "in" ){
                    getIn()
                }
                
                getIn()
                return
            case .unknown:
                print("unknown")
            default:
                print("default")
            }
        }
        
        prev2 = prev1
        prev1 = current
        current = "out"
        if (prev2 == "out" && prev1 == "out" && current == "out" ) {
            getOut()
        }
    }
    
            
    

    func getIn() {
        print("Đang ỉa")
    }
    
    func getOut() {
        print("Ỉa xong rồi")
    }

}
