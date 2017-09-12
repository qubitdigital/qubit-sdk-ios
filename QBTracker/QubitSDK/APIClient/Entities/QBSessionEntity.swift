//
//  QBSessionEntity.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 11/09/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

struct QBSessionEntity: Codable {
    let firstViewTs: Int?
    let lastViewTs: Int?
    let firstConversionTs: Int?
    let lastConversionTs: Int?
    
    let ipLocation: QBLocationIpEntity?
    let ipAddress: String?
    
    let deviceType: String?
    let deviceName: String?
    let osName: String?
    let osVersion: String?
    let appType: String?
    let appName: String?
    let appVersion: String?
    let screenWidth: Int?
    let screenHeight: Int?
    
    func fillQBSessionEvent(session: inout QBSessionEvent) -> QBSessionEvent {
        session.firstViewTs = firstViewTs?.optionalNumber
        session.lastViewTs = lastViewTs?.optionalNumber
        session.firstConversionTs = firstConversionTs?.optionalNumber
        session.lastConversionTs = lastConversionTs?.optionalNumber
        
        if let ipLocation = self.ipLocation {
            session.ipLocationCity = ipLocation.city
            session.ipLocationCityCode = ipLocation.cityCode
            session.ipLocationCountry = ipLocation.country
            session.ipLocationCountryCode = ipLocation.countryCode
            session.ipLocationRegion = ipLocation.region
            session.ipLocationRegionCode = ipLocation.regionCode
            session.ipLocationArea = ipLocation.area
            session.ipLocationAreaCode = ipLocation.areaCode
            session.ipLocationCity = ipLocation.city
            session.ipLocationCityCode = ipLocation.cityCode
            session.ipLocationLongitude = ipLocation.longitude?.optionalNumber
            session.ipLocationLatitude = ipLocation.latitude?.optionalNumber
        }

        session.ipAddress = self.ipAddress
        session.deviceType = self.deviceType
        session.deviceName = self.deviceName
        session.osName = self.osName
        session.osVersion = self.osVersion
        session.appType = self.appType
        session.appName = self.appName
        session.appVersion = self.appVersion
        session.screenWidth = self.screenWidth?.optionalNumber
        session.screenHeight = self.screenHeight?.optionalNumber
        
        return session
    }
    
    static func create(with session: QBSessionEvent?) -> QBSessionEntity? {
        guard let session = session else {
            return nil
        }
        
        let locationIp = QBLocationIpEntity(city: session.ipLocationCity,
                                            cityCode: session.ipLocationCityCode,
                                            country: session.ipLocationCountry,
                                            countryCode: session.ipLocationCountryCode,
                                            latitude: session.ipLocationLatitude?.doubleValue,
                                            longitude: session.ipLocationLongitude?.doubleValue,
                                            area: session.ipLocationArea,
                                            areaCode: session.ipLocationAreaCode,
                                            region: session.ipLocationRegion,
                                            regionCode: session.ipLocationRegionCode)
        
        let sessionEntity = QBSessionEntity(firstViewTs: session.firstViewTs?.intValue,
                                            lastViewTs: session.lastViewTs?.intValue,
                                            firstConversionTs: session.firstConversionTs?.intValue,
                                            lastConversionTs: session.lastConversionTs?.intValue,
                                            ipLocation: locationIp,
                                            ipAddress: session.ipAddress,
                                            deviceType: session.deviceType,
                                            deviceName: session.deviceName,
                                            osName: session.osName,
                                            osVersion: session.osVersion,
                                            appType: session.appType,
                                            appName: session.appName,
                                            appVersion: session.appVersion,
                                            screenWidth: session.screenWidth?.intValue,
                                            screenHeight: session.screenHeight?.intValue)
        return sessionEntity
    }
}
