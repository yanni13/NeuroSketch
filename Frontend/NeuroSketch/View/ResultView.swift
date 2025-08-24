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
    @State private var isCompleted = false
    @State private var matchedAnalysisResult: DrawingAnalysisResponseDto?
    @Binding var navigationPath: NavigationPath
    @ObservedObject var drawingViewModel: DrawingViewModel
    @ObservedObject var contentViewModel: ContentViewModel
    
    var body: some View {
        ZStack {
            VStack {
                // 말풍선
                ZStack {
                    Image("SpeechBallon")
                        .resizable()
                        .frame(maxWidth: 300, maxHeight: 80)
                        .shadow(radius: 2)
                    
//                    if let analysisMessage = drawingViewModel.analysisResult?.personalizedMessage  {
//                        Text(analysisMessage)
//                            .multilineTextAlignment(.center)
//                            .offset(y: -10)
//                            .font(.system(size: 14))
//                            .padding(.horizontal, 20)
//                    } else if let swiftdataMessage = matchedAnalysisResult?.personalizedMessage{
//                        Text(swiftdataMessage)
//                            .multilineTextAlignment(.center)
//                            .offset(y: -10)
//                            .font(.system(size: 14))
//                            .padding(.horizontal, 20)
//                    }else {
                        Text("앞으로 어떤 상황이 와도 이겨낼 수 있을 거야!")
                            .multilineTextAlignment(.center)
                            .offset(y: -10)
                            .font(.system(size: 14))
                            .padding(.horizontal, 20)
//                    }
                }
                .offset(y: -60)
                
                Spacer().frame(height: 20)
                
                LottieComponent()
                    .frame(width: 166, height: 137)
                
                Spacer().frame(height: 60)

                if let analysisResult = drawingViewModel.analysisResult {
                    let koreanEmotion = EmotionUtils.getKoreanEmotion(for: analysisResult.analyzedEmotion.primaryEmotion)
                    Text(koreanEmotion)
                        .padding(3)
                        .font(.system(size: 18, weight: .semibold))
                } else if let swiftdataResult = matchedAnalysisResult{
                    let koreanEmotion = EmotionUtils.getKoreanEmotion(for: swiftdataResult.analyzedEmotion.primaryEmotion)
                    Text(koreanEmotion)
                        .padding(3)
                        .font(.system(size: 18, weight: .semibold))
                }else {
                    Text("새싹")
                        .padding(3)
                }
                
                Spacer().frame(height: 12)
                
                Text(matchedAnalysisResult?.aiAdvice ?? drawingViewModel.analysisResult?.aiAdvice ?? "분석 중입니다...")
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
                        ) {}
                    } else {
                        if let todoAction = contentViewModel.todoAction{
                            CheckListButton(
                                text: todoAction.activity, isCompleted: $isCompleted, showIcon: false
                            ) {
                                contentViewModel.completeTodo(todoId: todoAction.id) { success in
                                    if success {
                                        showSuccessPopUp = true
                                        isCompleted = true
                                    }
                                }
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
        .onAppear{
            if let todoAction = contentViewModel.todoAction{
                isCompleted = todoAction.done
                findMatchingAnalysisResult()
            }
        }
    }
    
    // MARK: - SwiftData 매칭 로직
    private func findMatchingAnalysisResult() {
        guard let todoAction = contentViewModel.todoAction else { return }
        guard let userId = UserDefaults.standard.string(forKey: "uid"), !userId.isEmpty else { return }
        
        Task { @MainActor in
            let savedResults = DrawingAnalysisStorage.shared.fetchAnalysisResults(for: userId)
            
            for entity in savedResults {
                if let dto = entity.toDrawingAnalysisResponseDto() {
                    // recommendedActivities에서 todoAction.id와 매칭되는 항목 찾기
                    for activity in dto.recommendedActivities {
                        if activity.id == todoAction.id {
                            print("🎯 매칭된 분석 결과 발견!")
                            print("Todo ID: \(todoAction.id)")
                            print("Activity ID: \(activity.id)")
                            print("분석 결과 생성일: \(entity.createdAt)")
                            print("개인화 메시지: \(dto.personalizedMessage)")
                            print("AI 조언: \(dto.aiAdvice)")
                            print("주요 감정: \(dto.analyzedEmotion.primaryEmotion)")
                            
                            // 매칭된 결과를 UI에 반영
                            matchedAnalysisResult = dto
                            
                            // DrawingViewModel의 analysisResult도 업데이트
                            if let model = entity.toDrawingAnalysisModel() {
                                drawingViewModel.analysisResult = model
                            }
                            
                            return
                        }
                    }
                }
            }
            
            print("❌ 매칭되는 분석 결과를 찾을 수 없습니다. Todo ID: \(todoAction.id)")
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

