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
                        EmotionCard(emoji: getEmotionEmoji(for: analysisResult.analyzedEmotion.primaryEmotion), emotion: analysisResult.analyzedEmotion.primaryEmotion)
                    } else {
                        EmotionCard(emoji: "😡", emotion: "분노")
                    }
                    
                    if let analysisResult = drawingViewModel.analysisResult {
                        StatusIndicatorCard(
                            statusText: analysisResult.careStatus.description,
                            backgroundColor: getStatusBackgroundColor(for: analysisResult.careStatus.level),
                            indicatorColor: getStatusIndicatorColor(for: analysisResult.careStatus.level)
                        )
                    } else {
                        StatusIndicatorCard(
                            statusText: "즉시 관리 필요",
                            backgroundColor: Color("orange01"),
                            indicatorColor: Color("orange02")
                        )
                    }
                }
                .padding(.horizontal, 53)
            }
            
            Spacer().frame(height: 40)
            
            AnalysisSection(icon: "accentIcon", title: "그림 분석") {
                VStack(alignment: .leading, spacing: 14) {
                    if let analysisResult = drawingViewModel.analysisResult,
                       let firstObject = analysisResult.imageAnalysis.objectDetails.first {
                        CategoryHeader(itemName: firstObject.objectName, categoryType: firstObject.position.location)
                    } else {
                        CategoryHeader(itemName: "집", categoryType: "위치")
                    }
                    
                    HStack {
                        if let analysisResult = drawingViewModel.analysisResult,
                           let firstObject = analysisResult.imageAnalysis.objectDetails.first {
                            AnalysisTag(title: "크기", value: firstObject.position.relativeSize)
                            AnalysisTag(title: "색상", value: firstObject.visualCharacteristics.colors.first ?? "색상 없음")
                            AnalysisTag(title: "선 스타일", value: firstObject.visualCharacteristics.lineStyle)
                        } else {
                            AnalysisTag(title: "크기", value: "보통")
                            AnalysisTag(title: "색상", value: "초록색")
                            AnalysisTag(title: "선 스타일", value: "보통")
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("🧠")
                            Text("심리학적 의미")
                        }
                        
                        if let analysisResult = drawingViewModel.analysisResult,
                           let firstObject = analysisResult.imageAnalysis.objectDetails.first {
                            Text(firstObject.symbolicIndicators.artTherapySignificance)
                        } else {
                            Text("전총적 의미~")
                        }
                    }
                    .padding(14)
                    .frame(width: 317, alignment: .topLeading)
                    .background(.white)
                    .cornerRadius(14)
                }
            }
            
            Spacer().frame(height: 24)
            
            AIConditionsSection(icon: "accentIcon", title: "AI 조건") {
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
                    "충분한 수면을 취하여 정서적 안정을 도모하세요", 
                    "가족이나 친구와 대화 시간을 늘려보세요",
                    "취미 활동을 통해 긍정적인 에너지를 충전하세요"
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
    private func getEmotionEmoji(for emotion: String) -> String {
        switch emotion.lowercased() {
        case "기쁨", "행복", "joy", "happiness":
            return "😊"
        case "분노", "화남", "anger":
            return "😡"
        case "슬픔", "sadness":
            return "😢"
        case "두려움", "fear":
            return "😨"
        case "놀람", "surprise":
            return "😮"
        case "혐오", "disgust":
            return "🤢"
        case "평온", "calm":
            return "😌"
        default:
            return "😐"
        }
    }
    
    private func getStatusBackgroundColor(for level: String) -> Color {
        switch level.lowercased() {
        case "high", "높음", "urgent", "긴급":
            return Color("red01")
        case "medium", "보통", "moderate":
            return Color("orange01")
        case "low", "낮음", "stable", "안정":
            return Color("green01")
        default:
            return Color("orange01")
        }
    }
    
    private func getStatusIndicatorColor(for level: String) -> Color {
        switch level.lowercased() {
        case "high", "높음", "urgent", "긴급":
            return Color("red02")
        case "medium", "보통", "moderate":
            return Color("orange02")
        case "low", "낮음", "stable", "안정":
            return Color("green02")
        default:
            return Color("orange02")
        }
    }
}
