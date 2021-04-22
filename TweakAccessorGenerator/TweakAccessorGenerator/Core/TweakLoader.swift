//
//  TweakLoader.swift
//  Copyright © 2021 Just Eat Takeaway. All rights reserved.
//

import Foundation

extension String: Error {}

class TweakLoader {
    
    func load(_ filePath: String) throws -> [Tweak] {
        let url = URL(fileURLWithPath: filePath)
        let data = try Data(contentsOf: url)
        guard let content = try JSONSerialization.jsonObject(with: data) as? TweaksFormat else {
            throw "Invalid JSON format for file \(filePath)"
        }
        
        let tweaks = try content.map { (featureKey: String, tweaks: [String: [String: Any]]) throws -> [Tweak] in
            try tweaks.map { (variableKey: String, dictionary: [String: Any]) throws -> Tweak in
                try tweak(for: dictionary, feature: featureKey, variable: variableKey)
            }
            .sorted { $0.variable < $1.variable }
        }
        .flatMap { $0 }
        .sorted { $0.feature < $1.feature }
        
        try validate(tweaks)
        
        return tweaks
    }
    
    func validate(_ tweaks: [Tweak]) throws {
        let propertyNames = tweaks.map { $0.propertyName }.compactMap { $0 }
        let duplicates = propertyNames.duplicates
        if duplicates.count > 0 {
            throw "Found duplicate 'GeneratedPropertyName': \(duplicates)"
        }
    }
    
    func type(for value: Any) throws -> String {
        switch value {
        case _ as String: return "String"
        case let numberValue as NSNumber: return numberValue.tweakType
        case _ as Bool: return "Bool"
        case _ as Double: return "Double"
        default:
            throw "Unsupported value type \(Swift.type(of: value))"
        }
    }
    
    func tweak(for dictionary: [String: Any], feature: FeatureKey, variable: VariableKey) throws -> Tweak {
        guard let title = dictionary["Title"] as? String else {
            throw "Missing 'Title' value in dictionary \(dictionary)"
        }
        guard let group = dictionary["Group"] as? String else {
            throw "Missing 'Group' value in dictionary \(dictionary)"
        }
        let hasOptionalValue = dictionary["OptionalValue"] as? Bool
        if hasOptionalValue == true {
            if dictionary["ValueType"] == nil {
                throw "Missing 'ValueType' value in dictionary \(dictionary) (mandatory if OptionalValue is set to true)"
            }
        }
        else {
            if dictionary["Value"] == nil {
                throw "Missing 'Value' value in dictionary \(dictionary)"
            }
        }
        let value = dictionary["Value"]!
        let valueType: String = hasOptionalValue == true ?
            dictionary["ValueType"] as! String :try type(for: value)
        
        return Tweak(feature: feature,
                     variable: variable,
                     title: title,
                     description: dictionary["Description"] as? String,
                     group: group,
                     valueType: valueType,
                     propertyName: dictionary["GeneratedPropertyName"] as? String,
                     optionalValue: dictionary["OptionalValue"] as? Bool ?? false)
    }
}
