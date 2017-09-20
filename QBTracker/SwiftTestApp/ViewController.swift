//
//  ViewController.swift
//  SwiftTestApp
//
//  Created by Dariusz Zajac on 23/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import UIKit
import QubitSDK
//@testable import QBTracker

class ViewController: UIViewController {

    var timer: Timer?
    @IBOutlet weak var eventsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        QubitSDK.start(withTrackingId: "miquido", logLevel: .verbose)
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            QubitSDK.allEvents(completion: { (results) in
                self.eventsLabel.text = "Events: \(results.count)"
            })
        }
    }
    
    
    
    @IBAction func tapOnEventButton(_ sender: UIButton) {
        for i in 0...10 {
            QubitSDK.sendEvent(type: "View", data: "{\"type\" : \"tapOnEventButton\"}")
        }
    }
    
    @IBAction func tapOnCreateEventButton(_ sender: UIButton) {
        let event =  QubitSDK.createEvent(type: "Product", dictionary: ["eventType": "tapOnCreateEventButton"])
        QubitSDK.sendEvent(event: event)
    }
}
