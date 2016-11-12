//
// Please report any problems with this app template to contact@estimote.com
//

import UIKit

class ViewController: UIViewController, ProximityContentManagerDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var proximityContentManager: ProximityContentManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.activityIndicator.startAnimating()

        self.proximityContentManager = ProximityContentManager(
            beaconIDs: [
                // Hub13's physical
                BeaconID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major: 59823, minor: 46734),
                // Dinh's virtual
//                BeaconID(UUIDString: "8492E75F-4FD6-469D-B132-043FE94921D8", major: 4921, minor: 4807),
//                BeaconID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major: 3, minor: 3)
            ],
            beaconContentFactory: CachingContentFactory(beaconContentFactory: BeaconDetailsCloudFactory()))
        self.proximityContentManager.delegate = self
        self.proximityContentManager.startContentUpdates()
    }

    func proximityContentManager(_ proximityContentManager: ProximityContentManager, didUpdateContent content: AnyObject?) {
        self.activityIndicator?.stopAnimating()
        self.activityIndicator?.removeFromSuperview()

        if let beaconDetails = content as? BeaconDetails {
            self.view.backgroundColor = beaconDetails.backgroundColor
            self.label.text = "You're in \(beaconDetails.beaconName)'s range!"
            self.image.isHidden = false
        } else {
            self.view.backgroundColor = BeaconDetails.neutralColor
            self.label.text = "No beacons in range."
            self.image.isHidden = true
        }
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
