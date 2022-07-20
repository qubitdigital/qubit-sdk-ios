//
//  ViewController.swift
//  QubitSwiftExampleApp
//
//  Created by Pavlo Davydiuk on 29/08/2017.
//  Copyright © 2017 Qubiit. All rights reserved.
//

import UIKit
import QubitSDK

class ViewController: UIViewController {

    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.timerTick), userInfo: nil, repeats: true)
        }
    }
    
    @objc func timerTick() {
        QubitSDK.sendEvent(type: NSUUID().uuidString, data: "ddd")
        print("tick")
    }
}
