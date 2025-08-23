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
    
    var body: some View {
        ScrollView {
            Spacer().frame(height: 40)

            VStack {
                HStack(alignment: .top, spacing: 14) {
                    EmotionCard(emoji: "😡", emotion: "분노")
                    
                    StatusIndicatorCard(
                        statusText: "즉시 관리 필요",
                        backgroundColor: Color("orange01"),
                        indicatorColor: Color("orange02")
                    )
                }
                .padding(.horizontal, 53)
            }
            
            Spacer().frame(height: 40)
            
            AnalysisSection(icon: "accentIcon", title: "그림 분석") {
                VStack(alignment: .leading, spacing: 14) {
                    CategoryHeader(itemName: "집", categoryType: "위치")
                    
                    HStack {
                        AnalysisTag(title: "크기", value: "보통")
                        AnalysisTag(title: "색상", value: "초록색")
                        AnalysisTag(title: "크기", value: "보통")
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("🧠")
                            Text("심리학적 의미")
                        }
                        
                        Text("전총적 의미~")
                    }
                    .padding(14)
                    .frame(width: 317, alignment: .topLeading)
                    .background(.white)
                    .cornerRadius(14)
                }
            }
            
            Spacer().frame(height: 24)
            
            AIConditionsSection(icon: "accentIcon", title: "AI 조건") {
                Text("ddd")
            }
            
            Spacer().frame(height: 40)

            RecommendationSection(
                icon: "accentIcon", 
                title: "추천 활동",
                items: [
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
                    "평온한 자연 풍경 그리기"
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
}
