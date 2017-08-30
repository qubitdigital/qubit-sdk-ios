//
//  ViewController.swift
//  SwiftTestApp
//
//  Created by Dariusz Zajac on 23/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import UIKit
import QBTracker
//@testable import QBTracker

class ViewController: UIViewController {

    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        QubitSDK.initialize(withTrackingId: "miquido")
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    @objc func timerTick() {
        print("tick")
    }

}

