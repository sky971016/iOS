//
//  NormalTableViewController.swift
//  final
//
//  Created by CheungTin Long on 24/6/2018.
//  Copyright © 2018年 CheungTin Long. All rights reserved.
//

import UIKit

class NormalTableViewController: UITableViewController {

    let weatherSetting = Setting.sharedInstance()
    var tableData : NSMutableDictionary?
    var tableDataIndex : Int = 0
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refresh = UIRefreshControl()
        refresh .addTarget(self, action: #selector(downloadDataFromAPI), for: .valueChanged)
        self.tableView.refreshControl = refresh
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "sea"))
        self.tableView.backgroundView?.alpha = 0.5
        downloadDataFromAPI()
        }
        
       
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.tableData == nil {
            return 0
        }
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherSetting.weatherTableCities?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCells", for: indexPath)
        
        
        let locationName = weatherSetting.weatherTableCities?[indexPath.row]
        let locationData = self.tableData?[locationName!] as? [String:[[String:String]]]
        
        
        (cell.viewWithTag(101) as? UILabel)?.text = locationName
        (cell.viewWithTag(102) as? UILabel)?.text = "\((locationData?["MinT"]?[tableDataIndex]["parameterName"])!) ~ \((locationData?["MaxT"]?[tableDataIndex]["parameterName"])!) °C"
        
        /*(cell.viewWithTag(105) as? UILabel)?.text = "\(APItimeStringToLocalTime(input: (locationData?["MinT"]?[tableDataIndex]["startTime"])!)) ~ \(APItimeStringToLocalTime(input: (locationData?["MinT"]?[tableDataIndex]["endTime"])!))"*/
        
        return cell
    }


    @objc func downloadDataFromAPI() {
    self.tableData = nil
    self.tableView.reloadData()
    DispatchQueue.global().async {
    let downloadDataInWeb = DownloadDataInWeb.sharedInstance()
    self.tableData = downloadDataInWeb.downloadDataFromAPI()
        
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
}
    
    @objc func UpdateSetting(noti: Notification){
        //iflet userInfo = noti.userInfo, let lover = userInfo["lover"] as? Lover {lovers.insert(lover, at: 0)tableView.reloadData()
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let des = segue.destination
        if segue.identifier == "Detail" {
            let cell = sender as? UITableViewCell
            let cityName = cell?.viewWithTag(101) as? UILabel
            des.setValue(cityName?.text, forKey: "cityName")
            des.setValue(tableData?[(cityName?.text)!], forKey: "cityData")
        }
}
    


}
