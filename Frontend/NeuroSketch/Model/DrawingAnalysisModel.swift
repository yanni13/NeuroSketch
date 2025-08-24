//
//  DrawingAnalysisModel.swift
//  NeuroSketch
//
//  Created by Claude on 8/23/25.
//

import Foundation

// MARK: - Main Model
struct DrawingAnalysisModel {
    let analyzedEmotion: AnalyzedEmotionModel
    let agentDecision: AgentDecisionModel
    let personalizedMessage: String
    let recommendations: [String]
    let nextDrawingTheme: String
    let requiresFollowUp: Bool
    let timestamp: Int64
    let careStatus: CareStatusModel
    let imageAnalysis: ImageAnalysisModel
    let psychologicalInterpretation: PsychologicalInterpretationModel
    let aiAdvice: String
    let recommendedActivities: [String]
    let nextDrawingThemeDescription: String
}

// MARK: - Analyzed Emotion Model
struct AnalyzedEmotionModel {
    let primaryEmotion: String
    let intensity: Int
    let confidence: Double
    let reasoning: String
    let timestamp: Int64
}

// MARK: - Agent Decision Model
struct AgentDecisionModel {
    let decisionType: String
    let reasoning: String
    let urgencyLevel: Int
    let recommendedActions: [String]
    let nextDrawingTheme: String
    let requiresImmediate: Bool
    let timestamp: Int64
}

// MARK: - Care Status Model
struct CareStatusModel {
    let level: String
    let description: String
    let urgencyScore: Int
    let reason: String
    let recommendedAction: String
}

// MARK: - Image Analysis Model
struct ImageAnalysisModel {
    let composition: CompositionModel
    let detectedObjects: [String]
    let objectDetails: [ObjectDetailModel]
    let colorsUsed: [String]
    let dominantColors: [String]
    let drawingCharacteristics: DrawingCharacteristicsModel
    let emotionalIndicators: EmotionalIndicatorsModel
    let technicalAnalysis: TechnicalAnalysisModel
    let overallImpression: OverallImpressionModel
}

// MARK: - Composition Model
struct CompositionModel {
    let balance: String
    let hierarchy: String
    let spaceUsage: String
}

// MARK: - Object Detail Model
struct ObjectDetailModel {
    let position: PositionModel
    let objectName: String
    let visualCharacteristics: VisualCharacteristicsModel
    let spatialRelationships: SpatialRelationshipsModel
    let symbolicIndicators: SymbolicIndicatorsModel
}

// MARK: - Position Model
struct PositionModel {
    let location: String
    let prominence: String
    let relativeSize: String
}

// MARK: - Visual Characteristics Model
struct VisualCharacteristicsModel {
    let colors: [String]
    let lineStyle: String
    let detailLevel: String
    let completionState: String
}

// MARK: - Spatial Relationships Model
struct SpatialRelationshipsModel {
    let connectionToOthers: String
    let interactionType: String
    let relativePlacement: String
}

// MARK: - Symbolic Indicators Model
struct SymbolicIndicatorsModel {
    let traditionalMeaning: String
    let artTherapySignificance: String
    let contextualMeaning: String
    let emotionalExpression: String
}

// MARK: - Drawing Characteristics Model
struct DrawingCharacteristicsModel {
    let lineQuality: String
    let drawingStyle: String
    let pressureIntensity: String
}

// MARK: - Emotional Indicators Model
struct EmotionalIndicatorsModel {
    let colorTemperature: String
    let brightnessLevel: String
    let contrastLevel: String
}

// MARK: - Technical Analysis Model
struct TechnicalAnalysisModel {
    let organization: String
    let completionLevel: String
    let detailLevel: String
}

// MARK: - Overall Impression Model
struct OverallImpressionModel {
    let narrativeQuality: String
    let emotionalTone: String
    let energyLevel: String
}

// MARK: - Psychological Interpretation Model
struct PsychologicalInterpretationModel {
    let overallPsychologicalAssessment: String
    let artTherapyInsights: [ArtTherapyInsightModel]
    let emotionalExpressionAnalysis: String
    let developmentalIndicators: String
    let traumaOrStressIndicators: String
    let resilienceIndicators: String
    let communicationStyle: String
}

// MARK: - Art Therapy Insight Model
struct ArtTherapyInsightModel {
    let detectedObject: String
    let element: String
    let observation: String
    let psychologicalMeaning: String
    let artTherapyContext: String
}

// MARK: - Conversion Extension
extension DrawingAnalysisModel {
    init(from dto: DrawingAnalysisResponseDto) {
        self.analyzedEmotion = AnalyzedEmotionModel(from: dto.analyzedEmotion)
        self.agentDecision = AgentDecisionModel(from: dto.agentDecision)
        self.personalizedMessage = dto.personalizedMessage
        self.recommendations = dto.recommendations
        self.nextDrawingTheme = dto.nextDrawingTheme
        self.requiresFollowUp = dto.requiresFollowUp
        self.timestamp = dto.timestamp
        self.careStatus = CareStatusModel(from: dto.careStatus)
        self.imageAnalysis = ImageAnalysisModel(from: dto.imageAnalysis)
        self.psychologicalInterpretation = PsychologicalInterpretationModel(from: dto.psychologicalInterpretation)
        self.aiAdvice = dto.aiAdvice
        self.recommendedActivities = dto.recommendedActivities.map { $0.activity }
        self.nextDrawingThemeDescription = dto.nextDrawingThemeDescription
    }
}

extension AnalyzedEmotionModel {
    init(from dto: AnalyzedEmotion) {
        self.primaryEmotion = dto.primaryEmotion
        self.intensity = dto.intensity
        self.confidence = dto.confidence
        self.reasoning = dto.reasoning
        self.timestamp = dto.timestamp
    }
}

extension AgentDecisionModel {
    init(from dto: AgentDecision) {
        self.decisionType = dto.decisionType
        self.reasoning = dto.reasoning
        self.urgencyLevel = dto.urgencyLevel
        self.recommendedActions = dto.recommendedActions
        self.nextDrawingTheme = dto.nextDrawingTheme
        self.requiresImmediate = dto.requiresImmediate
        self.timestamp = dto.timestamp
    }
}

extension CareStatusModel {
    init(from dto: CareStatus) {
        self.level = dto.level
        self.description = dto.description
        self.urgencyScore = dto.urgencyScore
        self.reason = dto.reason
        self.recommendedAction = dto.recommendedAction
    }
}

extension ImageAnalysisModel {
    init(from dto: ImageAnalysis) {
        self.composition = CompositionModel(from: dto.composition)
        self.detectedObjects = dto.detectedObjects
        self.objectDetails = dto.objectDetails.map { ObjectDetailModel(from: $0) }
        self.colorsUsed = dto.colorsUsed
        self.dominantColors = dto.dominantColors
        self.drawingCharacteristics = DrawingCharacteristicsModel(from: dto.drawingCharacteristics)
        self.emotionalIndicators = EmotionalIndicatorsModel(from: dto.emotionalIndicators)
        self.technicalAnalysis = TechnicalAnalysisModel(from: dto.technicalAnalysis)
        self.overallImpression = OverallImpressionModel(from: dto.overallImpression)
    }
}

extension CompositionModel {
    init(from dto: Composition) {
        self.balance = dto.balance
        self.hierarchy = dto.hierarchy
        self.spaceUsage = dto.spaceUsage
    }
}

extension ObjectDetailModel {
    init(from dto: ObjectDetail) {
        self.position = PositionModel(from: dto.position)
        self.objectName = dto.objectName
        self.visualCharacteristics = VisualCharacteristicsModel(from: dto.visualCharacteristics)
        self.spatialRelationships = SpatialRelationshipsModel(from: dto.spatialRelationships)
        self.symbolicIndicators = SymbolicIndicatorsModel(from: dto.symbolicIndicators)
    }
}

extension PositionModel {
    init(from dto: Position) {
        self.location = dto.location
        self.prominence = dto.prominence
        self.relativeSize = dto.relativeSize
    }
}

extension VisualCharacteristicsModel {
    init(from dto: VisualCharacteristics) {
        self.colors = dto.colors
        self.lineStyle = dto.lineStyle
        self.detailLevel = dto.detailLevel
        self.completionState = dto.completionState
    }
}

extension SpatialRelationshipsModel {
    init(from dto: SpatialRelationships) {
        self.connectionToOthers = dto.connectionToOthers
        self.interactionType = dto.interactionType
        self.relativePlacement = dto.relativePlacement
    }
}

extension SymbolicIndicatorsModel {
    init(from dto: SymbolicIndicators) {
        self.traditionalMeaning = dto.traditionalMeaning
        self.artTherapySignificance = dto.artTherapySignificance
        self.contextualMeaning = dto.contextualMeaning
        self.emotionalExpression = dto.emotionalExpression
    }
}

extension DrawingCharacteristicsModel {
    init(from dto: DrawingCharacteristics) {
        self.lineQuality = dto.lineQuality
        self.drawingStyle = dto.drawingStyle
        self.pressureIntensity = dto.pressureIntensity
    }
}

extension EmotionalIndicatorsModel {
    init(from dto: EmotionalIndicators) {
        self.colorTemperature = dto.colorTemperature
        self.brightnessLevel = dto.brightnessLevel
        self.contrastLevel = dto.contrastLevel
    }
}

extension TechnicalAnalysisModel {
    init(from dto: TechnicalAnalysis) {
        self.organization = dto.organization
        self.completionLevel = dto.completionLevel
        self.detailLevel = dto.detailLevel
    }
}

extension OverallImpressionModel {
    init(from dto: OverallImpression) {
        self.narrativeQuality = dto.narrativeQuality
        self.emotionalTone = dto.emotionalTone
        self.energyLevel = dto.energyLevel
    }
}

extension PsychologicalInterpretationModel {
    init(from dto: PsychologicalInterpretation) {
        self.overallPsychologicalAssessment = dto.overallPsychologicalAssessment
        self.artTherapyInsights = dto.artTherapyInsights.map { ArtTherapyInsightModel(from: $0) }
        self.emotionalExpressionAnalysis = dto.emotionalExpressionAnalysis
        self.developmentalIndicators = dto.developmentalIndicators
        self.traumaOrStressIndicators = dto.traumaOrStressIndicators
        self.resilienceIndicators = dto.resilienceIndicators
        self.communicationStyle = dto.communicationStyle
    }
}

extension ArtTherapyInsightModel {
    init(from dto: ArtTherapyInsight) {
        self.detectedObject = dto.detectedObject
        self.element = dto.element
        self.observation = dto.observation
        self.psychologicalMeaning = dto.psychologicalMeaning
        self.artTherapyContext = dto.artTherapyContext
    }
}
