//
//  ViewController.swift
//  simpleClock
//
//  Created by Mitchell Sweet on 10/12/17.
//  Copyright © 2017 Mitchell Sweet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Create outlets for UIViews acting as hands on clock.
    @IBOutlet var hourHand: UIView!
    @IBOutlet var minuteHand: UIView!
    
    // Create timer to update time each second.
    var timeUpdater: Timer?
    // Create constant for calendar.
    let calendar = Calendar.current
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add rounded corners to hands.
        hourHand.layer.cornerRadius = 2
        minuteHand.layer.cornerRadius = 2
        
        update() // Call the update function.
        
        // Initalize timer to call the update function once every second.
        timeUpdater = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        //FIXME: Find a more efficient way to do this.
    }
    
    /// Gets the current date and updates the hands on the clock based on the time.
    @objc func update() {
        let date = Date()
        updateMinuteHand(minute: calendar.component(.minute, from: date))// Call function to update minute hand with current minute.
        
        // Date formatter to get current hour in 12 hour format.
        let formatter = DateFormatter()
        formatter.dateFormat = "hh"
        let hourString = formatter.string(from: date)
        if let hourInt = Int(hourString) {
            updateHourHand(hour: hourInt, minute: calendar.component(.minute, from: date)) // Call function to update hour hand with current hour.
        }
        else {
            fatalError("Was not able to update hour hand, no int value in date.")
        }
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

