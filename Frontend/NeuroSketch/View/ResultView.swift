//
//  ResultView.swift
//  NeuroSketch
//
//  Created by 아우신얀 on 8/23/25.
//

import SwiftUI

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

struct ResultView: View {
    var body: some View {
        VStack {
            // 말풍선
            ZStack {
                Image("SpeechBallon")
                    .resizable()
                    .frame(maxWidth: 300, maxHeight: 100)
                    .shadow(radius: 10)
                
                Text("응원 메시지")
                    .multilineTextAlignment(.center)
                    .offset(y: -10)
            }
            
            Rectangle()
                .frame(width: 300, height: 300)
            
            Spacer().frame(height: 40)

            Text("새싹")
                .padding(3)
            
            Spacer().frame(height: 12)
            
            Text("분석내용분석내용분석내용")
                .padding(3)
            
            Spacer().frame(height: 40)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("할 일")
                    .multilineTextAlignment(.leading)
                
                CheckListButton(
                    text: "산책하기"
                ) {
                    
                }
            }
        }
        .padding(.bottom, 20)
        .padding(.horizontal, 24)
        .navigationBarBackButtonHidden()
        .navigationTitle("분석결과")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.black)
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                }, label: {
                    Image(systemName: "house.fill")
                        .foregroundStyle(.black)
                })
            }
        }
    }
}

#Preview {
    ResultView()
}
