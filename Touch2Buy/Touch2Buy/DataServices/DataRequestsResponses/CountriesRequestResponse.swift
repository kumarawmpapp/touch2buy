//
//  CountriesRequestResponse.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 5/3/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import Foundation
import SwiftyJSON

class CountriesRequest: BaseRequest {
    
    init(){
        super.init(requestType: RequestTypes.RequestTypeCountries)
    }
    
    override func requestURLString()->String!
    {
        return "public/countries"
    }
    
    override func getRequestParameters()->Dictionary<String,AnyObject!>!
    {
        return Dictionary(dictionaryLiteral: ("lang","en"))
    }
}

class CountriesResponse: BaseResponse {
    override var responseType:ResponseTypes {
        return ResponseTypes.ResponseTypeCountries
    }
    
    var countries = [Country]()
    
    override func setDataFromJSONResponse(response:JSON){
        if let countriesArray = response.array {
            for countryJSON:JSON in countriesArray {
                var country = Country(countryId: countryJSON["countryId"].intValue, countryName: countryJSON["countryName"].stringValue ?? "")
                country.isoCode = countryJSON["isoCode"].string ?? ""
                country.phoneCode = countryJSON["phoneCode"].string ?? ""
                countries.append(country)
            }
        }
    }
}

struct Country : Equatable {
    let countryId:Int
    let countryName:String
    var isoCode:String!
    var phoneCode:String!
    
    
    init(countryId:Int, countryName:String){
        self.countryId=countryId
        self.countryName=countryName
    }
}

func ==(lhs: Country, rhs: Country) -> Bool {
    return lhs.countryId == rhs.countryId
}
