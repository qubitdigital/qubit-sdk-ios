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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printCurrentContext()
        fetchExperiences()
    }
    
    private func printCurrentContext() {
        print(QubitSDK.trackingId)
        print(QubitSDK.deviceId)
    }
    
    private func fetchExperiences() {
        QubitSDK.fetchExperiences(withIds: [139731], onSuccess: { (experiences) in
            experiences.first?.shown()
        }, onError: { (error) in
            print("Got error: \(error.localizedDescription)")
        })
    }
    
    @IBAction func tapOnEventButton(_ sender: UIButton) {
        for _ in 0...10 {
            QubitSDK.sendEvent(type: "View", data: "{\"type\" : \"tapOnEventButton\", \"decimal\" : 2,0 }")
        }
    }
    
    @IBAction func tapOnCreateEventButton(_ sender: UIButton) {
        let event =  QubitSDK.createEvent(type: "Product", dictionary: ["eventType": "tapOnCreateEventButton"])
        QubitSDK.sendEvent(event: event)
    }
}
