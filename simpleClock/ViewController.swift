//
//  ViewController.swift
//  simpleClock
//
//  Created by Mitchell Sweet on 10/12/17.
//  Copyright © 2017 Mitchell Sweet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var hourHand: UIView!
    @IBOutlet var minuteHand: UIView!
    
    var timeUpdater: Timer?
    let calendar = Calendar.current
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hourHand.layer.cornerRadius = 2
        minuteHand.layer.cornerRadius = 2
        
        update()
        timeUpdater = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @objc func update() {
        let date = Date()
        updateMinuteHand(minute: calendar.component(.minute, from: date))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh"
        let hourString = formatter.string(from: date)
        if let hourInt = Int(hourString) {
            updateHourHand(hour: hourInt, minute: calendar.component(.minute, from: date))
        }
        else {
            fatalError("Was not able to update hour hand, no int value in date.")
        }
    }
    
    func updateHourHand(hour: Int, minute: Int) {
        let degree = CGFloat (30 * hour + minute / 2)
        setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y:1), view: hourHand)
        hourHand.transform = CGAffineTransform(rotationAngle: degree*(CGFloat.pi/180))
    }
    
    func updateMinuteHand(minute: Int) {
        let degree = CGFloat(minute * 6)
        setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 1), view: minuteHand)
        minuteHand.transform = CGAffineTransform(rotationAngle: degree*(CGFloat.pi/180))
    }
    
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

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

