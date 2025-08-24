//
//  ContentView.swift
//  NeuroSketch
//
//  Created by 최희진 on 8/23/25.
//

import Lottie
import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var path = NavigationPath()
    @State private var showSuccessPopUp = false
    @State private var isFirstTodoCompleted = false
    @StateObject private var drawingViewModel = DrawingViewModel()
    @StateObject private var contentViewModel = ContentViewModel()
    @EnvironmentObject var appState: AppState
    
    @State private var firstTodoTopic = ""
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                NavigationStack(path: $path) {
                    VStack {
                        // 커스텀 헤더
                        HStack {
                            Text("NeuroSketch")
                                .font(.title3)
                            Spacer()
                            Button(action: {
                                path.append("drawing")
                            }) {
                                Image(systemName: "square.and.pencil")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.black)
                                    .padding(4)
                            }
                            .contentShape(Rectangle())
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

                        LottieComponent()
                            .frame(width: 166, height: 137)
                            .allowsHitTesting(false)

                        Spacer()

                        VStack(alignment: .leading) {
                            Text("할 일")
                                .foregroundStyle(.black)
                                .multilineTextAlignment(.leading)

                            Spacer().frame(height: 12)

                            // 체크리스트 버튼
                            CheckListButton(
                                text: firstTodoTopic,
                                isCompleted: $isFirstTodoCompleted,
                                showIcon: false
                            ) {
                                if let firstTodo = contentViewModel.pendingTodos.first {
                                    contentViewModel.completeTodo(todoId: firstTodo.id) { success in
                                        if success {
                                            showSuccessPopUp = true
                                            isFirstTodoCompleted.toggle()
                                        }
                                    }
                                }
                            }
                            .padding(.bottom, 65)
                        }
                    }
                    .onAppear{
                        isFirstTodoCompleted = false
                        contentViewModel.fetchTodoList(){ success in
                            if success {
                                firstTodoTopic = contentViewModel.pendingTodos.first?.activity ?? "분석 결과에 따라 할 일을 추천해드려요"
                            }
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
                            DrawingView(viewModel: drawingViewModel, navigationPath: $path)
                        case "result":
                            ResultView(navigationPath: $path, drawingViewModel: drawingViewModel, contentViewModel: contentViewModel)
                        case "mainView":
                            ContentView()
                        case "analysis":
                            ImageAnalysisView(navigationPath: $path, viewModel: drawingViewModel)
                        case "detailView":
                            ResultDetailView(navigationPath: $path, drawingViewModel: drawingViewModel)
                        default:
                            ContentView()
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
                
                archiveTapBar
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
            if path.isEmpty {
                VStack {
                    Spacer()
                    HStack {
                        ForEach(0..<2, id: \.self) { index in
                            Rectangle()
                                .fill(
                                    selectedTab == index
                                    ? Color("green02") : Color.clear
                                )
                                .frame(height: 3)
                        }
                    }
                    .padding(.bottom, 55)
                }
            }
            
            // 팝업 오버레이
            if showSuccessPopUp {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()

                SuccessPopUpView(
                    showPopUp: $showSuccessPopUp,
                    navigationPath: $path
                )
            }
        }
        .onAppear{
            if ((UserDefaults.standard.string(forKey: "uid")?.isEmpty) != nil) {
                appState.isLoggedIn = true
            }
        }
    }
    
    private var archiveTapBar: some View{
        NavigationStack(path: $path) {
            // 커스텀 헤더
            ScrollView{
                HStack {
                    Text("NeuroSketch")
                        .font(.title3)
                    Spacer()
                    Button(action: {
                        path.append("drawing")
                    }) {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                            .padding(4)
                    }
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
                }
                .padding(.top, 8)
                .padding(.horizontal, 24)
                
                VStack(alignment: .leading, spacing: 40){
                    if !contentViewModel.pendingTodos.isEmpty {
                        VStack(alignment: .leading, spacing: 12){
                            Text("할 일")
                            
                            ForEach(contentViewModel.pendingTodos, id: \.id) { todo in
                                CheckListButton(
                                    text: todo.activity,
                                    isCompleted: .constant(false),
                                    showIcon: true,
                                    action: {
                                        path.append("result")
                                        contentViewModel.todoAction = todo
                                    }
                                )
                            }
                        }
                    }
                    
                    if !contentViewModel.completedTodos.isEmpty {
                        VStack(alignment: .leading, spacing: 12){
                            Text("완료한 일")
                            
                            ForEach(contentViewModel.completedTodos, id: \.id) { todo in
                                CheckListButton(
                                    text: todo.activity,
                                    isCompleted: .constant(true),
                                    showIcon: true,
                                    action: { 
                                        path.append("result")
                                        contentViewModel.todoAction = todo
                                    }
                                )
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top, 30)
                .padding(.horizontal, 24)
            }
            .navigationBarHidden(true)
            .navigationDestination(for: String.self) { route in
                switch route {
                case "drawing":
                    DrawingView(viewModel: drawingViewModel, navigationPath: $path)
                case "result":
                    ResultView(navigationPath: $path, drawingViewModel: drawingViewModel, contentViewModel: contentViewModel)
                case "mainView":
                    ContentView()
                case "analysis":
                    ImageAnalysisView(navigationPath: $path, viewModel: drawingViewModel)
                case "detailView":
                    ResultDetailView(navigationPath: $path, drawingViewModel: drawingViewModel)
                default:
                    ContentView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
