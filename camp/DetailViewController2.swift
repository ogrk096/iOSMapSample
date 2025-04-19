//
//  DetailViewController2.swift
//  camp
//
//  Created by 小黒皓太 on 2023/02/24.
//

import UIKit
import MapKit

var imagesname:[String] = ["kamiisodamu.jpg","higashihama.jpg","niyama.jpg","nanaesnowpark","shirotai.jpg","mirai.jpg","hakodateyama.jpg","esan.jpg","komagatake.jpg","kotaniishi.jpg","hakucho.jpg","higashionuma.jpg","yanagisawa.jpg"]

class DetailViewController2: UIViewController {

    var Name: String!
    
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var pido:Double?
        var pkeido:Double?
        var pname:String?
        
        //前ページの情報をデータベースで確認
        let (success, errorMessage, place) = DBService.shared.getStudent2(placeName: Name)
        if(success){
            if let place = place {
                //ラベルに情報を代入
                label1.text=place.PlaceName
                label2.text=place.Info
                label2.sizeToFit()
                
                pido=Double(place.Ido)/100000.0
                pkeido=Double(place.Keido)/100000.0
                pname = place.PlaceName
                
                //イメージ画像貼り付け
                let sampleImage = UIImage(named: imagesname[place.PlaceID-1])
                image.image = sampleImage
            }else {
                //print("Place not found")
            }
        } else {
            //print(errorMessage ?? "Error")
        }
        
        //マップ表示
        let loc = CLLocation(latitude: pido!, longitude: pkeido!)
        let cr = MKCoordinateRegion(center: loc.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(cr, animated: true)
        let pa = MKPointAnnotation()
        pa.title = pname!
        pa.coordinate = loc.coordinate
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(pa)
        // Do any additional setup after loading the view.
    }
}
