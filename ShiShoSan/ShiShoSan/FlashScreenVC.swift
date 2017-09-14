//
//  FlashScreenVC.swift
//  ShiShoSan
//
//  Created by Ngô Hải Vân on 7/31/17.
//  Copyright © 2017 Ngô Hải Vân. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

@available(iOS 10.0, *)
class FlashScreenVC: UIViewController {
    var listArea: [Area] = []
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.startAnimating()
        if FIRAuth.auth()?.currentUser == nil {
            perform(#selector(showLoginView), with: nil, afterDelay: 1)
        }else{
            if FBSDKAccessToken.current() != nil{
                if UserDefaults.standard.string(forKey: "city_id") == nil || UserDefaults.standard.string(forKey: "city_id") == ""{
                    listArea = DataManagar.shared.queryAllArea()
                    if listArea.count == 0 {
                        loadData()
                    }else{
                        perform(#selector(showSelector), with: nil, afterDelay: 1)
                    }
                }else{
                    perform(#selector(showIndex), with: nil, afterDelay: 1)
                }
            }else{
                if !((FIRAuth.auth()?.currentUser?.isEmailVerified)!){
                    try! FIRAuth.auth()?.signOut()
                    showLoginView()
                }else{
                    listArea = DataManagar.shared.queryAllArea()
                    if listArea.count == 0 {
                        loadData()
                    }else{
                        perform(#selector(showSelector), with: nil, afterDelay: 1)
                    }
                }
            }
        }
    }
    func showSelector(){
        self.performSegue(withIdentifier: "selectorVC", sender: nil)
    }
    func showIndex(){
        self.performSegue(withIdentifier: "startIndexActivity", sender: nil)
    }
    func showLoginView(){
        let loginVC = LoginViewController()
        present(loginVC, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadData(){
        var count = 0
        let ref = FIRDatabase.database().reference().child("arena")
        ref.observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else {
                return
            }
            let area = Area()
            area.id = snapshot.key
            area.cities = [City]()
            if let cities = dictionary["cities"] as? [String: AnyObject] {
                for (key, value) in cities {
                    let city = City()
                    city.id = key
                    city.name = value["name"] as? String
                    city.listLines = value["listLines"] as? String
                    city.areaID = area.id
                    area.cities.append(city)
                }
            }
            
            if let lines = dictionary["lines"] as? [String: AnyObject] {
                for (key, value) in lines {
                    let line = Line()
                    line.id = key
                    line.name = value["name"] as! String
                    line.listStation = value["listStation"] as! String
                    line.company = value["company"] as! String
                    line.areaID = area.id!
                    area.lines.append(line)
                }
            }
            if let stations = dictionary["stations"] as? [String: AnyObject] {
                for (key, value) in stations {
                    let staion = Station()
                    staion.id = key
                    staion.name = (value["name"] as? String)!
                    staion.areaID = area.id!
                    area.stations.append(staion)
                }
            }
            if let name = dictionary["name"] as? String {
                area.name = name
            }
            self.listArea.append(area)
            DispatchQueue.main.async(execute: {
                for i in 0 ..< area.cities.count{
                    _ = DataManagar.shared.addCity(area.cities[i])
                }
                for i in 0 ..< area.lines.count{
                    _ = DataManagar.shared.addLine(newLine: area.lines[i])
                }
                for i in 0 ..< area.stations.count{
                    _ = DataManagar.shared.addStation(newStaion: area.stations[i])                }
                _ = DataManagar.shared.addArea(newArea: area)
                count += 1
                if(count == 7){
                    self.perform(#selector(self.showSelector), with: nil, afterDelay: 0.5)
                }
            })
        })
    }
}
