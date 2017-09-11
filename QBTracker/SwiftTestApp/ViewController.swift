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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        QubitSDK.start(withTrackingId: "miquido", logLevel: .verbose)
		DispatchQueue.main.async {
			self.timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(self.timerTick), userInfo: nil, repeats: true)
		}
    }
    
    @objc func timerTick() {
		QubitSDK.sendEvent(type: "testing", data: "view0")
        let deadlineTime1 = DispatchTime.now() + .milliseconds(100)
        let deadlineTime2 = DispatchTime.now() + .milliseconds(600)

        DispatchQueue.main.asyncAfter(deadline: deadlineTime1) {
            QubitSDK.sendEvent(type: "View", data: "ddd")
            QubitSDK.sendEvent(type: "View", data: "ddd")
            QubitSDK.sendEvent(type: "View", data: "ddd")
        }
        
        DispatchQueue.main.asyncAfter(deadline: deadlineTime2) {
            QubitSDK.sendEvent(type: "Product", data: "ddd")
            QubitSDK.sendEvent(type: "Product", data: "ddd")
            QubitSDK.sendEvent(type: "Product", data: "ddd")
            QubitSDK.sendEvent(type: "Product", data: "ddd")
            QubitSDK.sendEvent(type: "Product", data: "ddd")
            QubitSDK.sendEvent(type: "Product", data: "ddd")
            QubitSDK.sendEvent(type: "Product", data: "ddd")
            QubitSDK.sendEvent(type: "Product", data: "ddd")
            QubitSDK.sendEvent(type: "Product", data: "ddd")
            QubitSDK.sendEvent(type: "Product", data: "ddd")
            QubitSDK.sendEvent(type: "Product", data: "ddd")
            QubitSDK.sendEvent(type: "Product", data: "ddd")
        }
        print("tick")
    }

}
