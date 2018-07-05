//
//  DownloadDataInWeb.swift
//  final
//
//  Created by CheungTin Long on 26/6/2018.
//  Copyright © 2018年 CheungTin Long. All rights reserved.
//

import Foundation

class DownloadDataInWeb : NSObject, XMLParserDelegate{
    static var SharedInstance : DownloadDataInWeb? = nil
    let API_key = "CWB-615AC5A9-6852-422B-9CF6-E9909FF4DB61"
    let getDataType = "F-C0032-001"
    
    var resultTemp : NSMutableDictionary?
    var locationNameTemp : String = ""
    var elementNameTemp : String = ""
    
    var foundStringTemp : String = ""
    var weatherData : NSMutableDictionary?
    
    static func sharedInstance() -> DownloadDataInWeb{
        
        if(DownloadDataInWeb.SharedInstance == nil) {
            DownloadDataInWeb.SharedInstance = DownloadDataInWeb()
        }
        
        return DownloadDataInWeb.SharedInstance!
    }
    
    func downloadDataFromAPI() -> NSMutableDictionary? {
        self.weatherData = nil
        let url = "https://zh.tideschart.com/worldwide-tides/" 
        let semaphore = DispatchSemaphore.init(value: 0)
        let task = URLSession.shared.dataTask(with: URL.init(string: url)!) { (data, response, error) in
            if data != nil {
                let parser = XMLParser.init(data: data!)
                parser.delegate = self
                parser.parse()
                self.weatherData = self.resultTemp
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        
        let notificationName = Notification.Name("DataDownloadCompleted")
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
        
        return weatherData
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        resultTemp = NSMutableDictionary()
    }
    
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]){
        let elementDic = resultTemp?[locationNameTemp] as? NSMutableDictionary
        let timeArray = elementDic?[elementNameTemp] as? NSMutableArray
        
        foundStringTemp = ""
        
        switch elementName {
        case "time":
            timeArray?.add(NSMutableDictionary())
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser,
                foundCharacters string: String){
        foundStringTemp += string
        
    }
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        let elementDic = resultTemp?[locationNameTemp] as? NSMutableDictionary
        let timeArray = elementDic?[elementNameTemp] as? NSMutableArray
        
        switch elementName {
        case "locationName":
            locationNameTemp = foundStringTemp
            resultTemp?[locationNameTemp] = NSMutableDictionary()
        case "elementName":
            elementNameTemp = foundStringTemp
            elementDic?[elementNameTemp] = NSMutableArray()
        case "startTime" , "endTime" , "parameterName" , "parameterValue":
            let timeDic = timeArray?[(timeArray?.count)! - 1] as? NSMutableDictionary
            timeDic?[elementName] = foundStringTemp
        default:
            break
        }
        
    }
}
