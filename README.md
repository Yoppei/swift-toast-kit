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

```swift
import SwiftUI
import ToastKit

struct ContentView: View {
    @State private var toast: ToastItem?

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
            configuration: .default
        )
    }
}
```
