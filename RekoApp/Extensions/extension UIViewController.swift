
//  RekoApp
//
//  Created by Sandra Sundqvist on 2019-04-09.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
  
    
    func dissmissKEyboardWhenTapping(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
    
    //Show a toastmessage and when done doing something else
    func showToast(message : String, onCompletion: @escaping(Bool)->Void) {
        showToast(message: message)
        onCompletion(true)
    }
    
    func showToast(message : String) {
        
        //Skapar ett toastmeddelande
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height/2 - 50, width: 200, height: 100))
        toastLabel.backgroundColor = UIColor.white
        toastLabel.textColor = UIColor.black
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont(name: "Arial", size: 14.0)
        toastLabel.text = message
        toastLabel.numberOfLines = 0
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 2.0, delay: 0.3, options: .curveEaseInOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func addCameraActionPopupFor(imagePickerController: UIImagePickerController) {
        let actionPopUp = UIAlertController(title: "Add a picture", message:"", preferredStyle: .actionSheet)
        actionPopUp.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            //Kollar om det finns en tillgänglig kamera
            if(UIImagePickerController.isSourceTypeAvailable(.camera)){
                imagePickerController.allowsEditing = true
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
                self.showToast(message: "Camera is not available")
            }
        }))
        
        actionPopUp.addAction(UIAlertAction(title: "Photolibrary", style: .default, handler: { (action: UIAlertAction) in
            //Hämtar bild från bildbiblioteket
            imagePickerController.allowsEditing = true
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
       //Cancel-button
        actionPopUp.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionPopUp, animated: true, completion: nil)
    }
    
}
