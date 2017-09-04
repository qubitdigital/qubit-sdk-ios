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
			self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.timerTick), userInfo: nil, repeats: true)
		}
    }
    
    @objc func timerTick() {
		QubitSDK.sendEvent(type: "abc", data: "ddd")
        print("tick")
    }

}
