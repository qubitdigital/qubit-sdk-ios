//
//  ConfigurationService.swift
//  QBTracker
//
//  Created by Pavlo Davydiuk on 21/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

protocol QBConfigurationRepository {
    func getConfigution(forId id: String, completion: ((Result<QBConfigurationEntity>) -> ())?)
}

protocol QBConfigurationService {
    func getConfigution(forId id: String, completion: ((Result<QBConfigurationEntity>) -> ())?)
}

class QBConfigurationServiceImp: QBConfigurationService {
    fileprivate let repository: QBConfigurationRepository
    
    init(repository: QBConfigurationRepository) {
        self.repository = repository
    }
    
    func getConfigution(forId id: String, completion: ((Result<QBConfigurationEntity>) -> ())?) {
        repository.getConfigution(forId: id, completion: completion)
    }
}

let defaultConfigurationService: QBConfigurationService = QBConfigurationServiceImp(
    repository: QBConfigurationRepositoryImp()
)
