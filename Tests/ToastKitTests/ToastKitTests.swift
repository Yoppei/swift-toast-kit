import Testing
@testable import ToastKit

struct ToastKitTests {
    @Test func defaultDismissBehavior_usesDurationTapAndSwipeUp() {
        let behavior = ToastDismissBehavior.default

        #expect(behavior.tapEnabled == true)
        #expect(behavior.swipeDirections == [.up])
        #expect(behavior.duration == 3)
    }

    @Test func toastItem_hasVisibleContent_whenOnlyTitleOrMessageExists() {
        let titleOnly = ToastItem(title: "予定を追加しました", message: nil)
        let messageOnly = ToastItem(title: nil, message: "清水寺")
        let blankOnly = ToastItem(title: "  ", message: "\n")

        #expect(titleOnly.hasVisibleContent)
        #expect(messageOnly.hasVisibleContent)
        #expect(blankOnly.hasVisibleContent == false)
    }

    @Test func toastItem_toneDefaultsToNeutral() {
        let item = ToastItem(title: "Title", message: "Message")

        #expect(item.tone == .neutral)
    }

    @Test func configuration_storesSingleStyleAndHaptics() {
        let style = ToastStyle(backgroundColor: .red, foregroundColor: .white)
        let configuration = ToastConfiguration(
            style: style,
            haptics: .error
        )

        #expect(configuration.style.backgroundColor == style.backgroundColor)
        #expect(configuration.style.foregroundColor == style.foregroundColor)
        #expect(configuration.haptics == .error)
    }

    @Test func defaultConfiguration_respectsTopSafeAreaWithOffset() {
        let configuration = ToastConfiguration.default

        #expect(configuration.topOffset == 8)
        #expect(configuration.respectSafeAreaTop == true)
    }
}
