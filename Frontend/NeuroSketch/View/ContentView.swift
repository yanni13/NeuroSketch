//
//  ContentView.swift
//  NeuroSketch
//
//  Created by 최희진 on 8/23/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                NavigationStack(path: $navigationPath) {
                    VStack {
                        // 커스텀 헤더
                        HStack {
                            Text("NeuroSketch")
                                .font(.title3)
                            Spacer()
                            Button(action: {
                                navigationPath.append("drawing")
                            }) {
                                Image(systemName: "square.and.pencil")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.black)
                                    .padding(4)
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
                        VStack(alignment: .leading) {
                            Text("할 일")
                                .foregroundStyle(.black)
                                .multilineTextAlignment(.leading)
                            
                            Spacer().frame(height: 12)
                            
                            // 체크리스트 버튼
                            CheckListButton(
                                text: "생성전TodoList"
                            ) {
                                
                            }
                            .padding(.bottom, 65)
                        }
                    }
                    .padding(.horizontal, 24)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .leading
                    )
                    .navigationBarHidden(true)
                    .navigationDestination(for: String.self) { route in
                        switch route {
                        case "drawing":
                            DrawingView()
                        default:
                            EmptyView()
                        }
                    }
                }
                .tabItem {
                    Image(systemName: "house")
                        .resizable()
                        .frame(width: 24, height: 24)
                    
                    Text("홈")
                    
                }
                .tag(0)
                
                Text("아카이브")
                    .tabItem {
                        Image(systemName: "tray")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("아카이브")
                    }
                    .tag(1)
            }
            .tint(Color("green02"))
            
            // 인디케이터
            VStack {
                Spacer()
                HStack {
                    ForEach(0..<2, id: \.self) { index in
                        Rectangle()
                            .fill(selectedTab == index ? Color("green02") : Color.clear)
                            .frame(height: 3)
                    }
                }
                .padding(.bottom, 55)
            }
        }
        .onAppear{
            UserDefaults.standard.set(UUID().uuidString, forKey: "uid")
        }
    }
}

#Preview {
    ContentView()
}
