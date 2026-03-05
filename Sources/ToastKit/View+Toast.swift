import SwiftUI

public extension View {
    func toast(
        item: Binding<ToastItem?>,
        configuration: ToastConfiguration = .default
    ) -> some View {
        modifier(ToastModifier(item: item, configuration: configuration))
    }
}
