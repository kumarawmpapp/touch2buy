//
//  CitiesRequestResponse.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 3/27/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import Foundation
import SwiftyJSON

class CitiesRequest: BaseRequest {
    
    init(){
        super.init(requestType: RequestTypes.RequestTypeCities)
    }
    
    override func requestURLString()->String!
    {
        return "public/cities"
    }
    
    override func getRequestParameters()->Dictionary<String,AnyObject!>!
    {
        return Dictionary(dictionaryLiteral: ("lang","en"),("isoCode","LK"))
    }
}

class CitiesResponse: BaseResponse {
    override var responseType:ResponseTypes {
        return ResponseTypes.ResponseTypeCities
    }
    
    var cities = [City]()
    
    override func setDataFromJSONResponse(response:JSON){
        if let citiesArray = response.array {
            for cityJSON:JSON in citiesArray {
                var city = City(cityId: cityJSON["cityId"].intValue, cityName: cityJSON["cityName"].stringValue)
                city.countryId = cityJSON["countryId"].intValue
                cities.append(city)
            }
        }
    }
}

struct City {
    let cityId:Int
    let cityName:String
    var countryId:Int!
    var zipCode:String!
    
    
    init(cityId:Int, cityName:String){
        self.cityId=cityId
        self.cityName=cityName
    }
}