import SwiftUI

public enum ToastSwipeDirection: Hashable, Sendable {
    case up
    case down
    case left
    case right
}

public struct ToastDismissBehavior: Equatable, Sendable {
    public var tapEnabled: Bool
    public var swipeDirections: Set<ToastSwipeDirection>
    public var duration: TimeInterval?

    public init(
        tapEnabled: Bool = false,
        swipeDirections: Set<ToastSwipeDirection> = [],
        duration: TimeInterval? = 3
    ) {
        self.tapEnabled = tapEnabled
        self.swipeDirections = swipeDirections
        self.duration = duration
    }

    public static let `default` = ToastDismissBehavior(
        tapEnabled: true,
        swipeDirections: [.up],
        duration: 3
    )
}

public struct ToastStyle: Equatable, Sendable {
    public var backgroundColor: Color
    public var foregroundColor: Color

    public init(
        backgroundColor: Color = Color(.sRGB, red: 0.1, green: 0.1, blue: 0.12, opacity: 0.95),
        foregroundColor: Color = .white
    ) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }

    public static var `default`: ToastStyle {
        ToastStyle()
    }
}

public struct ToastTonePresentation: Equatable, Sendable {
    public var style: ToastStyle
    public var haptics: SensoryFeedback?

    public init(
        style: ToastStyle = .default,
        haptics: SensoryFeedback? = nil
    ) {
        self.style = style
        self.haptics = haptics
    }
}

public struct ToastToneTheme: Equatable, Sendable {
    public var neutral: ToastTonePresentation
    public var success: ToastTonePresentation
    public var error: ToastTonePresentation

    public init(
        neutral: ToastTonePresentation = ToastTonePresentation(
            style: .default,
            haptics: nil
        ),
        success: ToastTonePresentation = ToastTonePresentation(
            style: ToastStyle(
                backgroundColor: Color(.sRGB, red: 0.16, green: 0.52, blue: 0.27, opacity: 0.95),
                foregroundColor: .white
            ),
            haptics: .success
        ),
        error: ToastTonePresentation = ToastTonePresentation(
            style: ToastStyle(
                backgroundColor: Color(.sRGB, red: 0.72, green: 0.18, blue: 0.2, opacity: 0.95),
                foregroundColor: .white
            ),
            haptics: .error
        )
    ) {
        self.neutral = neutral
        self.success = success
        self.error = error
    }

    public subscript(_ tone: ToastItem.Tone) -> ToastTonePresentation {
        switch tone {
        case .neutral:
            neutral
        case .success:
            success
        case .error:
            error
        }
    }

    public static var `default`: ToastToneTheme {
        ToastToneTheme()
    }
}

public struct ToastConfiguration {
    public var animation: Animation
    public var transition: AnyTransition
    public var dismiss: ToastDismissBehavior
    public var toneTheme: ToastToneTheme
    public var presentationOverride: ToastTonePresentation?
    public var topOffset: CGFloat
    public var respectSafeAreaTop: Bool

    public init(
        animation: Animation = .easeInOut(duration: 0.28),
        transition: AnyTransition = .move(edge: .top).combined(with: .opacity),
        dismiss: ToastDismissBehavior = .default,
        toneTheme: ToastToneTheme = .default,
        presentationOverride: ToastTonePresentation? = nil,
        topOffset: CGFloat = 8,
        respectSafeAreaTop: Bool = true
    ) {
        self.animation = animation
        self.transition = transition
        self.dismiss = dismiss
        self.toneTheme = toneTheme
        self.presentationOverride = presentationOverride
        self.topOffset = topOffset
        self.respectSafeAreaTop = respectSafeAreaTop
    }

    public static var `default`: ToastConfiguration {
        ToastConfiguration()
    }
}
