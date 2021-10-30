//
//  ViewController.swift
//  WeatherApp
//
//  Created by ivan on 2021/10/29.
//

import UIKit
import RealmSwift
import PromiseKit
import SwiftyJSON
import SwiftSpinner
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var cityDetail = [CityDetail]()
    var weatherDetailList = [WeatherDetail]()
    
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        loadWeatherDetail()
    }
    
    func loadWeatherDetail() -> Void {
        do{
            let realm = try Realm()
            let cities = realm.objects(CityDetail.self)
            self.cityDetail = Array(cities)
            self.weatherDetailList.removeAll()
            getAllWeatherDetail(Array(cities)).done { currentWeather in
                self.weatherDetailList.append(contentsOf: currentWeather)
                self.tblView.reloadData()
            }
            .catch { error in
               print(error)
            }
       }catch{
           print("Error in reading Database \(error)")
       }
    }
    
    func getAllWeatherDetail(_ cityDetails:[CityDetail]) -> Promise<[WeatherDetail]> {
        
        var promises: [Promise<WeatherDetail>] = []
        
        for city in cityDetails {
            promises.append(getWeatherDetail(city.key))
            
        }
    
        return when(fulfilled: promises)
            
    }
    
    func getWeatherDetail(_ cityKey : String) -> Promise<WeatherDetail> {
        return Promise<WeatherDetail> { seal -> Void in
            let url = currentConditionURL + cityKey + "?apikey=" + apiKey
            
            AF.request(url).responseJSON{ res in
                
                if res.error != nil {
                    seal.reject(res.error!)
                }
                
                let weather = WeatherDetail()
                let datas = JSON(res.data!).array
                
                guard let data = datas!.first else {
                    seal.fulfill(WeatherDetail())
                    return
                }
                print(res.data)
                print(data)
                
                weather.key = cityKey
                weather.weatherText = data.dictionaryValue["WeatherText"]!.stringValue
                weather.weatherIcon = data.dictionaryValue["WeatherIcon"]!.intValue
                weather.hasPrecipitation = data.dictionaryValue["HasPrecipitation"]!.boolValue
                weather.precipitationType = data.dictionaryValue["PrecipitationType"]!.stringValue
                weather.isDayTime = data.dictionaryValue["IsDayTime"]!.boolValue
                weather.tempMetricValue = data.dictionaryValue["Temperature"]!.dictionaryValue["Metric"]!.dictionaryValue["Value"]!.doubleValue
                weather.tempMetricUnit = data.dictionaryValue["Temperature"]!.dictionaryValue["Metric"]!.dictionaryValue["Unit"]!.stringValue
                weather.tempImperialValue = data.dictionaryValue["Temperature"]!.dictionaryValue["Imperial"]!.dictionaryValue["Value"]!.doubleValue
                weather.tempImperialUnit = data.dictionaryValue["Temperature"]!.dictionaryValue["Metric"]!.dictionaryValue["Unit"]!.stringValue
                
                seal.fulfill(weather)
            }
            
        }
       
    }
    
    func removeFromDB(_ city : CityDetail) -> Void {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "key = %@", city.key)
        let toDelete = Array(realm.objects(CityDetail.self).filter(predicate)).first!
        try! realm.write {
            realm.delete(toDelete)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toDelete = cityDetail[indexPath.row]
            cityDetail.remove(at: indexPath.row)
            weatherDetailList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            removeFromDB(toDelete)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDetailList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("WeatherTableViewCell", owner: self, options: nil)?.first as! WeatherTableViewCell
        let weather = weatherDetailList[indexPath.row]
        cell.lblCity.text = cityDetail[indexPath.row].localizedName
        cell.lblTemp.text = "\(weather.tempImperialValue)"
        cell.imgWeather.image = UIImage(named: "\(weather.weatherIcon)")
        return cell
    }
    
}

