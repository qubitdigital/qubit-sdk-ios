//
//  ViewController.swift
//  QubitSwiftExampleApp
//
//  Created by Pavlo Davydiuk on 29/08/2017.
//  Copyright © 2017 Qubiit. All rights reserved.
//

import UIKit
import QBTracker

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        QubitSDK.start(withTrackingId: "miquido")
        //QubitSDK.initialize(withTrackingId: "miquido")
    }
}

