//
//  ThirdViewController.swift
//  LetsSwift
//
//  Created by Thomas Baltodano on 4/21/17.
//  Copyright © 2017 Thomas Baltodano. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ThirdViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView?
        
    var weather = DataModel()

    
    let cellIdentifier = "CellIdentifier"
    
    var fruits: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        print("Loaded third view")
        
        print("Started downloading")
        weather.downloadData {
            self.updateUI()
        }
        
        
        
        fruits = ["Apple", "Pineapple", "Orange", "Blackberry", "Banana", "Pear", "Kiwi", "Strawberry", "Mango", "Walnut", "Apricot", "Tomato", "Almond", "Date", "Melon", "Water Melon", "Lemon", "Coconut", "Fig", "Passionfruit", "Star Fruit", "Clementin", "Citron", "Cherry", "Cranberry"]

    }
    
    
    func updateUI() {
        
        print("finished downloading")
        //dateLabel.text = weather.date
        //tempLabel.text = "\(weather.temp)"
        //locationLabel.text = weather.location
        //weatherLabel.text = weather.weather
        //weatherImage.image = UIImage(named: weather.weather)
        
    }
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = fruits.count
        return numberOfRows
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! CustomCell
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("PlayerCell", forIndexPath: indexPath) as! PlayerCell
        
        // Fetch Fruit
        let fruit = fruits[indexPath.row]
        
        
        let url = URL(string: "https://httpbin.org/image/png")!
        let placeholderImage = UIImage(named: "Smiley_Face.png")!
        
        
        cell.myImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
        cell.nameLabel.text = fruit
        
        
        
        return cell
    }
    
    
    
    
    
    // MARK: -
    // MARK: Table View Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
