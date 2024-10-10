//
//  PublicDataManager.swift
//  Touch2Buy
//
//  Created by Pradeep Kumara on 2/27/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import Foundation

class PublicDataManager: BaseDataManager {
    static let sharedInstance = PublicDataManager()
    private override init(){}
    
    private var paymentMethods = [PaymentMethod]()
    private var deliveryOptions = [DeliveryOption]()
    private var cities = [City]()
    private var countries = [Country]()
    
    func requestPaymentMethods() {
        let request = PaymentMethodsRequest()
       
        sendRequestObject(request)
    }
    
    func requestDeliveryOptions() {
        let request = DeliveryOptionsRequest()
        
        sendRequestObject(request)
    }
    
    func requestCities() {
        let request = CitiesRequest()
        
        sendRequestObject(request)
    }
    
    func requestAreas(cityid:Int?) {
        let request = AreasRequest()
        request.cityId = cityid
        sendRequestObject(request)
    }
    
    func requestCountries() {
        let request = CountriesRequest()
        
        sendRequestObject(request)
    }
    
    override func responseReceived(response:BaseResponse){
        if let paymentResponse = response as? PaymentMethodsResponse {
            paymentMethods = paymentResponse.paymentMethods
        }
        else if let deliveryResponse = response as? DeliveryOptionsResponse {
            deliveryOptions = deliveryResponse.deliveryOptions
        }
        else if let citiesResponse = response as? CitiesResponse {
            cities = citiesResponse.cities
        }
        else if let countriesResponse = response as? CountriesResponse {
            countries = countriesResponse.countries
        }
        super.responseReceived(response)
    }
    
    func getPaymentMethods()->[PaymentMethod]{
        return paymentMethods
    }
    
    func getDeliveryOptions()->[DeliveryOption]{
        return deliveryOptions
    }
    
    func getCities()->[City]{
        return cities
    }
    
    func getCountries()->[Country]{
        return countries
    }
    
    func getPaymentMethodByID(id:Int) -> PaymentMethod? {
        for item in paymentMethods {
            if item.id == id {
                return item
            }
        }
        return nil
    }
}