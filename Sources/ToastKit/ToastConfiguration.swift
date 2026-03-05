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

public struct ToastStyle {
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

public struct ToastConfiguration {
    public var animation: Animation
    public var transition: AnyTransition
    public var dismiss: ToastDismissBehavior
    public var style: ToastStyle
    public var haptics: SensoryFeedback?
    public var topOffset: CGFloat
    public var respectSafeAreaTop: Bool

    public init(
        animation: Animation = .easeInOut(duration: 0.28),
        transition: AnyTransition = .move(edge: .top).combined(with: .opacity),
        dismiss: ToastDismissBehavior = .default,
        style: ToastStyle = .default,
        haptics: SensoryFeedback? = nil,
        topOffset: CGFloat = 8,
        respectSafeAreaTop: Bool = true
    ) {
        self.animation = animation
        self.transition = transition
        self.dismiss = dismiss
        self.style = style
        self.haptics = haptics
        self.topOffset = topOffset
        self.respectSafeAreaTop = respectSafeAreaTop
    }

    public static var `default`: ToastConfiguration {
        ToastConfiguration()
    }
}
