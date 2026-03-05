import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public struct ToastModifier: ViewModifier {
    @Binding var item: ToastItem?
    let configuration: ToastConfiguration

    private let swipeThreshold: CGFloat = 44

    public init(
        item: Binding<ToastItem?>,
        configuration: ToastConfiguration = .default
    ) {
        self._item = item
        self.configuration = configuration
    }

    public func body(content: Content) -> some View {
        let presentedItem = normalized(item)
        let hapticsTrigger = presentedItem.map { HapticsTrigger(id: $0.id, tone: $0.tone) }
        let resolvedHaptics = configuration.haptics
        let feedback = resolvedHaptics ?? .success

        let baseView = content
            .overlay {
                GeometryReader { proxy in
                    ZStack(alignment: .top) {
                        if let presentedItem {
                            ToastCapsuleView(
                                item: presentedItem,
                                style: configuration.style
                            )
                                .padding(.top, topPadding(safeAreaTop: proxy.safeAreaInsets.top))
                                .padding(.horizontal, 16)
                                .transition(configuration.transition)
                                .onTapGesture {
                                    guard configuration.dismiss.tapEnabled else { return }
                                    dismiss()
                                }
                                .simultaneousGesture(
                                    DragGesture(minimumDistance: 10)
                                        .onEnded { value in
                                            handleSwipe(translation: value.translation)
                                        }
                                )
                                .task(id: presentedItem.id) {
                                    await runAutoDismissTask(for: presentedItem.id)
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
                .ignoresSafeArea(edges: .top)
            }
            .animation(configuration.animation, value: presentedItem?.id)

        return baseView.sensoryFeedback(
            feedback,
            trigger: hapticsTrigger
        ) { _, newValue in
            newValue != nil && resolvedHaptics != nil
        }
    }

    private func normalized(_ item: ToastItem?) -> ToastItem? {
        guard let item, item.hasVisibleContent else { return nil }
        return item
    }

    @MainActor
    private func dismiss() {
        guard item != nil else { return }
        item = nil
    }

    private func handleSwipe(translation: CGSize) {
        guard let direction = toastSwipeDirection(from: translation),
              configuration.dismiss.swipeDirections.contains(direction)
        else { return }
        dismiss()
    }

    private func toastSwipeDirection(from translation: CGSize) -> ToastSwipeDirection? {
        if abs(translation.width) > abs(translation.height) {
            guard abs(translation.width) >= swipeThreshold else { return nil }
            return translation.width > 0 ? .right : .left
        }

        guard abs(translation.height) >= swipeThreshold else { return nil }
        return translation.height > 0 ? .down : .up
    }

    private func topPadding(safeAreaTop: CGFloat) -> CGFloat {
        configuration.topOffset + (configuration.respectSafeAreaTop ? globalSafeAreaTop(fallback: safeAreaTop) : 0)
    }

    private func globalSafeAreaTop(fallback: CGFloat) -> CGFloat {
        #if canImport(UIKit)
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        let keyWindow = scenes.flatMap(\.windows).first { $0.isKeyWindow }
        return keyWindow?.safeAreaInsets.top ?? fallback
        #else
        return fallback
        #endif
    }

    private func runAutoDismissTask(for id: UUID) async {
        guard let duration = configuration.dismiss.duration,
              duration > 0
        else { return }

        let nanoseconds = UInt64(duration * 1_000_000_000)
        try? await Task.sleep(nanoseconds: nanoseconds)

        await MainActor.run {
            guard item?.id == id else { return }
            dismiss()
        }
    }
}

private struct HapticsTrigger: Equatable {
    let id: UUID
    let tone: ToastItem.Tone
}

private struct ToastCapsuleView: View {
    let item: ToastItem
    let style: ToastStyle

    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            if let title = item.normalizedTitle {
                Text(title)
                    .font(.subheadline.bold())
                    .lineLimit(1)
            }
            if let message = item.normalizedMessage {
                Text(message)
                    .font(.footnote)
                    .lineLimit(1)
            }
        }
        .foregroundStyle(style.foregroundColor)
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(style.backgroundColor, in: Capsule())
    }
}
