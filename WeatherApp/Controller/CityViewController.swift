//
//  CityViewController.swift
//  WeatherApp
//
//  Created by ivan on 2021/10/29.
//

import UIKit
import PromiseKit
import Alamofire
import SwiftyJSON
import RealmSwift


class CityViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    var cityDetailList : [CityDetail] = []
    
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count < 3 {
            return
        }
        print(searchText)
        loadAutoCompletedTable(searchText)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cityDetailList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        cell.textLabel?.text = "\(cityDetailList[indexPath.row].localizedName), \(cityDetailList[indexPath.row].countryLocalizedName)"
        return cell
    }
    
    func addCityinDB(_ city : CityDetail){
        do{
            let realm = try Realm()
            try realm.write {
                realm.add(city, update: .modified)
            }
        }catch{
            print("Error in getting values from DB \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cityDetailList[indexPath.row]
        if (self.doesCityExistInDB(city.key)) {
            print("You already added this city")
            return
        }
        self.addCityinDB(city)
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func doesCityExistInDB(_ symbol : String) -> Bool {
        do{
            let realm = try Realm()
            if realm.object(ofType: CityDetail.self, forPrimaryKey: symbol) != nil { return true }
            
        }catch{
            print("Error in getting values from DB \(error)")
        }
        return false
    }
    
    func loadAutoCompletedTable(_ searchText : String ) -> Void {
        let url = locationSearchURL + "apikey=" + apiKey + "&q=" + searchText
        AF.request(url).responseJSON { response in
            
            if response.error != nil {
                print(response.error?.localizedDescription)
            }
            
            let cities = JSON(response.data!).arrayValue
            print(cities)
            self.cityDetailList = []
            for city in cities {
                let cityDetail = CityDetail()
                cityDetail.key = city["Key"].stringValue
                cityDetail.type = city["Type"].stringValue
                cityDetail.localizedName = city["LocalizedName"].stringValue
                cityDetail.countryID = city["Country"].dictionaryValue["ID"]!.stringValue
                cityDetail.countryLocalizedName = city["Country"].dictionaryValue["LocalizedName"]!.stringValue
                cityDetail.administrativeID = city["AdministrativeArea"].dictionaryValue["ID"]!.stringValue
                cityDetail.administrativeLocalizedName = city["AdministrativeArea"].dictionaryValue["LocalizedName"]!.stringValue
                
                self.cityDetailList.append(cityDetail)
            }
            
            self.tblView.reloadData()
        }
    }
    
}
