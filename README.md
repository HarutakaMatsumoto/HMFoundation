# HMFoundation

Swift package HMFoundation provides some useful functions and classes for Swift programming.

## Prerequisites

- **[Swift](https://swift.org)**: **3.0+**.

## Installation

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.
Once you have your Swift package set up, you can append HMFoundation as a dependency easily.

First, append HMFoundation to the `dependencies` value of your `Package.swift` or the Package list in Xcode.

```swift
dependencies: [
    .package(url: "https://github.com/HarutakaMatsumoto/HMFoundation.git", .upToNextMajor(from: "1.0.1"))
]
```

Then, append `HMFoundation` to the targets of your package.

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["HMFoundation"]),
]
```

That is all! Now you can build your project.

## Contribution

You are very welcome to:

- Create pull requests of any kind
- Let me know if you are using this library and find it useful
- Open issues with request for support because they will help you and many others
