// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Assets {
    internal static let accentColor = ColorAsset(name: "AccentColor")
    internal static let categoryAll = ImageAsset(name: "CategoryAll")
    internal static let categoryBook = ImageAsset(name: "CategoryBook")
    internal static let categoryBookGray = ImageAsset(name: "CategoryBookGray")
    internal static let categoryBookRound = ImageAsset(name: "CategoryBookRound")
    internal static let categoryBookRoundSmall = ImageAsset(name: "CategoryBookRoundSmall")
    internal static let categoryConcert = ImageAsset(name: "CategoryConcert")
    internal static let categoryConcertGray = ImageAsset(name: "CategoryConcertGray")
    internal static let categoryConcertRound = ImageAsset(name: "CategoryConcertRound")
    internal static let categoryConcertRoundSmall = ImageAsset(name: "CategoryConcertRoundSmall")
    internal static let categoryDefault = ImageAsset(name: "CategoryDefault")
    internal static let categoryDrama = ImageAsset(name: "CategoryDrama")
    internal static let categoryDramaGray = ImageAsset(name: "CategoryDramaGray")
    internal static let categoryDramaRound = ImageAsset(name: "CategoryDramaRound")
    internal static let categoryDramaRoundSmall = ImageAsset(name: "CategoryDramaRoundSmall")
    internal static let categoryMovie = ImageAsset(name: "CategoryMovie")
    internal static let categoryMovieGray = ImageAsset(name: "CategoryMovieGray")
    internal static let categoryMovieRound = ImageAsset(name: "CategoryMovieRound")
    internal static let categoryMovieRoundSmall = ImageAsset(name: "CategoryMovieRoundSmall")
    internal static let floatingButton = ImageAsset(name: "FloatingButton")
    internal static let arrowRight = ImageAsset(name: "ArrowRight")
    internal static let back = ImageAsset(name: "Back")
    internal static let backWhite = ImageAsset(name: "BackWhite")
    internal static let doteRed = ImageAsset(name: "DoteRed")
    internal static let dropdown = ImageAsset(name: "Dropdown")
    internal static let imageDelete = ImageAsset(name: "ImageDelete")
    internal static let link = ImageAsset(name: "Link")
    internal static let my = ImageAsset(name: "My")
    internal static let option = ImageAsset(name: "Option")
    internal static let profile = ImageAsset(name: "Profile")
    internal static let setting = ImageAsset(name: "Setting")
    internal static let starFillLarge = ImageAsset(name: "StarFillLarge")
    internal static let starFillSmall = ImageAsset(name: "StarFillSmall")
    internal static let starLarge = ImageAsset(name: "StarLarge")
    internal static let starSmall = ImageAsset(name: "StarSmall")
    internal static let imageAdd = ImageAsset(name: "ImageAdd")
    internal static let imageEmpty = ImageAsset(name: "ImageEmpty")
    internal static let logo = ImageAsset(name: "Logo")
    internal static let logoGray = ImageAsset(name: "LogoGray")
    internal static let logoLogin = ImageAsset(name: "LogoLogin")
    internal static let logoTitle = ImageAsset(name: "LogoTitle")
    internal static let myProfile = ImageAsset(name: "MyProfile")
    internal static let onboardBack = ImageAsset(name: "OnboardBack")
    internal static let appleLogin = ImageAsset(name: "AppleLogin")
    internal static let googleLogin = ImageAsset(name: "GoogleLogin")
    internal static let kakaoLogin = ImageAsset(name: "kakaoLogin")
  }
  internal enum Color {
    internal static let black = ColorAsset(name: "Black")
    internal static let blue = ColorAsset(name: "Blue")
    internal static let gray1 = ColorAsset(name: "Gray1")
    internal static let gray2 = ColorAsset(name: "Gray2")
    internal static let gray3 = ColorAsset(name: "Gray3")
    internal static let main = ColorAsset(name: "Main")
    internal static let navy = ColorAsset(name: "Navy")
    internal static let red = ColorAsset(name: "Red")
    internal static let white = ColorAsset(name: "White")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
