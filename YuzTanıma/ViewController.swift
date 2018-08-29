//
//  ViewController.swift
//  YuzTanıma
//
//  Created by alikaraca on 28.08.2018.
//  Copyright © 2018 alikaraca. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var myTextView: UITextView!
    @IBAction func yukle(_ sender: Any) {
        let imagePicker=UIImagePickerController()
        imagePicker.delegate=self
        imagePicker.sourceType=UIImagePickerControllerSourceType.photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image=info[UIImagePickerControllerOriginalImage] as? UIImage{
            myImageView.image=image
            detect()
        }
        self.dismiss(animated: true, completion: nil)
    }
    func detect(){
        let myImage=CIImage(image: myImageView.image!)
        let accuracy=[CIDetectorAccuracy:CIDetectorAccuracyHigh]
        let detector=CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces=detector?.features(in: myImage! ,options:[CIDetectorSmile:true])
        if !faces!.isEmpty{
            for face in faces as! [CIFaceFeature]{
                let mouthshowing="\nMouth Showing: \(face.hasMouthPosition)"
                let isSmiling="\nKişi Gülümsüyor:\(face.hasSmile)"
                var bothEyesShowing="\n2 göz görünüyor"
                if !face.hasRightEyePosition || !face.hasLeftEyePosition{
                    bothEyesShowing="\n2 göz görünmüyor"
                }
                let array=["Low","Medium","High","Very High"]
                var suspectDegree=0
                if !face.hasMouthPosition{suspectDegree+=1}
                if !face.hasSmile{suspectDegree+=1}
                if bothEyesShowing.contains("false"){suspectDegree+=1}
                if face.faceAngle>10 || face.faceAngle < -10 {suspectDegree+=1}
                let suspectText="\(array[suspectDegree])"
                myTextView.text="\(suspectText)\n\(mouthshowing)\n\(isSmiling)\n\(bothEyesShowing)"
            }
            
        }else{
            myTextView.text="Yüz Bulunamadı"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        detect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

