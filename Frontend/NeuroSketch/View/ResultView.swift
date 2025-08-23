//
//  ResultView.swift
//  NeuroSketch
//
//  Created by 아우신얀 on 8/23/25.
//

import SwiftUI

struct ResultView: View {
    @State private var showSuccessPopUp = false
    @State private var showDetailView = false
    @Binding var navigationPath: NavigationPath
    @ObservedObject var drawingViewModel: DrawingViewModel
    
    var body: some View {
        ZStack {
            VStack {
                // 말풍선
                ZStack {
                    Image("SpeechBallon")
                        .resizable()
                        .frame(maxWidth: 300, maxHeight: 100)
                        .shadow(radius: 2)
                    
                    Text(drawingViewModel.analysisResult?.personalizedMessage ?? "응원 메시지")
                        .multilineTextAlignment(.center)
                        .offset(y: -10)
                        .font(.system(size: 14))
                        .padding(.horizontal, 20)
                }
                .offset(y: -60)
                
                LottieComponent()
                    .frame(width: 166, height: 137)
                
                Spacer().frame(height: 60)

                if let analysisResult = drawingViewModel.analysisResult {
                    let koreanEmotion = EmotionUtils.getKoreanEmotion(for: analysisResult.analyzedEmotion.primaryEmotion)
                    Text(koreanEmotion)
                        .padding(3)
                        .font(.system(size: 18, weight: .semibold))
                } else {
                    Text("새싹")
                        .padding(3)
                }
                
                Spacer().frame(height: 12)
                
                Text(drawingViewModel.analysisResult?.aiAdvice ?? "분석 중입니다...")
                    .padding(3)
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                
                Spacer().frame(height: 40)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("할 일")
                        .multilineTextAlignment(.leading)
                    
                    if let activities = drawingViewModel.analysisResult?.recommendedActivities,
                       let firstActivity = activities.first {
                        CheckListButton(
                            text: firstActivity, isCompleted: .constant(false), showIcon: false
                        ) { isCompleted in
                            if isCompleted {
                                showSuccessPopUp = true
                            }
                        }
                    } else {
                        CheckListButton(
                            text: "산책하기", isCompleted: .constant(false), showIcon: false
                        ) { isCompleted in
                            if isCompleted {
                                showSuccessPopUp = true
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 20)
            .padding(.horizontal, 24)
            
            if showSuccessPopUp {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                
                SuccessPopUpView(showPopUp: $showSuccessPopUp, navigationPath: $navigationPath)
            }
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("분석결과")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    navigationPath = NavigationPath()

                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.black)
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
//                    showDetailView = true
                    navigationPath.append("detailView")
                }, label: {
                    Image(systemName: "info.circle")
                        .foregroundStyle(.black)
                })
            }
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

