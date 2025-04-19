//
//  ViewController.swift
//  camp
//
//  Created by 小黒皓太 on 2023/02/21.
//

import UIKit
import CoreLocation
import MapKit

//緯度経度の変数
var ido:Double?
var keido:Double?
var err = 0

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var placear:[Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placear.append(Place(placeID: 1, placeName: "上磯ダム", idoMin: 4186493, idoMax: 4187307, keidoMin: 14058637, keidoMax: 14060248, count: 0, info: "北斗市にあるダム。近くには上磯ダム公園キャンプ場もある。キャンプ場は無料で使うことができる。また上磯ダムは釣りで有名。奥にある釜の仙郷には大きなイワナがいるんだとか。", ido: 4186792, keido: 14059364))
        placear.append(Place(placeID: 2, placeName: "東浜児童公園", idoMin: 4182557, idoMax: 4182636, keidoMin: 14066447, keidoMax: 14066546, count: 0, info: "我が家の隣の公園。自分が小さい頃によく遊んだ。冬は雪捨て場になっている。", ido: 4182581, keido: 14066474))
        placear.append(Place(placeID: 3, placeName: "ニヤマ高原スキー場", idoMin: 4193160, idoMax: 4193553, keidoMin: 14063040, keidoMax: 14063556, count: 0, info: "七飯町にあるスキー場。昔ながらのローカルなスキー場。リフトはシングルリフトとペアリフトの2機。ナイターは1000円とお得で函館市や北斗市の夜景を見ながら楽しめる。", ido: 4193289, keido: 14063395))
        placear.append(Place(placeID: 4, placeName: "函館七飯スノーパーク", idoMin: 4197568, idoMax: 4199046, keidoMin: 14074487, keidoMax: 14075860, count: 0, info: "七飯町にあるスキー場。道南エリア最大級のスキー場。最長滑走距離は4km。ゴンドラの長さは3300mで北海道では1番、日本では3番目に長い。樹氷が育つ子で有名でスキーをしなくても楽しめる。", ido: 4198569, keido: 14074783))
        placear.append(Place(placeID: 5, placeName: "城岱牧場", idoMin: 4192070, idoMax: 4192391, keidoMin: 14071030, keidoMax: 14071432, count: 0, info: "七飯町にある牧場。高原に位置していて、見晴らしが良い。ドライブ、ツーリングスポットとしても有名で、たくさんの人々が訪れる。夜は夜景が綺麗。", ido: 4192223, keido: 14071150))
        placear.append(Place(placeID: 6, placeName: "未来大学", idoMin: 4184093, idoMax: 4184538, keidoMin: 14076245, keidoMax: 14077141, count: 0, info: "自分の通っている大学", ido: 4184306, keido: 14076784))
        placear.append(Place(placeID: 7, placeName: "函館山", idoMin: 4175878, idoMax: 4175977, keidoMin: 14070299, keidoMax: 14070539, count: 0, info: "世界三大夜景の一つ。4月から11月まで車で登ることができる。年中ロープウェイで登ることができる。", ido: 4175923, keido: 14070441))
        placear.append(Place(placeID: 8, placeName: "恵山岬灯台", idoMin: 4181454, idoMax: 4181603, keidoMin: 14118179, keidoMax: 14118359, count: 0, info: "函館の東にある。霧がよく発生する原始的な場所。", ido: 4181510, keido: 1418293))
        placear.append(Place(placeID: 9, placeName: "駒ヶ岳", idoMin: 4205637, idoMax: 4206037, keidoMin: 14068118, keidoMax: 14068786, count: 0, info: "函館周辺で1番高い山。大沼の近郊にありアクセスも良い。難易度は初級のため誰でも気軽に登山できる。", ido: 4205803, keido: 14068508))
        placear.append(Place(placeID: 10, placeName: "小谷石", idoMin: 4152491, idoMax: 4153573, keidoMin: 14042845, keidoMax: 14042916, count: 0, info: "知内町にある海浜公園。函館から70kmほど西にある。キャンプ場にもなっており夏のレジャーには最高である。", ido: 4153531, keido: 14042870))
        placear.append(Place(placeID: 11, placeName: "白鳥セバット", idoMin: 4198902, idoMax: 4198951, keidoMin: 14066554, keidoMax: 14066622, count: 0, info: "大沼にあるビュースポット。冬になると白鳥が多く集まる。", ido: 4198922, keido: 14066596))
        placear.append(Place(placeID: 12, placeName: "東大沼キャンプ場", idoMin: 4201270, idoMax: 4201338, keidoMin: 14071357, keidoMax: 14071627, count: 0, info: "大沼の北にあるキャンプ場。無料でキャンプができる。夏には多くの人たちが集まる。", ido: 4201310, keido: 14071505))
        placear.append(Place(placeID: 13, placeName: "柳沢スキー場", idoMin: 4181280, idoMax: 4181362, keidoMin: 14060465, keidoMax: 14060586, count: 0, info: "北斗市にある無料のスキー場。無料であるためリフトがない。滑るには登山する必要がある。", ido: 4181343, keido: 14060548))
        if err == 0 {
            //位置情報の初期化
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.distanceFilter = 5;
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        }
        
        //データベースの初起動時の処理 for文のループ数はデータベースの情報の数
        for i in 1...13{
            var hantei=0
            
            //データベースに情報があるかを確認
            let (success, errorMessage, place) = DBService.shared.getStudent(placeId: i)
            if(success){
                if let place = place {
                    hantei=1;
                }
            }
            
            //情報がない場合は代入
            if hantei == 0{
                let place1:Place
                place1 = placear[i-1]
                
                //データベースへの挿入処理
                if DBService.shared.insertStudent(place: place1) {
                    print("Insert success")
                } else {
                    print("Insert Failed")
                }
            }
        }
        
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
    }

    //位置情報関連の処理
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let loc = locations.last else { return }
            
            CLGeocoder().reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) in
                
                if let error = error {
                    print("reverseGeocodeLocation Failed: \(error.localizedDescription)")
                    return
                }
                
                if let placemark = placemarks?[0] {
                    
                    //緯度と経度情報を保存
                    ido=loc.coordinate.latitude
                    keido=loc.coordinate.longitude
                }
            })
        
            let cr = MKCoordinateRegion(center: loc.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(cr, animated: true)
            
            manager.startUpdatingLocation()
        
            //データベース内の地点をピン
            mapView.removeAnnotations(mapView.annotations)
        
            for j in 1...7 {
                var idod:Double
                var keidod:Double
                idod = Double(placear[j-1].Ido)/100000.0
                keidod = Double(placear[j-1].Keido)/100000.0
                addAnnotation(latitude: idod, longitude: keidod, title: placear[j-1].PlaceName)
            }
        }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
        err=1
    }
    
    func addAnnotation(latitude: CLLocationDegrees,longitude: CLLocationDegrees, title:String) {
           
           // ピンの生成
           let annotation = MKPointAnnotation()
           
           // 緯度経度を指定
           annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)

           // タイトル、サブタイトルを設定
           annotation.title = title

           // mapViewに追加
           mapView.addAnnotation(annotation)
       }
}

