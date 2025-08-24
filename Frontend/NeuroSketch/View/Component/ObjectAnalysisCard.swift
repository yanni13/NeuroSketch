//
//  ObjectAnalysisCard.swift
//  NeuroSketch
//
//  Created by 아우신얀 on 8/24/25.
//

import SwiftUI

struct ObjectAnalysisCard: View {
    let object: ObjectDetailModel
    
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
                
                Text(object.symbolicIndicators.artTherapySignificance)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(.white)
            .cornerRadius(14)
        }
    }
}
