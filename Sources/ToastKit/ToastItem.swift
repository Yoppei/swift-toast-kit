import Foundation

public struct ToastItem: Identifiable, Equatable, Sendable {
    public enum Tone: Equatable, Sendable {
        case neutral
        case success
        case error
    }

    public let id: UUID
    public var title: String?
    public var message: String?
    public var tone: Tone

    public init(
        id: UUID = UUID(),
        title: String? = nil,
        message: String? = nil,
        tone: Tone = .neutral
    ) {
        self.id = id
        self.title = title
        self.message = message
        self.tone = tone
    }

    public var normalizedTitle: String? {
        Self.normalized(title)
    }

    public var normalizedMessage: String? {
        Self.normalized(message)
    }

    public var hasVisibleContent: Bool {
        normalizedTitle != nil || normalizedMessage != nil
    }

    private static func normalized(_ text: String?) -> String? {
        guard let trimmed = text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !trimmed.isEmpty
        else { return nil }
        return trimmed
    }
}
