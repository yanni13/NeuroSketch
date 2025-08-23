//
//  ImageAnalysisResponseDto.swift
//  NeuroSketch
//
//  Created by 최희진 on 8/23/25.
//

import Foundation

// MARK: - Main Response DTO
struct DrawingAnalysisResponseDto: Codable {
    let analyzedEmotion: AnalyzedEmotion
    let agentDecision: AgentDecision
    let personalizedMessage: String
    let recommendations: [String]
    let nextDrawingTheme: String
    let requiresFollowUp: Bool
    let timestamp: Int64
    let careStatus: CareStatus
    let imageAnalysis: ImageAnalysis
    let psychologicalInterpretation: PsychologicalInterpretation
    let aiAdvice: String
    let recommendedActivities: [RecommendedActivity]
    let nextDrawingThemeDescription: String
}

// MARK: - Analyzed Emotion
struct AnalyzedEmotion: Codable {
    let primaryEmotion: String
    let intensity: Int
    let confidence: Double
    let reasoning: String
    let timestamp: Int64
}

// MARK: - Agent Decision
struct AgentDecision: Codable {
    let decisionType: String
    let reasoning: String
    let urgencyLevel: Int
    let recommendedActions: [String]
    let nextDrawingTheme: String
    let requiresImmediate: Bool
    let timestamp: Int64
}

// MARK: - Care Status
struct CareStatus: Codable {
    let level: String
    let description: String
    let urgencyScore: Int
    let reason: String
    let recommendedAction: String
}

// MARK: - Image Analysis
struct ImageAnalysis: Codable {
    let composition: Composition
    let detectedObjects: [String]
    let objectDetails: [ObjectDetail]
    let colorsUsed: [String]
    let dominantColors: [String]
    let drawingCharacteristics: DrawingCharacteristics
    let emotionalIndicators: EmotionalIndicators
    let technicalAnalysis: TechnicalAnalysis
    let overallImpression: OverallImpression
    
    enum CodingKeys: String, CodingKey {
        case composition
        case detectedObjects = "detected_objects"
        case objectDetails = "object_details"
        case colorsUsed = "colors_used"
        case dominantColors = "dominant_colors"
        case drawingCharacteristics = "drawing_characteristics"
        case emotionalIndicators = "emotional_indicators"
        case technicalAnalysis = "technical_analysis"
        case overallImpression = "overall_impression"
    }
}

// MARK: - Composition
struct Composition: Codable {
    let balance: String
    let hierarchy: String
    let spaceUsage: String
    
    enum CodingKeys: String, CodingKey {
        case balance
        case hierarchy
        case spaceUsage = "space_usage"
    }
}

// MARK: - Object Detail
struct ObjectDetail: Codable {
    let position: Position
    let objectName: String
    let visualCharacteristics: VisualCharacteristics
    let spatialRelationships: SpatialRelationships
    let symbolicIndicators: SymbolicIndicators
    
    enum CodingKeys: String, CodingKey {
        case position
        case objectName = "object_name"
        case visualCharacteristics = "visual_characteristics"
        case spatialRelationships = "spatial_relationships"
        case symbolicIndicators = "symbolic_indicators"
    }
}

// MARK: - Position
struct Position: Codable {
    let location: String
    let prominence: String
    let relativeSize: String
    
    enum CodingKeys: String, CodingKey {
        case location
        case prominence
        case relativeSize = "relative_size"
    }
}

// MARK: - Visual Characteristics
struct VisualCharacteristics: Codable {
    let colors: [String]
    let lineStyle: String
    let detailLevel: String
    let completionState: String
    
    enum CodingKeys: String, CodingKey {
        case colors
        case lineStyle = "line_style"
        case detailLevel = "detail_level"
        case completionState = "completion_state"
    }
}

// MARK: - Spatial Relationships
struct SpatialRelationships: Codable {
    let connectionToOthers: String
    let interactionType: String
    let relativePlacement: String
    
    enum CodingKeys: String, CodingKey {
        case connectionToOthers = "connection_to_others"
        case interactionType = "interaction_type"
        case relativePlacement = "relative_placement"
    }
}

// MARK: - Symbolic Indicators
struct SymbolicIndicators: Codable {
    let traditionalMeaning: String
    let artTherapySignificance: String
    let contextualMeaning: String
    let emotionalExpression: String
    
    enum CodingKeys: String, CodingKey {
        case traditionalMeaning = "traditional_meaning"
        case artTherapySignificance = "art_therapy_significance"
        case contextualMeaning = "contextual_meaning"
        case emotionalExpression = "emotional_expression"
    }
}

// MARK: - Drawing Characteristics
struct DrawingCharacteristics: Codable {
    let lineQuality: String
    let drawingStyle: String
    let pressureIntensity: String
    
    enum CodingKeys: String, CodingKey {
        case lineQuality = "line_quality"
        case drawingStyle = "drawing_style"
        case pressureIntensity = "pressure_intensity"
    }
}

// MARK: - Emotional Indicators
struct EmotionalIndicators: Codable {
    let colorTemperature: String
    let brightnessLevel: String
    let contrastLevel: String
    
    enum CodingKeys: String, CodingKey {
        case colorTemperature = "color_temperature"
        case brightnessLevel = "brightness_level"
        case contrastLevel = "contrast_level"
    }
}

// MARK: - Technical Analysis
struct TechnicalAnalysis: Codable {
    let organization: String
    let completionLevel: String
    let detailLevel: String
    
    enum CodingKeys: String, CodingKey {
        case organization
        case completionLevel = "completion_level"
        case detailLevel = "detail_level"
    }
}

// MARK: - Overall Impression
struct OverallImpression: Codable {
    let narrativeQuality: String
    let emotionalTone: String
    let energyLevel: String
    
    enum CodingKeys: String, CodingKey {
        case narrativeQuality = "narrative_quality"
        case emotionalTone = "emotional_tone"
        case energyLevel = "energy_level"
    }
}

// MARK: - Psychological Interpretation
struct PsychologicalInterpretation: Codable {
    let overallPsychologicalAssessment: String
    let artTherapyInsights: [ArtTherapyInsight]
    let emotionalExpressionAnalysis: String
    let developmentalIndicators: String
    let traumaOrStressIndicators: String
    let resilienceIndicators: String
    let communicationStyle: String
}

// MARK: - Art Therapy Insight
struct ArtTherapyInsight: Codable {
    let element: String
    let observation: String
    let psychologicalMeaning: String
    let artTherapyContext: String
}

// MARK: - Recommended Activity
struct RecommendedActivity: Codable {
    let id: Int
    let userId: String
    let activity: String
    let createdAt: String
    let updatedAt: String
    let done: Bool
}

// MARK: - Usage Example
extension DrawingAnalysisResponseDto {
    static func decode(from data: Data) throws -> DrawingAnalysisResponseDto {
        let decoder = JSONDecoder()
        return try decoder.decode(DrawingAnalysisResponseDto.self, from: data)
    }
    
    func encode() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try encoder.encode(self)
    }
}
