//
//  ViewController.swift
//  NSUserDefaults-Test
//
//  Created by Kaj Schermer Didriksen on 26/11/2015.
//  Copyright © 2015 Kaj Schermer Didriksen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var camera: UIImageView!
    
    // Keys for the dict NSUSerDefaults, where We save the data to
    static let userName = "USERNAME"
    static let profileImage = "FROFILEIMAGE"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the prefs Data
        // first the userName
        let prefs = NSUserDefaults.standardUserDefaults()
        if let name = prefs.stringForKey(ViewController.userName) {
            userName.text = name
        }
        
        // then the profileImage
        if let imageData = prefs.objectForKey(ViewController.profileImage) as? NSData {
            let storedImage = UIImage.init(data: imageData)
            profileImage.image = storedImage
        }
        
        // if device has no camera disable the pic for camera
        if !UIImagePickerController.isSourceTypeAvailable(.Camera){
            camera.alpha = 0.5
            camera.userInteractionEnabled = false
        } else {
            camera.alpha = 1.0
            camera.userInteractionEnabled = true
        }
        
        // make the viewController the delegate for the username Textfield
        userName.delegate = self
        
    }
    
// MARK: savedata
    @IBAction func saveUserInfo() {
        
        let prefs = NSUserDefaults.standardUserDefaults()
        if userName.text!.characters.count > 0 {
            prefs.setObject(userName.text, forKey: ViewController.userName)
        }
        
        if let image = profileImage.image {
            let imageData = UIImageJPEGRepresentation(image, 100)
            prefs.setObject(imageData, forKey: ViewController.profileImage)
        }
        
    }
    
// MARK: UITextField Delegate
        func textFieldShouldReturn(textField: UITextField) -> Bool {
        userName.resignFirstResponder()
        return true
        
    }
// MARK: UIImagePicker delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // The info dictionary contains multiple representations of the image, and this uses the original
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image
        profileImage.image = selectedImage
        
        // Dismiss the picker
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
// MARK: Delegates for gestures
    @IBAction func selectImageFromLibrary(sender: UITapGestureRecognizer) {
        userName.resignFirstResponder()
        let imagePickerController  = UIImagePickerController()
        
        // Only allow images from lilb to be selected
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = .Popover
        presentViewController(imagePickerController, animated: true, completion: nil)
        imagePickerController.popoverPresentationController?.sourceView = profileImage
    }
    @IBAction func selectImageFromCamera(sender: UITapGestureRecognizer) {
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Front) != nil {
                userName.resignFirstResponder()
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = .Camera
                imagePickerController.cameraCaptureMode = .Photo
                imagePickerController.showsCameraControls = true
                presentViewController(imagePickerController, animated: true, completion: nil)
            }
        }
    }
}

