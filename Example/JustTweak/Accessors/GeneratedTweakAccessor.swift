//
//  GeneratedTweakAccessor.swift
//  Generated by TweakAccessorGenerator
//

import Foundation
import JustTweak

class GeneratedTweakAccessor {

    static let tweakManager: TweakManager = {
        var tweakProviders: [TweakProvider] = []

        // EphemeralTweakProvider
        #if DEBUG || CONFIGURATION_UI_TESTS
        let ephemeralTweakProvider_1 = NSMutableDictionary()
        tweakProviders.append(ephemeralTweakProvider_1)
        #endif

        // UserDefaultsTweakProvider
        #if DEBUG || CONFIGURATION_DEBUG
        let userDefaultsTweakProvider_1 = UserDefaultsTweakProvider(userDefaults: UserDefaults.standard)
        tweakProviders.append(userDefaultsTweakProvider_1)
        #endif

        // LocalTweakProvider
        #if DEBUG
        let jsonFileURL_1 = Bundle.main.url(forResource: "LocalTweaks_TopPriority_example", withExtension: "json")!
        let localTweakProvider_1 = LocalTweakProvider(jsonURL: jsonFileURL_1)
        tweakProviders.append(localTweakProvider_1)
        #endif

        // LocalTweakProvider
        let jsonFileURL_2 = Bundle.main.url(forResource: "LocalTweaks_example", withExtension: "json")!
        let localTweakProvider_2 = LocalTweakProvider(jsonURL: jsonFileURL_2)
        tweakProviders.append(localTweakProvider_2)

        let tweakManager = TweakManager(tweakProviders: tweakProviders)
        tweakManager.useCache = true
        return tweakManager
    }()

    var tweakManager: TweakManager {
        return Self.tweakManager
    }

    @OptionalTweakProperty(fallbackValue: nil,
                           feature: Features.general,
                           variable: Variables.answerToTheUniverse,
                           tweakManager: tweakManager)
    var meaningOfLife: Int?

    @TweakProperty(feature: Features.general,
                   variable: Variables.greetOnAppDidBecomeActive,
                   tweakManager: tweakManager)
    var shouldShowAlert: Bool

    @TweakProperty(feature: Features.general,
                   variable: Variables.tapToChangeColorEnabled,
                   tweakManager: tweakManager)
    var isTapGestureToChangeColorEnabled: Bool

    @TweakProperty(feature: Features.uiCustomization,
                   variable: Variables.displayGreenView,
                   tweakManager: tweakManager)
    var canShowGreenView: Bool

    @TweakProperty(feature: Features.uiCustomization,
                   variable: Variables.displayRedView,
                   tweakManager: tweakManager)
    var canShowRedView: Bool

    @TweakProperty(feature: Features.uiCustomization,
                   variable: Variables.displayYellowView,
                   tweakManager: tweakManager)
    var canShowYellowView: Bool

    @TweakProperty(feature: Features.uiCustomization,
                   variable: Variables.labelText,
                   tweakManager: tweakManager)
    var labelText: String

    @TweakProperty(feature: Features.uiCustomization,
                   variable: Variables.redViewAlphaComponent,
                   tweakManager: tweakManager)
    var redViewAlpha: Double
}