//
//  ImageAnalysisView .swift
//  NeuroSketch
//
//  Created by 아우신얀 on 8/23/25.
//

import SwiftUI

struct ImageAnalysisView: View {
    @Environment(\.dismiss) var dismiss
    @State private var progress: Double = 0.0
    @State private var savedImage: UIImage?
    @State private var isAnalyzing = false
    @Binding var navigationPath: NavigationPath
    @ObservedObject var viewModel: DrawingViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 24)

            ProgressView(value: progress, total: 1.0)
                .progressViewStyle(LinearProgressViewStyle(tint: Color("green02")))
                .frame(height: 8)
                .scaleEffect(x: 1, y: 2)
                .padding(.horizontal, 34)
                .padding(.top, 8)
            
            Spacer().frame(height: 24)
            
            ZStack {
                if let savedImage = savedImage {
                    Image(uiImage: savedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 324, maxHeight: 440)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color("green01"), lineWidth: 1)
                        )
                }
            }
            
            Spacer().frame(height: 35)
            
            Text(isAnalyzing ? "분석 중 ..." : "분석 완료!")
                .font(.headline)
                .foregroundColor(.black)
            
            Spacer()
            
        }
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            loadSavedImage()
            startAnalysis()
            analyzeDrawing()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    navigationPath.removeLast()
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.black)
                })
            }
        }
    }
    
    private func loadSavedImage() {
        // Documents 디렉토리에서 가장 최근 그림 파일 불러오기
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsPath, includingPropertiesForKeys: [.creationDateKey], options: [])
            
            let drawingFiles = fileURLs.filter { $0.pathExtension == "png" && $0.lastPathComponent.contains("drawing_") }
            
            if let latestFile = drawingFiles.sorted(by: { (url1, url2) -> Bool in
                let date1 = (try? url1.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast
                let date2 = (try? url2.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast
                return date1 > date2
            }).first {
                savedImage = UIImage(contentsOfFile: latestFile.path)
            }
        } catch {
            print("Error loading saved image: \(error)")
        }
    }
    
    private func startAnalysis() {
        isAnalyzing = true
        
        // 25초 동안 진행되도록 설정
        let totalDuration: Double = 25.0  // 25초
        let updateInterval: Double = 0.1   // 0.1초마다 업데이트
        let incrementPerUpdate = 1.0 / (totalDuration / updateInterval)  // 약 0.004씩 증가
        
        Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { timer in
            if progress < 1.0 {
                progress = min(1.0, progress + incrementPerUpdate)
                
                if progress >= 1.0 {
                    timer.invalidate()
                    isAnalyzing = false
                    
                    // 분석 완료 후 1초 대기하고 다음 화면으로 이동
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        navigationPath.append("result")
                    }
                }
            }
        }
    }
    
    private func analyzeDrawing(){
        viewModel.analyzeDrawing() { success in
            if success {
                print("analyzeDrawing 요청 성공")
//                navigationPath.append("result")
            }
        }
    }
}
