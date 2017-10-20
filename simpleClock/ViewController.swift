//
//  ViewController.swift
//  simpleClock
//
//  Created by Mitchell Sweet on 10/12/17.
//  Copyright © 2017 Mitchell Sweet. All rights reserved.
//

import UIKit

/// Stores attributes of supported locations.
struct Location {
    let displayName: String
    let url: URL?
    let timeZone: TimeZone
}

class ViewController: UIViewController {
    
    // Create outlets for UIViews acting as hands on clock and time selector segmented view.
    @IBOutlet var hourHand: UIView!
    @IBOutlet var minuteHand: UIView!
    @IBOutlet var timeSelector: UISegmentedControl!
    @IBOutlet var backgroundImageView: UIImageView!
    
    // Array to store location structs for supported locations.
    static let supportedLocations = [
        Location(displayName: "Current Location",
                 url: nil,
                 timeZone: Calendar.current.timeZone),
        Location(displayName: "Cupertino",
                 url: URL(string: "https://i.imgur.com/3EsGLo9.jpg"),
                 timeZone: TimeZone(abbreviation: "PST")!),
        Location(displayName: "London",
                 url: URL(string: "https://i.imgur.com/zO2CMlT.jpg"),
                 timeZone: TimeZone(abbreviation: "UTC")!),
        Location(displayName: "Florence",
                 url: URL(string: "https://i.imgur.com/ydRPSGh.jpg"),
                 timeZone: TimeZone(abbreviation: "CET")!)
    ]
    
    var timeUpdater: Timer? // Create timer to update time each second.
    let imageLoader = ImageLoader()
    var selectedLocation: Location { // Variable for current location, will update each time used.
        return ViewController.supportedLocations[timeSelector.selectedSegmentIndex]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add rounded corners to hands.
        hourHand.layer.cornerRadius = 2
        minuteHand.layer.cornerRadius = 2
        
        update()
        
        // Initalize timer to call the update function once every second.
        timeUpdater = Timer.scheduledTimer(timeInterval: 1,
                                           target: self,
                                           selector: #selector(update),
                                           userInfo: nil,
                                           repeats: true)
    }

    /// Called when new location is selected in segmented control.
    @IBAction func didChangeLocation() {
        if let locationURL = selectedLocation.url {
            imageLoader.loadImage(url: locationURL) { image, error in
                if let error = error {
                    print("Error: Could not download image. Description: \(error.localizedDescription)")
                }
                self.backgroundImageView.image = image
            }
        }
        else {
            backgroundImageView.image = nil // Set background image to nil if user chooses current time zone.
        }
        update()
    }
    
    /// Gets the current date and updates the hands on the clock based on the time.
    @objc func update() {
        let components = Calendar.current.dateComponents(in: selectedLocation.timeZone,
                                                         from: Date())
        updateMinuteHand(minute: components.minute!)
        updateHourHand(hour: components.hour! % 12 , minute: components.minute!)
        
    }
    
    
    /// Rotates the hour hand x amount of radians based on the current time.
    func updateHourHand(hour: Int, minute: Int) {
        let degree = CGFloat ((hour * 30) + (minute / 2)) // Calculate the amount of degrees to move minute hand.
        setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y:1), view: hourHand) // Set the anchor point so the view rotates around the correct point.
        hourHand.transform = CGAffineTransform(rotationAngle: degree*(CGFloat.pi/180)) // Convert degree to radians and rotate around it.
    }
    
    /// Rotates the minute hand x amount of radians based on the current time.
    func updateMinuteHand(minute: Int) {
        let degree = CGFloat(minute * 6) // Calculate the amount of degrees to move minute hand.
        setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 1), view: minuteHand) // Set the anchor point so the view rotates around the correct point.
        minuteHand.transform = CGAffineTransform(rotationAngle: degree*(CGFloat.pi/180)) // Convert degree to radians and rotate arond it.
    }
    
    // Changes anchor point of given view to given point and sets view to the correct position. 
    func setAnchorPoint(anchorPoint: CGPoint, view: UIView) {
        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)
        
        var position : CGPoint = view.layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x;
        
        position.y -= oldPoint.y;
        position.y += newPoint.y;
        
        view.layer.position = position;
        view.layer.anchorPoint = anchorPoint;
    }
    // https://stackoverflow.com/questions/26815263/setting-a-rotation-point-for-cgaffinetransformmakerotation-swift
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

