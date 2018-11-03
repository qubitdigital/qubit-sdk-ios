//
//  ViewController.swift
//  SwiftTestApp
//
//  Created by Dariusz Zajac on 23/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import UIKit
import QubitSDK

class ViewController: UIViewController {

    var timer: Timer?
    @IBOutlet weak var eventsLabel: UILabel!
    
    override func viewDidLoad() {
        QubitSDK.start(withTrackingId: "miquido", logLevel: .verbose)
        super.viewDidLoad()
        print(QubitSDK.trackingId)
        print(QubitSDK.deviceId)
        
        QubitSDK.fetchExperiences(withIds: [139731], onSuccess: { (experiences) in
            print("EXPY \(experiences.count)")
            experiences.first?.shown()
        }, onError: { (error) in
            print("ERROR \(error.localizedDescription)")
        })
    }
    
    @IBAction func tapOnEventButton(_ sender: UIButton) {
        for _ in 0...10 {
            QubitSDK.sendEvent(type: "View", data: "{\"type\" : \"tapOnEventButton\"}")
        }
    }
    
    @IBAction func tapOnCreateEventButton(_ sender: UIButton) {
        let event =  QubitSDK.createEvent(type: "Product", dictionary: ["eventType": "tapOnCreateEventButton"])
        QubitSDK.sendEvent(event: event)
    }
}
