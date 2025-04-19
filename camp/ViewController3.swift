//
//  ViewController3.swift
//  camp
//
//  Created by 小黒皓太 on 2023/02/24.
//

import UIKit

class ViewController3: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var systemIcons:[String] = []
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self
        
        for j in 1...13 {
            systemIcons.append(search1(i: j))
        }
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
        if let indexPath = myTableView.indexPathForSelectedRow{
            myTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func search1(i:Int) -> String{
        let (success, errorMessage, place) = DBService.shared.getStudent(placeId: i)
        if(success){
            if let place = place {
                var name:String="Not"
                name=place.PlaceName
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue2" {
            if let indexPath = myTableView.indexPathForSelectedRow {
                guard let destination = segue.destination as? DetailViewController2 else {
                    fatalError("Failed to prepare DetailViewController.")
                }
                
                destination.Name = systemIcons[indexPath.row]
            }
        }
    }
}
