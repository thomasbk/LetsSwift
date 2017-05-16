//
//  CoreAnimationViewController.swift
//  LetsSwift
//
//  Created by Thomas Baltodano on 5/15/17.
//  Copyright © 2017 Thomas Baltodano. All rights reserved.
//

import UIKit

class CoreAnimationViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    
    var scaleFactor: CGFloat = 2
    var angle: Double = 180
    var boxView: UIImageView?
    
    @IBOutlet var cameraButton: UIButton?
    @IBOutlet var resetButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        
        let frameRect = CGRect(x:20,y: 20,width: 45,height: 45)
        
        boxView = UIImageView(frame: frameRect)
        boxView?.backgroundColor = UIColor.blue
        
        boxView!.layer.cornerRadius = boxView!.frame.size.width / 4;
        boxView!.clipsToBounds = true;
        
        boxView!.layer.borderWidth = 1.0
        boxView!.layer.borderColor = UIColor.blue.cgColor
        
        self.view.addSubview(boxView!)
        
        resetButton!.isHidden = true
        
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    //override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first!
        let location = touch.location(in: self.view)
        
        
        UIView.animate(withDuration: 0.2, delay: 0.2, options: [.curveEaseInOut], animations: {
        
            let scaleTrans =
                CGAffineTransform(scaleX: self.scaleFactor,
                                  y: self.scaleFactor)
            let rotateTrans = CGAffineTransform(
                rotationAngle: CGFloat(self.angle * Double.pi / 180))
            
            self.boxView!.transform =
                scaleTrans.concatenating(rotateTrans)
            
            self.angle = (self.angle == 180 ? 360 : 180)
            self.scaleFactor = (self.scaleFactor == 2 ? 1 : 2)
            self.boxView?.center = location
        }, completion: nil)
        
        }
    
    
    
    
    
    
    
    
    
    
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
        
        boxView!.image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        // image is our desired image
        
        picker.dismiss(animated: true, completion: nil)
        //self.openPanel()
        
        resetButton!.isHidden = false
        cameraButton!.isHidden = true
        
        
        let alert = UIAlertController(title: "Alert", message: "Tap the screen to animate", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func resetAction() {
        
        resetButton!.isHidden = true
        cameraButton!.isHidden = false
    }
    
    
    
    
    
    
    
    func animateBulb () {
        
        let imageView = UIImageView()
        let onImage = UIImage()
        let offImage = UIImage()
        
        let myAnim = CABasicAnimation(keyPath: "contents")
        myAnim.fromValue = offImage.cgImage
        myAnim.toValue = onImage.cgImage
        myAnim.duration = 0.15
        
        imageView.layer.add(myAnim, forKey: "contents")
        
        imageView.image = onImage
        
    }
    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
