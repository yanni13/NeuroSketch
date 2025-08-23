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
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if progress < 1.0 {
                progress = min(1.0, progress + 0.02)
                if progress >= 1.0 {
                    timer.invalidate()
                    isAnalyzing = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        navigationPath.append("result")
                    }
                }
            }
        }
    }
}
