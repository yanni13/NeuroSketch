//
//  AnalysisTag.swift
//  NeuroSketch
//
//  Created by 아우신얀 on 8/24/25.
//

import SwiftUI

// MARK: AnalysisTag
struct AnalysisTag: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            VStack(spacing: 8) {
                Text(title)
                Text(value)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, maxHeight: 73, alignment: .center)
        .cornerRadius(10)
        .overlay(
          RoundedRectangle(cornerRadius: 10)
            .inset(by: 0.7)
            .stroke(Color(red: 0.07, green: 0.87, blue: 0.56), lineWidth: 1.4)
        )
    }
}

// MARK: CategoryHeader
struct CategoryHeader: View {
    let itemName: String
    let categoryType: String
    
    var body: some View {
        HStack(spacing: 8) {
            Text(itemName)
            
            HStack(alignment: .center, spacing: 10) {
                Text(categoryType)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .frame(height: 22, alignment: .center)
            .background(.white)
            .cornerRadius(30)
        }
    }
}

// MARK: AnalysisSection
struct AnalysisSection: View {
    let icon: String
    let title: String
    let content: AnyView
    
    init(icon: String, title: String, @ViewBuilder content: () -> some View) {
        self.icon = icon
        self.title = title
        self.content = AnyView(content())
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 8) {
                Image(icon)
                Text(title)
                Spacer()
            }
            Spacer().frame(height: 14)
            
            content
                .padding(.horizontal, 14)
                .padding(.vertical, 18)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .background(Color("green01"))
                .cornerRadius(16)
        }
        .padding(.horizontal, 24)
    }
}

// MARK: AIConditionsSection
struct AIConditionsSection: View {
    let icon: String
    let title: String
    let content: AnyView
    let strokeColor: Color
    let fillColor: Color
    
    init(icon: String, title: String, strokeColor: Color = Color.gray.opacity(0.3), fillColor: Color = Color.white, @ViewBuilder content: () -> some View) {
        self.icon = icon
        self.title = title
        self.strokeColor = strokeColor
        self.fillColor = fillColor
        self.content = AnyView(content())
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 8) {
                Image(icon)
                Text(title)
                Spacer()
            }
            Spacer().frame(height: 14)
            
            content
                .padding(.horizontal, 14)
                .padding(.vertical, 18)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .background(Color("green01"))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color("green02"), lineWidth: 1)
                )
        }
        .padding(.horizontal, 24)
    }
}

// MARK: RecommendationSection
struct RecommendationSection: View {
    let icon: String
    let title: String
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(icon)
                Text(title)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 14) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    HStack(alignment: .top, spacing: 8) {
                        Circle()
                            .frame(width: 11, height: 12)
                            .foregroundStyle(Color("yellow01"))
                            .padding(.vertical, 3)
                       
                        Text(item)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(.white)
            .cornerRadius(14)
        }
        .padding(.horizontal, 24)
    }
}
