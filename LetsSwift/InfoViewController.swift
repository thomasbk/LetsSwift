//
//  InfoViewController.swift
//  LetsSwift
//
//  Created by Thomas Baltodano on 5/12/17.
//  Copyright © 2017 Thomas Baltodano. All rights reserved.
//

import UIKit
import Alamofire

class InfoViewController: UIViewController {
    
    var myUser = User.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadData()
        
    }
    
    
    
    func loadData () {
        
        let url = URL(string: "http://lowcost-env.gwmnuuukas.us-west-2.elasticbeanstalk.com")!
        
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            let result = response.result
            print("This is my result: \(result.value!)");
            
            
            //if let dict = result.value as? Dictionary<String, AnyObject> {
                //self.placesArray = dict["places"] as! [Dictionary<String, AnyObject>]
                
                //myUser.cellPhone =
                //myUser.link = 
            //}
            
            /*if let dict = result.value as? JSONStandard, let main = dict["main"] as? JSONStandard, let temp = main["temp"] as? Double, let weatherArray = dict["weather"] as? [JSONStandard], let weather = weatherArray[0]["main"] as? String, let name = dict["name"] as? String, let sys = dict["sys"] as? JSONStandard, let country = sys["country"] as? String, let dt = dict["dt"] as? Double {
             
             self._temp = String(format: "%.0f °C", temp - 273.15)
             self._weather = weather
             self._location = "\(name), \(country)"
             self._date = dt
             }*/
            
            //completed()
        })
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
