import Foundation

// swiftlint:disable all
class QBPlacementManager {
    var cachedPlacements: [String: QBPlacementEntity] {
        get {
            UserDefaults.standard.lastSavedPlacements
        }

        set {
            UserDefaults.standard.lastSavedPlacements = newValue
        }
    }

    private var placementService: QBPlacementService
    private var configurationManager: QBConfigurationManager
    private var reachability = QBReachability()
    private var eventManager: QBEventManager?

    init(configurationManager: QBConfigurationManager, eventManager: QBEventManager?) {
        self.configurationManager = configurationManager
        self.placementService = QBPlacementServiceImpl(with: self.configurationManager)
        self.eventManager = eventManager
        try? reachability?.startNotifier()
    }

    func getPlacement(with mode: String?,
                      placementId: String,
                      attributes: [String: Any]?,
                      campaignId: String?,
                      experienceId: String?,
                      resolveVisitorState: Bool,
                      completion: @escaping (QBPlacementEntity?, Error?) -> Void) {
        QBLog.mark()

        guard configurationManager.isConfigurationLoaded else {
            QBLog.info("Configuration is loading, so placements will be loaded afterwards")
            return
        }

        var attributesToSearch = attributes ?? [:]
        addVisitorAttributes(to: &attributesToSearch)
        addViewAttribute(to: &attributesToSearch)
        addUserAttributes(to: &attributesToSearch)

        if reachability?.isReachable == false {
            let placement = checkCache(for: mode,
                                       placementId: placementId,
                                       attributes: attributesToSearch,
                                       campaignId: campaignId,
                                       experienceId: experienceId) ??
                                        QBPlacementEntity(with: [:], clickthroughUrl: nil, impressionUrl: nil)
            completion(placement, nil)
            return
        }

        placementService.getPlacement(with: mode,
                                      placementId: placementId,
                                      attributes: attributesToSearch,
                                      campaignId: campaignId,
                                      experienceId: experienceId,
                                      resolveVisitorState: resolveVisitorState) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let placement):
                self.addToCache(placement, mode: mode, placementId: placementId, attributes: attributesToSearch, campaignId: campaignId, experienceId: experienceId)
                completion(placement, nil)
            case .failure(let error):
                QBLog.error("error = \(error)")
                let placement = self.checkCache(for: mode,
                                                placementId: placementId,
                                                attributes: attributesToSearch,
                                                campaignId: campaignId,
                                                experienceId: experienceId) ??
                                                QBPlacementEntity(with: [:], clickthroughUrl: nil, impressionUrl: nil)
                completion(placement, nil)
            }
        }
    }
}

extension QBPlacementManager {
    func addToCache(_ placement: QBPlacementEntity,
                    mode: String?,
                    placementId: String,
                    attributes: Attributes?,
                    campaignId: String?,
                    experienceId: String?) {
        let key = keyFrom(mode: mode, placementId: placementId, attributes: attributes, campaignId: campaignId, experienceId: experienceId)

        cachedPlacements[key] = placement
    }

    func checkCache(for mode: String?,
                    placementId: String,
                    attributes: Attributes?,
                    campaignId: String?,
                    experienceId: String?) -> QBPlacementEntity? {
        let key = keyFrom(mode: mode,
                          placementId: placementId,
                          attributes: attributes,
                          campaignId: campaignId,
                          experienceId: experienceId)
        return cachedPlacements[key]
    }

    func keyFrom(mode: String?,
                 placementId: String,
                 attributes: Attributes?,
                 campaignId: String?,
                 experienceId: String?) -> String {
        var key = placementId
        let mode = PlacementMode(rawValue: mode ?? "") ?? .live

        key.append(mode.rawValue)

        if let campaignId = campaignId {
            key.append(campaignId)
        }

        if let experienceId = experienceId {
            key.append(experienceId)
        }

        if let attributes = attributes {
            key.append(attributes.description)
        }

        return key
    }

    func addViewAttribute(to attributes: inout [String: Any]) {
        guard attributes[ViewKeys.view] == nil else {
            return
        }

        let lastViewEvent = eventManager?.lastEvent(of: LastEventType.view.rawValue)
        let view: [String: Any] = [ViewKeys.currency: lastViewEvent?.value(for: ViewKeys.currency) ?? "",
                    ViewKeys.type: lastViewEvent?.value(for: ViewKeys.type) ?? "",
                    ViewKeys.subTypes: lastViewEvent?.value(for: ViewKeys.subTypes) ?? [],
                    ViewKeys.language: lastViewEvent?.value(for: ViewKeys.language) ?? ""]

        attributes[ViewKeys.view] = view
    }

    func addUserAttributes(to attributes: inout [String: Any]) {
        guard attributes[UserKeys.user] == nil else {
            return
        }

        let lastUserEvent = eventManager?.lastEvent(of: LastEventType.user.rawValue)
        let user: [String: Any] = [UserKeys.id: lastUserEvent?.value(for: UserKeys.id) ?? "",
                                   UserKeys.email: lastUserEvent?.value(for: UserKeys.email) ?? ""]

        attributes[UserKeys.user] = user
    }

    func addVisitorAttributes(to attributes: inout [String: Any]) {
        let visitor = [VisitorKeys.id: QubitSDK.deviceId]

        attributes[VisitorKeys.visitor] = visitor
    }

    struct ViewKeys {
        static var view = "view"
        static var currency = "currency"
        static var type = "type"
        static var subTypes = "subtypes"
        static var language = "language"
    }

    struct UserKeys {
        static var user = "user"
        static var id = "id"
        static var email = "email"
    }

    struct VisitorKeys {
        static var visitor = "visitor"
        static var id = "id"
        static var url = "url"
        static var userAgentString = "userAgentString"
    }
}

// swiftlint:enable all
