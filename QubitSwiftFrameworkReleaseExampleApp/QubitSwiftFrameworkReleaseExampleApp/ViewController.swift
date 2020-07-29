//
//  ViewController.swift
//  QubitSwiftFrameworkReleaseExampleApp
//
//  Created by Mariusz Jakowienko on 29/07/2020.
//  Copyright © 2020 Mariusz Jakowienko. All rights reserved.
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
