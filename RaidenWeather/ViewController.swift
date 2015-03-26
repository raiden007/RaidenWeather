//
//  ViewController.swift
//  RaidenWeather
//
//  Created by Andrei Joghiu on 25/3/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var cityNameTextField: UITextField!
    @IBOutlet var getWeatherButton: UIButton!
    @IBOutlet var weatherResultsLabel: UILabel!
    
    
    var urlContent:NSString = ""
    var weather:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        weatherResultsLabel.text = ""
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getWeatherButtonPressed(sender: UIButton) {
        
        var city = cityNameTextField.text
        
        let url = NSURL(string: "http://www.weather-forecast.com/locations/" + city.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {
            (data, response, error) in
            
            if error == nil {
                self.urlContent = NSString(data: data, encoding: NSUTF8StringEncoding)!
                
                if self.urlContent.containsString("You may have mistyped the address") {
                    
                    self.weather = "Unable to get information, please try again ..."
                    self.update()
                    
                } else {
                
                var urlContentArray  = self.urlContent.componentsSeparatedByString("<span class=\"phrase\">")
                println(urlContentArray)
                
                if urlContentArray.count > 0 {
                    
                    var weatherArray = urlContentArray[1].componentsSeparatedByString("</span>")
                    self.weather = weatherArray[0] as String
                    self.weather = self.weather.stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                    
                    self.update()
                    println(self.weather)
                    
                    
                } else {
                    self.weatherResultsLabel.text = "Unable to get information, please try again ..."
                    
                }
                }
            } else {
                self.weatherResultsLabel.text = "Unable to get information, please try again ..."
                
            }
        }
        
        task.resume()
        
        cityNameTextField.text = ""
        
    }
    
    func update () {
        dispatch_async(dispatch_get_main_queue(), {
            
            self.weatherResultsLabel.text = self.weather
        })
    }
    


}

