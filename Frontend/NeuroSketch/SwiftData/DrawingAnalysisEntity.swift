//
//  DrawingAnalysisEntity.swift
//  NeuroSketch
//
//  Created by Claude on 8/24/25.
//

import Foundation
import SwiftData

@Model
class DrawingAnalysisEntity {
    var id: UUID
    var userId: String
    var createdAt: Date
    
    // Store entire DrawingAnalysisResponseDto as JSON
    var analysisDataJSON: Data
    
    init(from dto: DrawingAnalysisResponseDto, userId: String) {
        self.id = UUID()
        self.userId = userId
        self.createdAt = Date()
        
        // Encode entire DTO as JSON
        do {
            self.analysisDataJSON = try JSONEncoder().encode(dto)
        } catch {
            print("❌ DTO JSON 인코딩 실패: \(error)")
            self.analysisDataJSON = Data()
        }
    }
}

// MARK: - Conversion Extensions
extension DrawingAnalysisEntity {
    func toDrawingAnalysisResponseDto() -> DrawingAnalysisResponseDto? {
        do {
            return try JSONDecoder().decode(DrawingAnalysisResponseDto.self, from: analysisDataJSON)
        } catch {
            print("❌ JSON 디코딩 실패: \(error)")
            return nil
        }
    }
    
    func toDrawingAnalysisModel() -> DrawingAnalysisModel? {
        guard let dto = toDrawingAnalysisResponseDto() else { return nil }
        return DrawingAnalysisModel(from: dto)
    }
}