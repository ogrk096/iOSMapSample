//
//  DetailViewController.swift
//  camp
//
//  Created by 小黒皓太 on 2023/02/22.
//

import UIKit

class DetailViewController: UIViewController {

    var Name1: String!
    
    @IBOutlet weak var clearname: UILabel!
    @IBOutlet weak var clearcount: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var image1: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var countPlace:Place?
        
        if(checkId != 0){
            let (success, errorMessage, place) = DBService.shared.getStudent(placeId: checkId!)
            if(success){
                if let place = place {
                    countPlace = place
                    countPlace?.Count += 1
                    
                    let sampleImage = UIImage(named: imagesname[place.PlaceID-1])
                    image.image = sampleImage
                }else {
                    //print("Place not found")
                }
            } else {
                //print(errorMessage ?? "Error")
            }
            
            if DBService.shared.updateStudent(place: countPlace!) {
                //print("Update success")
            } else {
                //print("Update Failed")
            }
            clearname.text = countPlace?.PlaceName
            clearcount.text = "\(countPlace!.Count) 回チェックイン"
            
            let sample = UIImage(named: "clear.jpeg")
            image1.image = sample
        }else{
            clearname.text = ""
            clearcount.text = "チェックインできるところまで移動してください。"
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
}
