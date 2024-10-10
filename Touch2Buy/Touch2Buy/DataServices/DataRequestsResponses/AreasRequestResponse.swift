//
//  AreasRequestResponse.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 8/9/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import Foundation
import SwiftyJSON

class AreasRequest: BaseRequest {
    
    var cityId:Int?
    
    init(){
        super.init(requestType: RequestTypes.RequestTypeAreas)
    }
    
    override func requestURLString()->String!
    {
        return "public/cityWiseArea"
    }
    
    override func getRequestParameters()->Dictionary<String,AnyObject!>!
    {
        return Dictionary(dictionaryLiteral: ("cityId",cityId))
    }
}

class AreasResponse: BaseResponse {
    override var responseType:ResponseTypes {
        return ResponseTypes.ResponseTypeAreas
    }
    
    var areas = [Area]()
    
    override func setDataFromJSONResponse(response:JSON){
        if let areasArray = response.array {
            for areaJSON:JSON in areasArray {
                let area = Area(areaId: areaJSON["areaId"].intValue, areaName: areaJSON["areaName"].stringValue)
                area.cityId = areaJSON["cityId"].intValue
                areas.append(area)
            }
        }
    }
}

class Area {
    let areaId:Int
    let areaName:String
    var cityId:Int!
    
    
    init(areaId:Int, areaName:String){
        self.areaId=areaId
        self.areaName=areaName
    }
}