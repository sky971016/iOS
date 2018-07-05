//
//  PlaceViewController.swift
//  final
//
//  Created by CheungTin Long on 24/6/2018.
//  Copyright © 2018年 CheungTin Long. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    let weatherSetting = Setting.sharedInstance()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "新增"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return weatherSetting.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCells", for: indexPath)
        
        let cityName = weatherSetting.cities[indexPath.row]
        
        cell.textLabel?.text = cityName
        if (weatherSetting.weatherTableCities?.contains(cityName))! {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let cityName = cell?.textLabel?.text
        
        if cell?.accessoryType == UITableViewCellAccessoryType.checkmark {
            for i in 0 ..< (weatherSetting.weatherTableCities?.count)! {
                if(weatherSetting.weatherTableCities?[i] == cityName) {
                    weatherSetting.weatherTableCities?.remove(at: i)
                    break
                }
            }
            cell?.accessoryType = UITableViewCellAccessoryType.none
        }
        else {
            weatherSetting.weatherTableCities?.append(cityName!)
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
    }
    
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


