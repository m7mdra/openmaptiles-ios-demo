//
//  LocalStyle.swift
//  GeographyClass
//
//  Created by LaBaih on 06/05/2024.
//  Copyright © 2024 Klokan Technologies GmbH. All rights reserved.
//

import Foundation

// MARK: - LocalStyle
struct LocalStyle: Codable {
    var version: Int
    var name: String
    var center: [Int]
    var zoom: Int
    var sources: Sources
    var sprite, glyphs: String
    var layers: [Layer]
}
extension LocalStyle{
    // MARK: - Layer
    struct Layer: Codable {
        var id: String
        var type: String
        var paint: Paint
        var source: Source?
        var sourceLayer: String?
        var layout: Layout?
        var filter: [String]?
        var minzoom: Double?
        var maxzoom: Int?
        
        enum CodingKeys: String, CodingKey {
            case id, type, paint, source
            case sourceLayer = "source-layer"
            case layout, filter, minzoom, maxzoom
        }
    }
    
    // MARK: - Layout
    struct Layout: Codable {
        var lineJoin, textField: String?
        var textFont: [String]?
        var textTransform: String?
        var textMaxWidth: Int?
        var textSize: TextSize?
        var textLetterSpacing, textLineHeight: TextLetterSpacing?
        var textOffset: [Int]?
        var symbolPlacement: String?
        var symbolSpacing: Int?
        
        enum CodingKeys: String, CodingKey {
            case lineJoin = "line-join"
            case textField = "text-field"
            case textFont = "text-font"
            case textTransform = "text-transform"
            case textMaxWidth = "text-max-width"
            case textSize = "text-size"
            case textLetterSpacing = "text-letter-spacing"
            case textLineHeight = "text-line-height"
            case textOffset = "text-offset"
            case symbolPlacement = "symbol-placement"
            case symbolSpacing = "symbol-spacing"
        }
    }
    

    // MARK: - TextLetterSpacing
    struct TextLetterSpacing: Codable {
        let stops: [[Double]]
    }
    
    enum TextSize: Codable {
        case integer(Int)
        case textLetterSpacing(TextLetterSpacing)
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let x = try? container.decode(Int.self) {
                self = .integer(x)
                return
            }
            if let x = try? container.decode(TextLetterSpacing.self) {
                self = .textLetterSpacing(x)
                return
            }
            throw DecodingError.typeMismatch(TextSize.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for TextSize"))
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .integer(let x):
                try container.encode(x)
            case .textLetterSpacing(let x):
                try container.encode(x)
            }
        }
    }
    
    // MARK: - Paint
    struct Paint: Codable {
        var backgroundColor, lineColor: String?
        var lineWidth: LineWidthUnion?
        var lineOpacity: LineOpacity?
        var fillColor: String?
        var lineDasharray: [Int]?
        var textHaloColor: String?
        var textHaloWidth: Double?
        var textColor: String?
        
        enum CodingKeys: String, CodingKey {
            case backgroundColor = "background-color"
            case lineColor = "line-color"
            case lineWidth = "line-width"
            case lineOpacity = "line-opacity"
            case fillColor = "fill-color"
            case lineDasharray = "line-dasharray"
            case textHaloColor = "text-halo-color"
            case textHaloWidth = "text-halo-width"
            case textColor = "text-color"
        }
    }
    
    enum LineOpacity: Codable {
        case double(Double)
        case textLetterSpacing(TextLetterSpacing)
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let x = try? container.decode(Double.self) {
                self = .double(x)
                return
            }
            if let x = try? container.decode(TextLetterSpacing.self) {
                self = .textLetterSpacing(x)
                return
            }
            throw DecodingError.typeMismatch(LineOpacity.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for LineOpacity"))
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .double(let x):
                try container.encode(x)
            case .textLetterSpacing(let x):
                try container.encode(x)
            }
        }
    }
    
    enum LineWidthUnion: Codable {
        case double(Double)
        case lineWidthClass(LineWidthClass)
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let x = try? container.decode(Double.self) {
                self = .double(x)
                return
            }
            if let x = try? container.decode(LineWidthClass.self) {
                self = .lineWidthClass(x)
                return
            }
            throw DecodingError.typeMismatch(LineWidthUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for LineWidthUnion"))
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .double(let x):
                try container.encode(x)
            case .lineWidthClass(let x):
                try container.encode(x)
            }
        }
    }
    
    // MARK: - LineWidthClass
    struct LineWidthClass: Codable {
        var stops: [[Double]]
        var base: Double?
    }
    
    enum Source: String, Codable {
        case countries = "countries"
    }
    
    // MARK: - Sources
    struct Sources: Codable {
        var countries: Countries
    }
    
    // MARK: - Countries
    struct Countries: Codable {
        var type: String
        var bounds: [Double]
        var minzoom, maxzoom: Int
        var tiles: [String]
    }
}
