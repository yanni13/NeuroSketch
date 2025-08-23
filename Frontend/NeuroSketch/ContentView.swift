//
//  ContentView.swift
//  NeuroSketch
//
//  Created by 최희진 on 8/23/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                VStack {
                    // 커스텀 헤더
                    HStack {
                        Text("NeuroSketch")
                            .font(.title3)
                        Spacer()
                        NavigationLink(destination: DrawingView()) {
                            Image(systemName: "square.and.pencil")
                        }
                    }
                    .padding(.top, 8)
                    
                    Spacer().frame(height: 12)
                    
                    HStack {
                        Text("그림을 그려 화분을 채워주세요")
                            .font(.title2)
                            .lineLimit(34)
                        Spacer()
                    }

                    Spacer()

                    // 화분 이미지
                    Rectangle()
                        .frame(width: 166, height: 144)
                    
                    Spacer()
                    
                    // 체크리스트 버튼
                    Button(action: {
                        
                    }, label: {
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .frame(maxWidth: .infinity, maxHeight: 56)
                                .cornerRadius(12)
                                .foregroundStyle(.gray)
                            
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.white)

                                Text("생성전TodoList")
                                    .multilineTextAlignment(.leading)
                                    .foregroundStyle(.white)
                            }
                            .padding(.leading, 16)
                        }
                        .padding(.bottom, 52)
                    })
                }
                .padding(.horizontal, 33)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .leading
                )
                .navigationBarHidden(true)
            }
            .tabItem {
                Image(systemName: "house")
                Text("홈")
            }
            .tag(0)

            Text("아카이브")
                .tabItem {
                    Image(systemName: "tray")
                    Text("아카이브")
                }
                .tag(1)
        }
    }
}

#Preview {
    ContentView()
}
