//
//  CanvasView.swift
//  NeuroSketch
//
//  Created by 아우신얀 on 8/23/25.
//

import SwiftUI
import PencilKit

// 드로잉 도구 타입
enum DrawingTool {
    case pen
    case marker
    case signature
}

struct Drawing {
    var lines: [Line] = []
}

struct Line {
    var points: [CGPoint]
    var color: Color
    var lineWidth: CGFloat
    var tool: DrawingTool
}

// 스트로크 포인트 데이터 구조체
struct StrokePointData {
    let location: CGPoint
    let timeOffset: TimeInterval
    let size: CGSize
}

// 스트로크 데이터 구조체
struct StrokeData {
    let points: [StrokePointData]
    let inkType: String
    let color: UIColor
}

struct CanvasView: UIViewRepresentable {
    @Binding var drawing: PKDrawing
    @Binding var tool: DrawingTool
    let canvasSize: CGSize
    
    // 스트로크 데이터를 전달하기 위한 클로저 (옵셔널)
    var onStrokeDataExtracted: ((StrokeData) -> Void)?
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: CanvasView
        let toolPicker = PKToolPicker()
        
        init(_ parent: CanvasView) {
            self.parent = parent
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            DispatchQueue.main.async {
                self.parent.drawing = canvasView.drawing
                
                // 가장 최근 스트로크의 데이터 추출
                if let lastStroke = canvasView.drawing.strokes.last {
                    let strokeData = self.extractStrokeData(from: lastStroke)
                    self.parent.onStrokeDataExtracted?(strokeData)
                    
                    // 손가락 터치 분석
                    self.analyzeFingerTouchData(strokeData)
                }
            }
        }
        
        func setupToolPicker(for canvasView: PKCanvasView) {
            toolPicker.addObserver(canvasView)
            toolPicker.setVisible(true, forFirstResponder: canvasView)
            toolPicker.selectedTool = PKInkingTool(.pen, color: .black, width: 5)

            DispatchQueue.main.async {
                canvasView.becomeFirstResponder()
            }
        }
        
        // PKStroke에서 데이터 추출
        func extractStrokeData(from stroke: PKStroke) -> StrokeData {
            var pointsData: [StrokePointData] = []
            
            for point in stroke.path {
                let pointData = StrokePointData(
                    location: point.location,
                    timeOffset: point.timeOffset,
                    size: point.size
                )
                pointsData.append(pointData)
            }
            
            let strokeData = StrokeData(
                points: pointsData,
                inkType: stroke.ink.inkType.rawValue,
                color: stroke.ink.color
            )
            
            return strokeData
        }
        
        // 손가락 터치 데이터 분석
        func analyzeFingerTouchData(_ strokeData: StrokeData) {
            print("=== 손가락 터치 데이터 분석 ===")
            
            // 유용한 데이터
            print("📍 위치 정보: \(strokeData.points.count)개 포인트")
            print("⏱️ 시간 정보: \(String(format: "%.3f", strokeData.points.last?.timeOffset ?? 0))초 동안")
            
            // 속도 계산
            if strokeData.points.count > 1 {
                var speeds: [CGFloat] = []
                for i in 1..<strokeData.points.count {
                    let p1 = strokeData.points[i-1]
                    let p2 = strokeData.points[i]
                    
                    let distance = sqrt(pow(p2.location.x - p1.location.x, 2) +
                                      pow(p2.location.y - p1.location.y, 2))
                    let timeInterval = p2.timeOffset - p1.timeOffset
                    let speed = timeInterval > 0 ? distance / CGFloat(timeInterval) : 0
                    speeds.append(speed)
                }
                
                let avgSpeed = speeds.reduce(0, +) / CGFloat(speeds.count)
                let maxSpeed = speeds.max() ?? 0
                print("🏃‍♀️ 평균 속도: \(String(format: "%.1f", avgSpeed)) points/sec")
                print("🚀 최대 속도: \(String(format: "%.1f", maxSpeed)) points/sec")
            }
            
            // 크기 정보
            let sizes = strokeData.points.map { $0.size.width }
            let avgSize = sizes.reduce(0, +) / CGFloat(sizes.count)
            let sizeVariation = (sizes.max() ?? 0) - (sizes.min() ?? 0)
            print("📏 평균 크기: \(String(format: "%.2f", avgSize))")
            print("📐 크기 변화: \(String(format: "%.2f", sizeVariation))")
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.delegate = context.coordinator
        canvasView.drawing = drawing
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        canvasView.isUserInteractionEnabled = true
        context.coordinator.setupToolPicker(for: canvasView)
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        if uiView.drawing != drawing {
            print("Updating canvasView.drawing: \(drawing.strokes.count) strokes")
            uiView.drawing = drawing
        }
    }
}

// 사용 예시를 위한 extension
extension CanvasView {
    // 스트로크 데이터 콜백을 설정하는 편의 메서드
    func onFingerStrokeExtracted(_ callback: @escaping (StrokeData) -> Void) -> CanvasView {
        var view = self
        view.onStrokeDataExtracted = { strokeData in
            callback(strokeData)
        }
        return view
    }
}

