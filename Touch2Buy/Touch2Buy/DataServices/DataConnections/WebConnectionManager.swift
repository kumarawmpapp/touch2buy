//
//  WebConnectionManager.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 11/16/15.
//  Copyright © 2015 TouchBuy. All rights reserved.
//

import Foundation
import SwiftyJSON

class WebConnectionManager {
    
    //http://54.169.4.162:8080/api/swagger
    
    
    //http://54.169.4.162:3001/home
    
    //http://54.169.4.162:3000/
    
    //apple account: ravin.attanayake@gmail.com
    //password: Mut@nt$123
    
    //Github account : kumarawmpapp@gmail.com
    //password : mutants456
    
//    private let baseURL:String = "http://54.169.4.162:8080/api/"
    private let baseURL:String = "https://mobile.touch2buy.xyz/api/"  // Production
    
    func sendRequest(reqObject:BaseRequest, reqManager:BaseDataManager){
        
        let urlString = baseURL + reqObject.requestURLString()
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        
        if let dicData = reqObject.getRequestParameters(){
            do {
                let parametersData = try NSJSONSerialization.dataWithJSONObject(dicData, options: .PrettyPrinted)
                request.HTTPBody = parametersData
            } catch let error as NSError {
                AppDebugPrint(error.localizedDescription)
                
            }
        }
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if let mobileVersionHTTPParameter = reqObject.mobileVersion {
            request.addValue(mobileVersionHTTPParameter, forHTTPHeaderField: "mobileVersion")
        }
        if let userNameHTTPParameter = reqObject.userName {
            request.addValue(userNameHTTPParameter, forHTTPHeaderField: "userName")
        }
        
        request.cachePolicy = .ReloadIgnoringLocalAndRemoteCacheData
        
        let session = NSURLSession.sharedSession()
        session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            dispatch_async(dispatch_queue_create("RESPONSE_QUEUE", DISPATCH_QUEUE_CONCURRENT)) { () -> Void in
                
                var responseObject:BaseResponse?
                
                if (error != nil) {
                    AppDebugPrint(error)
                    responseObject = BaseResponse()
                }else{
                    if let jsonresponse:JSON = JSON(data: data!) {
                        AppDebugPrint(reqObject.printDebugURLParams())
                        AppDebugPrint(jsonresponse)
                        switch reqObject.requestType {
                            
                        case .RequestTypeLoginUser:
                            responseObject = UserLoginResponse()
                            break
                        case .RequestTypeCreateUser:
                            responseObject = CreateUserResponse()
                            break
                        case .RequestTypeOrganizationAll:
                            responseObject = AllOrganizationsResponse()
                            break
                        case .RequestTypeOrganizationItems:
                            responseObject = OrganizationItemsResponse()
                            break
                        case .RequestTypeOrganizationBranches:
                            responseObject = OrganizationBranchesResponse()
                            break
                        case .RequestTypeOrderNew:
                            responseObject = OrderResponse()
                        case .RequestTypeOrderConfirmCancel:
                            break
                        case .RequestTypeOrderList:
                            responseObject = OrderListResponse()
                            break
                        case .RequestTypePaymentMethods:
                            responseObject = PaymentMethodsResponse()
                            break
                        case .RequestTypeChannelPayMethods:
                            responseObject = AvailableChannelPayMethodsResponse()
                            break
                        case .RequestTypeDeliveryOptions:
                            responseObject = DeliveryOptionsResponse()
                            break
                        case .RequestTypeCities:
                            responseObject = CitiesResponse()
                            break
                        case .RequestTypeCountries:
                            responseObject = CountriesResponse()
                            break
                        case .RequestTypeVerifyOTP:
                            responseObject = VerifyOTPResponse()
                            break
                        case .RequestTypeResendOTP:
                            responseObject = ResendOTPResponse()
                            break
                        case .RequestTypeSaveAddress:
                            responseObject = SaveAddressResponse()
                            break
                        case .RequestTypeDeliveryCharge:
                            responseObject = DeliveryChargeResponse()
                            break
                        case .RequestTypeOrganizationItemsCategories:
                            responseObject = OrganizationItemsCategoriesResponse()
                            break
                        case .RequestTypeOrganizationItemsByPublishedCategories:
                            responseObject = OrganizationItemsByPublishedCategoriesResponse()
                            break
                        case .RequestTypeAreas:
                            responseObject = AreasResponse()
                            break
                        default :
                            AppDebugPrint("No response type")
                        }
                        responseObject?.message = jsonresponse["message"].string
                        responseObject?.code = jsonresponse["code"].int
                        responseObject?.setDataFromJSONResponse(jsonresponse)
                    }
                }
                
                responseObject?.requestObject=reqObject;
                responseObject?.responseData=data;
                responseObject?.urlResponse=response;
                responseObject?.errorResponse=error;
                
                if (responseObject != nil) {
                    reqManager.responseReceived(responseObject!)
                }
                
            }
            
        }.resume()
        
    }
}