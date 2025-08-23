//
//  CheckListButton.swift
//  NeuroSketch
//
//  Created by 아우신얀 on 8/23/25.
//

import SwiftUI

struct CheckListButton: View {
    let text: String
    @State private var isCompleted = false
    let action: (_ isCompleted: Bool) -> Void
    
    var body: some View {
        Button(action: {
            isCompleted.toggle()
            action(isCompleted)
        }) {
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 56)
                    .cornerRadius(12)
                    .foregroundStyle(isCompleted ? Color("green02") : Color("green01"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("green02"), lineWidth: 1)
                    )
                
                HStack {
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(isCompleted ? .white : Color("green02"))
                    
                    Text(text)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(isCompleted ? .white : Color("green02"))
                }
                .padding(.leading, 16)
            }
        }
    }
}
