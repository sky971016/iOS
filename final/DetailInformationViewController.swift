//
//  DetailInformationViewController.swift
//  final
//
//  Created by CheungTin Long on 24/6/2018.
//  Copyright © 2018年 CheungTin Long. All rights reserved.
//

import UIKit

class DetailInformationViewController: UIViewController {

    let weatherSetting = Setting.sharedInstance()
    let gradientLayer = CAGradientLayer()
    
    var cityName : String?
    var cityData : [String:[[String:String]]]?
    
    @IBOutlet weak var city: UILabel!

    @IBOutlet weak var WeatherTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        city.text = cityName
        let refresh = UIRefreshControl()
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func APItimeStringToLocalTime(input:String) -> String {
        let dateFormatterInput = DateFormatter()
        let dateFormatterOuput = DateFormatter()
        dateFormatterInput.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatterOuput.dateFormat = "HH:mm"
        
        var startTime = input
        startTime = startTime.substring(to: startTime.index(startTime.startIndex, offsetBy: 19))
        
        return dateFormatterOuput.string(from: dateFormatterInput.date(from: startTime)!)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cityData?["MinT"]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        
        
        (cell.viewWithTag(102) as? UILabel)?.text = cityData?["Wx"]?[indexPath.row]["parameterName"]
        (cell.viewWithTag(103) as? UILabel)?.text = "\((cityData?["MinT"]?[indexPath.row]["parameterName"])!) ~ \((cityData?["MaxT"]?[indexPath.row]["parameterName"])!) °C"
        
        (cell.viewWithTag(105) as? UILabel)?.text = "\(APItimeStringToLocalTime(input: (cityData?["MinT"]?[indexPath.row]["startTime"])!)) ~ \(APItimeStringToLocalTime(input: (cityData?["MinT"]?[indexPath.row]["endTime"])!))"
        
        return cell
    }
}
