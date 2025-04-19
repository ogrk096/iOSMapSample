//
//  ViewController2.swift
//  camp
//
//  Created by 小黒皓太 on 2023/02/22.
//

import UIKit

var checkId:Int?

class ViewController2: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var myTableView: UITableView!
    var systemIcons:[String] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return systemIcons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath)
            
        cell.textLabel?.text = systemIcons[indexPath.row]
            
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        myTableView.reloadData()
        
        systemIcons.removeAll()
        systemIcons.append("Not")
        
        if err == 0{
            for j in 1...13{
                var s:String
                s=search(i: j)
                if(s != "Not"){
                    systemIcons.removeLast()
                    systemIcons.append(s)
                }
            }
        }
        
        if(systemIcons[0] == "Not"){
            checkId = 0;
        }
            
        if let indexPath = myTableView.indexPathForSelectedRow{
            myTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func search(i:Int) -> String{
        let (success, errorMessage, place) = DBService.shared.getStudent(placeId: i)
        if(success){
            if let place = place {
                var idomin:Double
                var idomax:Double
                var keidomin:Double
                var keidomax:Double
                var name:String="Not"
                idomin=Double(place.IdoMin)/100000.0
                idomax=Double(place.IdoMax)/100000.0
                keidomin=Double(place.KeidoMin)/100000.0
                keidomax=Double(place.KeidoMax)/100000.0
                
                if ido!>=idomin && ido!<=idomax && keido!>=keidomin && keido!<=keidomax {
                    name=place.PlaceName
                    checkId = place.PlaceID
                }
                return name
            } else {
                //print("Place not found")
                return "Not"
            }
        } else {
            //print(errorMessage ?? "Error")
            return "Not"
        }
    }

}
