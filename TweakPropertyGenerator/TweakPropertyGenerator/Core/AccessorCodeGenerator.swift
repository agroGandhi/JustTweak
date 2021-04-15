//
//  AccessorCodeGenerator.swift
//  Copyright © 2021 Just Eat Takeaway. All rights reserved.
//

import Foundation

class AccessorCodeGenerator {
    
    private let featuresConst = "Features"
    private let variablesConst = "Variables"
    
    private let featureConstantsConst = "<FEATURE_CONSTANTS_CONST>"
    private let variableConstantsConst = "<VARIABLE_CONSTANTS_CONST>"
    private let classContentConst = "<CLASS_CONTENT>"
    private let tweakManagerConst = "<TWEAK_MANAGER_CONTENT>"
    
    func generate(localConfigurationFilename: String, className: String, localConfigurationContent: Configuration) -> String {
        let template = self.template(className: className)
        
        let featureConstants = self.featureConstants(localConfigurationContent: localConfigurationContent)
        let variableConstants = self.variableConstants(localConfigurationContent: localConfigurationContent)
        let tweakManager = self.tweakManager(localConfigurationFilename: localConfigurationFilename)
        let classContent = self.classContent(localConfigurationContent: localConfigurationContent)
        
        let content = template
            .replacingOccurrences(of: featureConstantsConst, with: featureConstants)
            .replacingOccurrences(of: variableConstantsConst, with: variableConstants)
            .replacingOccurrences(of: tweakManagerConst, with: tweakManager)
            .replacingOccurrences(of: classContentConst, with: classContent)
        
        return content
    }
}

extension AccessorCodeGenerator {
    
    private func template(className: String) -> String {
        """
        //
        //  \(className).swift
        //  Generated by TweakPropertyGenerator
        //
        
        import Foundation
        import JustTweak
        
        class \(className) {
        
        \(featureConstantsConst)
        
        \(variableConstantsConst)
        
        \(tweakManagerConst)
        
        \(classContentConst)
        }
        """
    }
    
    private func featureConstants(localConfigurationContent: Configuration) -> String {
        var features = Set<FeatureKey>()
        for tweak in localConfigurationContent.tweaks {
            features.insert(tweak.feature)
        }
        let content: [String] = features.map {
            """
                    static let \($0.camelCased()) = "\($0)"
            """
        }
        return """
            struct \(featuresConst) {
        \(Array(content).sorted().joined(separator: "\n"))
            }
        """
    }
    
    private func variableConstants(localConfigurationContent: Configuration) -> String {
        var variables = Set<VariableKey>()
        for tweak in localConfigurationContent.tweaks {
            variables.insert(tweak.variable)
        }
        let content: [String] = variables.map {
            """
                    static let \($0.camelCased()) = "\($0)"
            """
        }
        return """
            struct \(variablesConst) {
        \(Array(content).sorted().joined(separator: "\n"))
            }
        """
    }
    
    private func tweakManager(localConfigurationFilename: String) -> String {
        """
            static let tweakManager: TweakManager = {
                let userDefaultsConfiguration = UserDefaultsConfiguration(userDefaults: UserDefaults.standard)
                
                let jsonFileURL = Bundle.main.url(forResource: "\(localConfigurationFilename)", withExtension: "json")!
                let localConfiguration = LocalConfiguration(jsonURL: jsonFileURL)
                
                let configurations: [Configuration] = [userDefaultsConfiguration, localConfiguration]
                return TweakManager(configurations: configurations)
            }()
                
            private var tweakManager: TweakManager {
                return Self.tweakManager
            }
        """
    }
    
    private func classContent(localConfigurationContent: Configuration) -> String {
        var content: Set<String> = []
        localConfigurationContent.tweaks.forEach {
            content.insert(tweakProperty(for: $0))
        }
        return content.sorted().joined(separator: "\n\n")
    }
    
    private func tweakProperty(for tweak: Tweak) -> String {
        """
            @TweakProperty(feature: \(featuresConst).\(tweak.feature.camelCased()),
                           variable: \(variablesConst).\(tweak.variable.camelCased()),
                           tweakManager: tweakManager)
            var \(tweak.variable.camelCased()): \(tweak.valueType)
        """
    }
}