//
//  DrawingAnalysisStorage.swift
//  NeuroSketch
//
//  Created by Claude on 8/24/25.
//

import Foundation
import SwiftData

@MainActor
class DrawingAnalysisStorage: ObservableObject {
    static let shared = DrawingAnalysisStorage()
    
    private var modelContainer: ModelContainer
    private var modelContext: ModelContext
    
    init() {
        do {
            modelContainer = try ModelContainer(for: DrawingAnalysisEntity.self)
            modelContext = modelContainer.mainContext
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    // MARK: - Save Analysis Result
    func saveAnalysisResult(_ dto: DrawingAnalysisResponseDto, userId: String) {
        do {
            let entity = DrawingAnalysisEntity(from: dto, userId: userId)
            modelContext.insert(entity)
            try modelContext.save()
            print("✅ SwiftData에 분석 결과 저장 성공: \(entity.id)")
        } catch {
            print("❌ SwiftData 저장 실패: \(error)")
        }
    }
    
    // MARK: - Fetch Analysis Results
    func fetchAnalysisResults(for userId: String) -> [DrawingAnalysisEntity] {
        do {
            let predicate = #Predicate<DrawingAnalysisEntity> { entity in
                entity.userId == userId
            }
            let descriptor = FetchDescriptor<DrawingAnalysisEntity>(
                predicate: predicate,
                sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
            )
            return try modelContext.fetch(descriptor)
        } catch {
            print("❌ SwiftData 조회 실패: \(error)")
            return []
        }
    }
    
    // MARK: - Fetch Latest Analysis Result
    func fetchLatestAnalysisResult(for userId: String) -> DrawingAnalysisEntity? {
        let results = fetchAnalysisResults(for: userId)
        return results.first
    }
    
    // MARK: - Delete Analysis Result
    func deleteAnalysisResult(_ entity: DrawingAnalysisEntity) {
        do {
            modelContext.delete(entity)
            try modelContext.save()
            print("✅ SwiftData에서 분석 결과 삭제 성공")
        } catch {
            print("❌ SwiftData 삭제 실패: \(error)")
        }
    }
    
    // MARK: - Delete All Analysis Results
    func deleteAllAnalysisResults(for userId: String) {
        let results = fetchAnalysisResults(for: userId)
        for result in results {
            modelContext.delete(result)
        }
        
        do {
            try modelContext.save()
            print("✅ SwiftData에서 모든 분석 결과 삭제 성공")
        } catch {
            print("❌ SwiftData 전체 삭제 실패: \(error)")
        }
    }
    
    // MARK: - Count Analysis Results
    func getAnalysisResultCount(for userId: String) -> Int {
        return fetchAnalysisResults(for: userId).count
    }
    
    // MARK: - Print All Analysis Results
    func printAllAnalysisResults(for userId: String) {
        let results = fetchAnalysisResults(for: userId)
        
        print("==========================================")
        print("📊 SwiftData 저장된 분석 결과 - 사용자: \(userId)")
        print("총 \(results.count)개의 분석 결과")
        print("==========================================")
        
        for (index, entity) in results.enumerated() {
            print("\n🔍 분석 결과 #\(index + 1)")
            print("ID: \(entity.id)")
            print("생성일: \(entity.createdAt)")
            print("사용자 ID: \(entity.userId)")
            
            if let dto = entity.toDrawingAnalysisResponseDto() {
                print("\n📋 분석 내용:")
                print("- 주요 감정: \(dto.analyzedEmotion.primaryEmotion)")
                print("- 감정 강도: \(dto.analyzedEmotion.intensity)")
                print("- 감정 신뢰도: \(dto.analyzedEmotion.confidence)")
                print("- 케어 레벨: \(dto.careStatus.level)")
                print("- 케어 점수: \(dto.careStatus.urgencyScore)")
                print("- 개인화 메시지: \(dto.personalizedMessage)")
                print("- AI 조언: \(dto.aiAdvice)")
                print("- 감지된 객체: \(dto.imageAnalysis.detectedObjects.joined(separator: ", "))")
                print("- 주요 색상: \(dto.imageAnalysis.dominantColors.joined(separator: ", "))")
                print("- 추천 활동 수: \(dto.recommendedActivities.count)개")
                print("- 다음 그림 주제: \(dto.nextDrawingTheme)")
                print("- 후속 조치 필요: \(dto.requiresFollowUp)")
                
                print("\n🎨 이미지 분석 상세:")
                print("- 구성 균형: \(dto.imageAnalysis.composition.balance)")
                print("- 공간 사용: \(dto.imageAnalysis.composition.spaceUsage)")
                print("- 선 품질: \(dto.imageAnalysis.drawingCharacteristics.lineQuality)")
                print("- 그림 스타일: \(dto.imageAnalysis.drawingCharacteristics.drawingStyle)")
                print("- 감정적 톤: \(dto.imageAnalysis.overallImpression.emotionalTone)")
                print("- 에너지 레벨: \(dto.imageAnalysis.overallImpression.energyLevel)")
                
                print("\n🧠 심리학적 해석:")
                print("- 전체 평가: \(dto.psychologicalInterpretation.overallPsychologicalAssessment)")
                print("- 미술치료 인사이트 수: \(dto.psychologicalInterpretation.artTherapyInsights.count)개")
                print("- 의사소통 스타일: \(dto.psychologicalInterpretation.communicationStyle)")
                
                if !dto.psychologicalInterpretation.artTherapyInsights.isEmpty {
                    print("\n🎭 미술치료 인사이트:")
                    for (idx, insight) in dto.psychologicalInterpretation.artTherapyInsights.enumerated() {
                        print("  \(idx + 1). 객체: \(insight.detectedObject)")
                        print("     요소: \(insight.element)")
                        print("     관찰: \(insight.observation)")
                        print("     심리적 의미: \(insight.psychologicalMeaning)")
                        print("     치료 맥락: \(insight.artTherapyContext)")
                    }
                }
                
                if !dto.recommendedActivities.isEmpty {
                    print("\n💡 추천 활동:")
                    for (idx, activity) in dto.recommendedActivities.enumerated() {
                        print("  \(idx + 1). \(activity.activity) (완료: \(activity.done))")
                    }
                }
                
            } else {
                print("❌ JSON 디코딩 실패")
            }
            
            print("\n" + String(repeating: "-", count: 50))
        }
        
        if results.isEmpty {
            print("📭 저장된 분석 결과가 없습니다.")
        }
        
        print("==========================================\n")
    }
}
