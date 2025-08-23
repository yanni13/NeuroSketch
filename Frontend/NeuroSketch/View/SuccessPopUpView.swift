//
//  SuccessPopUpView.swift
//  NeuroSketch
//
//  Created by 아우신얀 on 8/23/25.
//

import SwiftUI

struct SuccessPopUpView: View {
    @Binding var showPopUp: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button(action: {
                    showPopUp = false
                }, label: {
                    Image("closeIcon")
                        .resizable()
                        .frame(width: 33, height: 33)
                })
            }
            
            Image("mainIcon")
            
            Spacer().frame(height: 18)
            
            Text("할 일 완료!")
                .padding(2)
            
            Spacer().frame(height: 2)
            
            Text("그림을 그려 다음 할 일을 채워보세요")
                .padding(2)
            
            Spacer().frame(height: 12)

            Button(action: {
                
            }, label: {
                ZStack {
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 42)
                        .cornerRadius(12)
                        .foregroundStyle(Color("green02"))
                    
                    Text("그림 그리기")
                        .foregroundStyle(.white)
                }
            })
        }
        .zIndex(1)
        .padding(.horizontal, 16)
        .frame(width: 293, height: 326)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
//                .fill(Color.white)
                .stroke(.white, lineWidth: 1)
        )
    }
}
