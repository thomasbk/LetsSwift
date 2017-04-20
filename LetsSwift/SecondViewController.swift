//
//  SecondViewController.swift
//  LetsSwift
//
//  Created by Thomas Baltodano on 4/19/17.
//  Copyright © 2017 Thomas Baltodano. All rights reserved.
//

import UIKit

import Alamofire

class SecondViewController: UIViewController {
    
    var weather = DataModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        print("Started downloading")
        weather.downloadData {
            self.updateUI()
        }
    }
    
    @IBAction func testClick(_ sender: UIButton) {
        print("Click working!")
    }
    
    
    func updateUI() {
        
        
        print("finished downloading")
        //dateLabel.text = weather.date
        //tempLabel.text = "\(weather.temp)"
        //locationLabel.text = weather.location
        //weatherLabel.text = weather.weather
        //weatherImage.image = UIImage(named: weather.weather)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

