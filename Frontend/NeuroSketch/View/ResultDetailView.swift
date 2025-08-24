//
//  ResultDetailView.swift
//  NeuroSketch
//
//  Created by 아우신얀 on 8/24/25.
//

import SwiftUI

struct ResultDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var navigationPath: NavigationPath
    @ObservedObject var drawingViewModel: DrawingViewModel
    
    var body: some View {
        ScrollView {
            Spacer().frame(height: 40)

            VStack {
                HStack(alignment: .top, spacing: 14) {
                    if let analysisResult = drawingViewModel.analysisResult {
                        let koreanEmotion = EmotionUtils.getKoreanEmotion(for: analysisResult.analyzedEmotion.primaryEmotion)
                        FlexibleEmotionCard(emoji: EmotionUtils.getEmotionEmoji(for: koreanEmotion), emotion: koreanEmotion)
                    }
                    
                    if let analysisResult = drawingViewModel.analysisResult {
                        let mappedStatusText = getMappedStatusText(for: analysisResult.careStatus.level)
                        FlexibleStatusIndicatorCard(
                            statusText: mappedStatusText,
                            backgroundColor: getStatusBackgroundColor(for: mappedStatusText),
                            indicatorColor: getStatusIndicatorColor(for: mappedStatusText)
                        )
                    }
                }
                .padding(.horizontal, 63)
            }
            
            Spacer().frame(height: 40)
            
            AnalysisSection(icon: "accentIcon", title: "그림 분석") {
                VStack(alignment: .leading, spacing: 14) {
                    if let analysisResult = drawingViewModel.analysisResult,
                       !analysisResult.imageAnalysis.objectDetails.isEmpty {
                        // 각 객체마다 ObjectAnalysisCard 표시
                        ForEach(Array(analysisResult.imageAnalysis.objectDetails.enumerated()), id: \.offset) { index, object in
                            ObjectAnalysisCard(
                                object: object, 
                                artTherapyInsights: analysisResult.psychologicalInterpretation.artTherapyInsights
                            )
                            
                            if index < analysisResult.imageAnalysis.objectDetails.count - 1 {
                                Spacer().frame(height: 20)
                            }
                        }
                    } 
                }
            }
            
            Spacer().frame(height: 24)
            
            AIConditionsSection(icon: "accentIcon", title: "AI 조언") {
                if let analysisResult = drawingViewModel.analysisResult {
                    Text(analysisResult.aiAdvice)
                } else {
                    Text("분석 데이터를 불러오는 중입니다...")
                }
            }
            
            Spacer().frame(height: 40)

            RecommendationSection(
                icon: "accentIcon", 
                title: "추천 활동",
                items: drawingViewModel.analysisResult?.recommendedActivities ?? [
                    "규칙적인 운동을 통해 스트레스를 해소하세요",
                ]
            )
            
            Spacer().frame(height: 40)
            
            RecommendationSection(
                icon: "accentIcon",
                title: "다음 그림 주제 추천",
                items: [
                    drawingViewModel.analysisResult?.nextDrawingThemeDescription ?? drawingViewModel.nextTopic
                ]
            )
            
            Spacer().frame(height: 24)
        }
        .navigationTitle("분석결과")
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.black)
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    navigationPath = NavigationPath()
                }, label: {
                    Image("home")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.black)
                })
                .frame(width: 44, height: 44)
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func getStatusBackgroundColor(for statusText: String) -> Color {
        switch statusText {
        case "즉시 관리 필요":
            return Color("orange01")
        case "관리 필요":
            return Color("yellow02")
        case "양호":
            return Color("green04")
        default:
            return Color("yellow02")
        }
    }
    
    private func getStatusIndicatorColor(for statusText: String) -> Color {
        switch statusText {
        case "즉시 관리 필요":
            return Color("orange02")
        case "관리 필요":
            return Color("yellow03")
        case "양호":
            return Color("green03")
        default:
            return Color("yellow03")
        }
    }
    
    private func getMappedStatusText(for level: String) -> String {
        switch level.lowercased() {
        case "긴급", "위험", "즉시_관리", "즉시관리", "urgent", "critical", "high":
            return "즉시 관리 필요"
        case "주의", "주의_관찰", "주의관찰", "관리_필요", "관리필요", "medium", "moderate", "attention":
            return "관리 필요" 
        case "안정", "양호", "정상", "stable", "good", "normal", "low":
            return "양호"
        default:
            return "관리 필요"
        }
    }
}

// MARK: - Flexible Card Components
struct FlexibleEmotionCard: View {
    let emoji: String
    let emotion: String
    
    var body: some View {
        StatusCard(title: "현재 감정") {
            HStack {
                Text(emoji)
                Text(emotion)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

// MARK: FlexibleStatusIndicatorCard
struct FlexibleStatusIndicatorCard: View {
    let statusText: String
    let backgroundColor: Color
    let indicatorColor: Color
    
    private var dynamicMinHeight: CGFloat {
        switch statusText.count {
        case 0...4:
            return 23
        case 5...8:
            return 23
        default:
            return 23
        }
    }
    
    private var dynamicPadding: CGFloat {
        switch statusText.count {
        case 0...4:
            return 8
        case 5...8:
            return 10
        default:
            return 10
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("상태")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
            
            HStack(spacing: 6) {
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundStyle(indicatorColor)
                
                Text(statusText)
//                    .lineLimit(3)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 12, weight: .medium))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, dynamicPadding)
            .padding(.vertical, 4)
            .frame(maxWidth: .infinity, minHeight: dynamicMinHeight, alignment: .center)
            .background(backgroundColor)
            .cornerRadius(dynamicMinHeight / 2)
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 88)
        .overlay(
            RoundedRectangle(cornerRadius: 0)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}
