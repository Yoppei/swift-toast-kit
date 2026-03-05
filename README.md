# ToastKit

A lightweight SwiftUI toast component for iOS and macOS.

## Requirements

- Swift 6.2+
- iOS 18+
- macOS 14+

## Installation

Add ToastKit to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/Yoppei/swift-toast-kit", .upToNextMajor(from: "1.0.0"))
]
```

Then add the product to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "ToastKit", package: "swift-toast-kit")
    ]
)
```

## Usage

`ToastItem.tone` now drives both visual style and haptics through `ToastToneTheme`.

```swift
import SwiftUI
import ToastKit

struct ContentView: View {
    @State private var toast: ToastItem?
    private let configuration = ToastConfiguration(
        toneTheme: ToastToneTheme(
            neutral: ToastTonePresentation(
                style: ToastStyle(
                    backgroundColor: Color(.sRGB, red: 0.1, green: 0.1, blue: 0.12, opacity: 0.95),
                    foregroundColor: .white
                ),
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
    )

    var body: some View {
        VStack {
            Button("Show Toast") {
                toast = ToastItem(
                    title: "Saved",
                    message: "Your changes have been saved.",
                    tone: .success
                )
            }
        }
        .toast(
            item: $toast,
            configuration: configuration
        )
    }
}
```

### Force Override All Toast Presentations

Use `presentationOverride` to force a single style/haptics combination regardless of `tone`:

```swift
let configuration = ToastConfiguration(
    presentationOverride: ToastTonePresentation(
        style: ToastStyle(backgroundColor: .black, foregroundColor: .white),
        haptics: .error
    )
)
```
