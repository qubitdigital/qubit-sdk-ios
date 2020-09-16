import Foundation

enum QBPlacementFields: String {
    case data
    case placementContent
    case content
    case callbacks

    enum Callbacks: String {
        case impression
        case clickthrough
    }
}

public final class QBPlacementEntity: NSObject, NSCoding, DictionaryInitializable {

    @objc(Content)
    public var content: [String: Any]?
    public var impressionUrl: String?
    public var clickthroughUrl: String?

    public func encode(with coder: NSCoder) {
        coder.encode(content, forKey: Keys.content)
        coder.encode(clickthroughUrl, forKey: Keys.clickthroughUrl)
        coder.encode(impressionUrl, forKey: Keys.impressionUrl)
    }

    public init?(coder: NSCoder) {
        self.content = coder.decodeObject(forKey: Keys.content) as? [String: Any]
        self.clickthroughUrl = coder.decodeObject(forKey: Keys.clickthroughUrl) as? String
        self.impressionUrl = coder.decodeObject(forKey: Keys.impressionUrl) as? String
    }

    public init(with content: [String: Any]? = nil, clickthroughUrl: String? = nil, impressionUrl: String? = nil) {
        self.content = content
        self.impressionUrl = impressionUrl
        self.clickthroughUrl = clickthroughUrl
    }

    public init(withDict dict: [String: Any]) throws {
        guard let data = dict[QBPlacementFields.data.rawValue] as? [String: Any] else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data in placement dictionary"]) as Error
        }

        self.content = (data[QBPlacementFields.placementContent.rawValue] as? [String: Any])?[QBPlacementFields.content.rawValue] as? [String: Any]

        let callbacks = (data[QBPlacementFields.placementContent.rawValue] as? [String: Any])?[QBPlacementFields.callbacks.rawValue] as? [String: Any]

        self.impressionUrl = callbacks?[QBPlacementFields.Callbacks.impression.rawValue] as? String
        self.clickthroughUrl = callbacks?[QBPlacementFields.Callbacks.clickthrough.rawValue] as? String
    }

    @objc(clickthrough)
    public func clickthrough() {
        guard let clickthroughUrl = clickthroughUrl else {
            QBLog.warning("No clickthrough URL in \(#function)")
            return
        }
        QBPlacementCallbackManager.shared.call(clickthroughUrl)
    }

    @objc(impression)
    public func impression() {
        guard let impressionUrl = impressionUrl else {
            QBLog.warning("No impression URL in \(#function)")
            return
        }
        QBPlacementCallbackManager.shared.call(impressionUrl)
    }

}

private struct Keys {
    static let clickthroughUrl = "clickthroughUrl"
    static let impressionUrl = "impressionUrl"
    static let content = "content"
}

// MARK: - Abstraction over QBPlacementEntity
// This is used basically to run clickthrough() and impression() callback, having only the urls.
// The rest of fields are obsolete in this case and can be placeholders.
final public class QBPlacementEntityCallback {
    private var placement: QBPlacementEntity

    public init(clickthroughUrl: String? = nil, impressionUrl: String? = nil) {
        self.placement = QBPlacementEntity(clickthroughUrl: clickthroughUrl, impressionUrl: impressionUrl)
    }

    @objc(clickthrough)
    public func clickthrough() {
        placement.clickthrough()
    }

    @objc(impression)
    public func impression() {
        placement.impression()
    }
}
