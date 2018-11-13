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
        QubitSDK.fetchExperiences(withIds: [143640], onSuccess: { (experiences) in
            if let exp = experiences.first {
                print("Got experience - payload:")
                for (key, value) in exp.payload {
                    print("\(key) -> \(value)")
                }
                exp.shown()
            }
        }, onError: { (error) in
            print("Got error: \(error.localizedDescription)")
        }, preview: false, ignoreSegments: false, variation: nil)
    }
    
    @IBAction func tapOnEventButton(_ sender: UIButton) {
        for _ in 0...10 {
            QubitSDK.sendEvent(type: "View", data: "{\"type\" : \"tapOnEventButton\", \"number\":2.2}")
        }
    }
    
    @IBAction func tapOnCreateEventButton(_ sender: UIButton) {
        var ecProduct = [String: Any]();
        ecProduct["eventType"] = "detail";
        
        
        var product = [String: Any]();
        product["sku"] = "sso-099";
        product["productId"] = "1209012233";
        product["name"] = "Nike shoes";
        product["stock"] = 20;
        product["url"] = "http://www.fashionunion.com/dresses/red-cocktail-dress.html";
        // should be trimmed to 256 characters
        product["description"] = "This red cocktail dress is perfect for any occasion. This is a very long description that should be trimmed. This red cocktail dress is perfect for any occasion. This is a very long description that should be trimmed. This red cocktail dress is perfect for any occasion. This is a very long description that should be trimmed. This red cocktail dress is perfect for any occasion. This is a very long description that should be trimmed. This red cocktail dress is perfect for any occasion. This is a very long description that should be trimmed. This red cocktail dress is perfect for any occasion. This is a very long description that should be trimmed.";
        
        let categories = [
            "Clothing > Sweaters > Short Sleeve Sweaters",
            "New Arrivals > Clothing"
        ];
        product["categories"] = categories;
        
        var price = [String: Any]();
        price["currency"] = "GBP";
        price["value"] = 34.5055; // should be trimmed to 2dp
        product["price"] = price;
        
        
        let images = [ //should be trimmed to 10 items
            "http://www.fashionunion.com/dresses/red-cocktail-dress-1.jpg",
            "http://www.fashionunion.com/dresses/red-cocktail-dress-2.jpg",
            "http://www.fashionunion.com/dresses/red-cocktail-dress-1.jpg",
            "http://www.fashionunion.com/dresses/red-cocktail-dress-2.jpg",
            "http://www.fashionunion.com/dresses/red-cocktail-dress-1.jpg",
            "http://www.fashionunion.com/dresses/red-cocktail-dress-2.jpg",
            "http://www.fashionunion.com/dresses/red-cocktail-dress-1.jpg",
            "http://www.fashionunion.com/dresses/red-cocktail-dress-2.jpg",
            "http://www.fashionunion.com/dresses/red-cocktail-dress-1.jpg",
            "http://www.fashionunion.com/dresses/red-cocktail-dress-2.jpg",
            "http://www.fashionunion.com/dresses/red-cocktail-dress-2.jpg",
            "http://www.fashionunion.com/dresses/red-cocktail-dress-2.jpg",
            "http://www.fashionunion.com/dresses/red-cocktail-dress-2.jpg",
            "http://www.fashionunion.com/dresses/red-cocktail-dress-2.jpg",
            "http://www.fashionunion.com/dresses/red-cocktail-dress-2.jpg",
            "http://www.fashionunion.com/dresses/red-cocktail-dress-2.jpg",
            "http://www.fashionunion.com/dresses/red-cocktail-dress-2.jpg",
            "http://www.fashionunion.com/dresses/red-cocktail-dress-2.jpg",
            "http://www.fashionunion.com/dresses/red-cocktail-dress-2.jpg"
        ];
        product["images"] = images;
        
        ecProduct["product"] = product;
        
        QubitSDK.sendEvent(type: "ecProduct", dictionary: ecProduct)
    }
}
