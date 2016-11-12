//
// Please report any problems with this app template to contact@estimote.com
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController, ESTBeaconManagerDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // let ref = FIRDatabase.database().reference(withPath: "User")

    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("OK", beaconRegion)

        beaconRegion.notifyEntryStateOnDisplay = true
        self.activityIndicator.startAnimating()

        // 3. Set the beacon manager's delegate
        self.beaconManager.delegate = self
        // 4. We need to request this authorization for every beacon manager
        self.beaconManager.requestWhenInUseAuthorization()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.beaconManager.startRangingBeacons(in: self.beaconRegion)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.beaconManager.startRangingBeacons(in: self.beaconRegion)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    func placesNearBeacon(beacon: CLBeacon) -> [String]? {
        let beaconKey = "\(beacon.major):\(beacon.minor)"
        if let toilet = self.restroom[beaconKey] {
            let sortedPlaces = Array(toilet).sorted { $0.1 < $1.1 }.map { $0.0 }
            return sortedPlaces
        }
        return nil
    }
 */
    var current: String = ""
    var prev1: String = ""
    var prev2: String = ""
    func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for item in beacons {
            print("dis con meeee", item.major, item.proximity.rawValue, item.accuracy)
            
            switch item.proximity {
            case .immediate, .near:
                
                getIn()
                return
            case .unknown:
                print("unknown")
            default:
                print("default")
            }
        }
        getOut()
    }
    
    func getIn() {
        prev2 = prev1
        prev1 = current
        current = "in"
        if (prev2 == "in" && prev1 == "in" && current == "in" ){
            print("Đang ỉa")
            self.label.text = "OCCUPIED"
        }
    }
    
    func getOut() {
        prev2 = prev1
        prev1 = current
        current = "out"
        if (prev2 == "out" && prev1 == "out" && current == "out" ){
            print("Ỉa xong rồi")
            self.label.text = "VACANT"
        }
    }
}
