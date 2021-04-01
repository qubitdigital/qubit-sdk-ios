import Foundation

// swiftlint:disable function_parameter_count
protocol QBPlacementService {
    func getPlacement(with mode: String?,
                      placementId: String,
                      attributes: Attributes?,
                      campaignId: String?,
                      experienceId: String?,
                      resolveVisitorState: Bool,
                      then: ((Result<QBPlacementEntity>) -> Void)?)
}

class QBPlacementServiceImpl: QBPlacementService {
    private var configurationManager: QBConfigurationManager
    private lazy var apiClient: QBAPIClient = {
        return QBAPIClient()
    }()

    init(with configurationManager: QBConfigurationManager) {
        self.configurationManager = configurationManager
    }

    func getPlacement(with mode: String?,
                      placementId: String,
                      attributes: Attributes?,
                      campaignId: String?,
                      experienceId: String?,
                      resolveVisitorState: Bool,
                      then: ((Result<QBPlacementEntity>) -> Void)?) {
        guard let url = configurationManager.configuration.placementsEndpointUrl() else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL for placements is nil"]) as Error
            QBLog.error("URL for placements is nil")
            then?(.failure(error))
            assert(false, "URL for placements is nil")
            return
        }

        let timeoutInterval = TimeInterval(configurationManager.configuration.placementsApiTimeout)
        
        let query = QBPlacementsGraphQLQuery(with: url,
                                             timeoutInterval: timeoutInterval,
                                             placementId: placementId,
                                             mode: PlacementMode(rawValue: mode ?? "") ?? .live,
                                             attributes: attributes,
                                             previewOptions: PreviewOptions(campaignId: campaignId,
                                                                            experienceId: experienceId),
                                             resolveVisitorState: resolveVisitorState)
        apiClient.makeRequestAndDeserialize(query.request, withMethod: .post, then: then)
    }
}
// swiftlint:enable function_parameter_count
