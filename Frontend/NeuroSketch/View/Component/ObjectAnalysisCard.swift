//
//  ObjectAnalysisCard.swift
//  NeuroSketch
//
//  Created by 아우신얀 on 8/24/25.
//

import SwiftUI

struct ObjectAnalysisCard: View {
    let object: ObjectDetailModel
    let artTherapyInsights: [ArtTherapyInsightModel]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            CategoryHeader(itemName: object.objectName, categoryType: object.position.location)
            
            HStack {
                AnalysisTag(title: "크기", value: object.position.relativeSize)
                AnalysisTag(title: "색상", value: object.visualCharacteristics.colors.first ?? "색상 없음")
                AnalysisTag(title: "선 스타일", value: object.visualCharacteristics.lineStyle)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("🧠")
                    Text("심리학적 의미")
                }
                
                Text(getArtTherapyContext())
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(.white)
            .cornerRadius(14)
        }
    }
    
    private func getArtTherapyContext() -> String {
        // artTherapyInsights에서 detectedObject가 object.objectName과 일치하는 항목 찾기
        if let matchingInsight = artTherapyInsights.first(where: { 
            $0.detectedObject.lowercased() == object.objectName.lowercased() 
        }) {
            return matchingInsight.artTherapyContext
        } else {
            // 매칭되는 항목이 없으면 기존 symbolicIndicators 사용
            return object.symbolicIndicators.artTherapySignificance
        }
    }
}
