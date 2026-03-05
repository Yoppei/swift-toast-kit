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

    @Test func toneTheme_returnsPresentationForEachTone() {
        let neutral = ToastTonePresentation(
            style: ToastStyle(backgroundColor: .blue, foregroundColor: .white),
            haptics: nil
        )
        let success = ToastTonePresentation(
            style: ToastStyle(backgroundColor: .green, foregroundColor: .white),
            haptics: .success
        )
        let error = ToastTonePresentation(
            style: ToastStyle(backgroundColor: .red, foregroundColor: .white),
            haptics: .error
        )
        let theme = ToastToneTheme(
            neutral: neutral,
            success: success,
            error: error
        )

        #expect(theme[.neutral] == neutral)
        #expect(theme[.success] == success)
        #expect(theme[.error] == error)
    }

    @Test func configuration_presentationOverride_takesPrecedenceOverToneTheme() {
        let theme = ToastToneTheme(
            neutral: ToastTonePresentation(
                style: ToastStyle(backgroundColor: .blue, foregroundColor: .white),
                haptics: nil
            ),
            success: ToastTonePresentation(
                style: ToastStyle(backgroundColor: .green, foregroundColor: .white),
                haptics: .success
            ),
            error: ToastTonePresentation(
                style: ToastStyle(backgroundColor: .red, foregroundColor: .white),
                haptics: .error
            )
        )
        let override = ToastTonePresentation(
            style: ToastStyle(backgroundColor: .orange, foregroundColor: .black),
            haptics: .warning
        )
        let configuration = ToastConfiguration(
            toneTheme: theme,
            presentationOverride: override
        )

        #expect(configuration.presentationOverride == override)
        #expect(configuration.toneTheme[.success] != override)
    }

    @Test func defaultTheme_definesNeutralSuccessErrorExpectedly() {
        let theme = ToastToneTheme.default

        #expect(theme.neutral.haptics == nil)
        #expect(theme.success.haptics == .success)
        #expect(theme.error.haptics == .error)
    }

    @Test func haptics_isOptionalAndCanBeDisabledPerTone() {
        let theme = ToastToneTheme(
            neutral: ToastTonePresentation(style: .default, haptics: nil),
            success: ToastTonePresentation(style: .default, haptics: nil),
            error: ToastTonePresentation(style: .default, haptics: .error)
        )

        #expect(theme[.neutral].haptics == nil)
        #expect(theme[.success].haptics == nil)
        #expect(theme[.error].haptics == .error)
    }

    @Test func defaultConfiguration_respectsTopSafeAreaWithOffset() {
        let configuration = ToastConfiguration.default

        #expect(configuration.topOffset == 8)
        #expect(configuration.respectSafeAreaTop == true)
    }
}
