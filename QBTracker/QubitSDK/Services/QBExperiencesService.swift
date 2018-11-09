//
//  QBExperiencesService.swift
//  QubitSDK
//
//  Created by Andrzej Zuzak on 30/10/2018.
//  Copyright © 2018 Qubit. All rights reserved.
//

import Foundation

protocol QBExperiencesService {
    
    func getExperiences(forDeviceId id: String,
                        preview: Bool,
                        ignoreSegments: Bool,
                        variation: Int?,
                        then: ((Result<QBExperiencesEntity>) -> Void)?)
}

class QBExperiencesServiceImp: QBExperiencesService {
    
    private let configurationManager: QBConfigurationManager
    private lazy var apiClient: QBAPIClient = {
        return QBAPIClient()
    }()
    
    init(withConfigurationManager configurationManager: QBConfigurationManager) {
        self.configurationManager = configurationManager
    }
    
    func getExperiences(forDeviceId id: String,
                        preview: Bool,
                        ignoreSegments: Bool,
                        variation: Int?,
                        then: ((Result<QBExperiencesEntity>) -> Void)?) {
        var queryParams: [String: Any?] = [
            Constants.contextIdParam: id,
        ]
        
        if preview {
            queryParams[Constants.previewParam] = preview
        }
        
        if ignoreSegments {
            queryParams[Constants.ignoreSegmentsParam] = ignoreSegments
        }
        
        if let variation = variation {
            queryParams[Constants.variationParam] = variation
        }
        
        let pathComponents = [
            Constants.experiencesApiVersion,
            configurationManager.trackingId,
            Constants.experiencesEndpoint
        ]
        
        guard let url = configurationManager.configuration.experienceEndpointUrl()?
            .appending(pathComponents: pathComponents)?
            .appending(queryParams: queryParams) else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL for experiences is nil"]) as Error
                QBLog.error("URL for experiences is nil")
                then?(.failure(error))
                assert(false, "URL for experiences is nil")
                return
        }
        
        let request = URLRequest(url: url)
        apiClient.makeRequestAndDeserialize(request, withMethod: HTTPMethod.get, then: then)
    }
}

// MARK: - URL

extension URL {
    
    func appending(pathComponents: [String]) -> URL? {
        var url = self
        
        for component in pathComponents {
            url.appendPathComponent(component)
        }
        
        return url
    }
    
    func appending(queryParams: [String: Any?]) -> URL? {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)
        var queryItems = [URLQueryItem]()
        
        for (paramKey,paramValue) in queryParams {
            if let paramValue = paramValue {
                queryItems.append(URLQueryItem(name: paramKey, value: "\(paramValue)"))
            }
        }
        
        urlComponents?.queryItems = queryItems
        return urlComponents?.url
    }
}

// MARK: - Constants

extension QBExperiencesServiceImp {
    
    struct Constants {
        
        static let experiencesApiVersion = "v1"
        static let experiencesEndpoint = "experiences"
        static let contextIdParam = "contextId"
        static let previewParam = "preview"
        static let variationParam = "variation"
        static let ignoreSegmentsParam = "ignoreSegments"
    }
}
