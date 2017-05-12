//
//  CameraViewController.swift
//  LetsSwift
//
//  Created by Thomas Baltodano on 5/6/17.
//  Copyright © 2017 Thomas Baltodano. All rights reserved.
//

import UIKit

import Alamofire

class CameraViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    
    @IBOutlet var imageView: UIImageView?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    //extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        @IBAction func showCameraOptions() {
            let camera = DSCameraHandler(delegate_: self)
            let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            optionMenu.popoverPresentationController?.sourceView = self.view
            
            let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (alert : UIAlertAction!) in
                camera.getCameraOn(self, canEdit: true)
            }
            let sharePhoto = UIAlertAction(title: "Photo Library", style: .default) { (alert : UIAlertAction!) in
                camera.getPhotoLibraryOn(self, canEdit: true)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction!) in
            }
            optionMenu.addAction(takePhoto)
            optionMenu.addAction(sharePhoto)
            optionMenu.addAction(cancelAction)
            self.present(optionMenu, animated: true, completion: nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            
            imageView!.image = info[UIImagePickerControllerEditedImage] as? UIImage
            
            // image is our desired image
            
            picker.dismiss(animated: true, completion: nil)
            //self.openPanel()
        }
    //}
    
    
    
    
    
    
    // Option 1
    @IBAction func uploadImage() {
        
        //Convert image to base64
        let image : UIImage = imageView!.image!
        //let imageData = UIImagePNGRepresentation(image)
        let imageData = UIImageJPEGRepresentation(image, 0.2)!
        let base64String = imageData.base64EncodedData(options: .lineLength64Characters)
        
        //let base64String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
        
        // build parameters
        
        let parameters = ["image": ["file" : base64String], "access_token" : "AccessToken"] as [String : AnyObject]
        
        // build request
        
        let urlString = "http://example.com/upload"
        
        
        Alamofire.request(urlString, method: .post, parameters: parameters).responseJSON(completionHandler: {
            response in
            let result = response.result
            print("This is my result: \(result.value!)");
            
            
            //if let dict = result.value as? Dictionary<String, AnyObject> {
            //    self.placesArray = dict["places"] as! [Dictionary<String, AnyObject>]
            //}
            
            /*if let dict = result.value as? JSONStandard, let main = dict["main"] as? JSONStandard, let temp = main["temp"] as? Double, let weatherArray = dict["weather"] as? [JSONStandard], let weather = weatherArray[0]["main"] as? String, let name = dict["name"] as? String, let sys = dict["sys"] as? JSONStandard, let country = sys["country"] as? String, let dt = dict["dt"] as? Double {
             
             self._temp = String(format: "%.0f °C", temp - 273.15)
             self._weather = weather
             self._location = "\(name), \(country)"
             self._date = dt
             }*/
            
        })
    }
    
    // Option 2
    func uploadAvatar(image: UIImage) {
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let imageData = UIImageJPEGRepresentation(image, 1) {
                multipartFormData.append(imageData, withName: "file", fileName: "file.png", mimeType: "image/png")
            }
        }, to: "ServerAdress" + "/user/uploadAvatar", method: .post, headers: ["Authorization": "Token"], encodingCompletion: { _ in })
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
