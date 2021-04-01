import Foundation

public enum PlacementMode: String {
    case live = "LIVE"
    case sample = "SAMPLE"
    case preview = "PREVIEW"
}

typealias Attributes = [String: Any]

struct PreviewOptions {
    var campaignId: String?
    var experienceId: String?

    var stringValue: String {
        var string = ""

        guard campaignId != nil || experienceId != nil else {
            return "{}"
        }

        string.append("{")
        if let campaignId = campaignId {
            string.append("\"campaignId\": \"\(campaignId)\"")
        }
        if let experienceId = experienceId {
            if campaignId != nil {
                string.append(",")
            }
            string.append("\"experienceId\": \"\(experienceId)\"")
        }
        string.append(" }")

        return string
    }
}

class QBPlacementsGraphQLQuery: QBGraphQLQuery {
    override var body: String {
        let query = "{ \"query\": \"query PlacementContent($mode: Mode!,  $placementId: String!, $previewOptions: PreviewOptions, $attributes: Attributes!, $resolveVisitorState: Boolean!) { placementContent(mode: $mode, placementId: $placementId, previewOptions: $previewOptions,    attributes: $attributes, resolveVisitorState: $resolveVisitorState) {   content callbacks { impression clickthrough } } }\", \"variables\": {\"attributes\": \(attributes?.jsonString ?? "{}"), \"mode\": \"\(mode.rawValue)\",\"placementId\": \"\(placementId)\", \"previewOptions\": \(previewOptions?.stringValue ?? "{}"), \"resolveVisitorState\": \(resolveVisitorState) } }"
        return query
    }

    private var placementId: String
    private var mode: PlacementMode
    private var attributes: Attributes?
    private var previewOptions: PreviewOptions?
    private var resolveVisitorState: Bool

    init(with url: URL,
         timeoutInterval: TimeInterval,
         additionalHeaders: QBGraphQLQuery.HTTPHeaders = HTTPHeaders(),
         placementId: String,
         mode: PlacementMode? = nil,
         attributes: Attributes?,
         previewOptions: PreviewOptions?,
         resolveVisitorState: Bool = true
         ) {
        self.placementId = placementId
        self.mode = mode ?? .live
        self.attributes = attributes
        self.previewOptions = previewOptions
        self.resolveVisitorState = resolveVisitorState

        super.init(with: url,
                   timeoutInterval: timeoutInterval,
                   additionalHeaders: additionalHeaders)
    }
}
