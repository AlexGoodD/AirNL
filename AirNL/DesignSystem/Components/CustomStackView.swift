//
//  CustomStackView.swift
//  AirNL
//
//  Created by Alejandro on 24/09/25.
//

import SwiftUI
struct CustomStackView<Title: View, Content: View>: View {
    
    var titleView: Title
    var contentView: Content
    var hideTitleUntilCollapsed: Bool
    
    @State private var topOffset: CGFloat = 0
    @State private var bottomOffset: CGFloat = 0
    
    init(hideTitleUntilCollapsed: Bool = false, @ViewBuilder titleView: @escaping () -> Title,
         @ViewBuilder contentView: @escaping () -> Content,
         ) {
        self.titleView = titleView()
        self.contentView = contentView()
        self.hideTitleUntilCollapsed = hideTitleUntilCollapsed
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: Header
            titleView
                .font(.callout)
                .lineLimit(1)
                .frame(height: 38)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .opacity(hideTitleUntilCollapsed ? headerOpacity() : 1)
                    .animation(.easeInOut(duration: 0.2), value: headerOpacity())
                .background(
                    .background,
                    in: RoundedCorner(
                        radius: 12,
                        corners: bottomOffset < 38
                        ? [.topLeft, .topRight, .bottomLeft, .bottomRight]
                        : [.topLeft, .topRight]
                    )
                )
                .zIndex(1)
            
            // MARK: Content
            VStack {
                Divider()
                contentView
                    .padding()
            }
            .background(RoundedRectangle(cornerRadius: 20).fill(.background))
            .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
            .offset(y: topOffset >= 120 ? 0 : -(-topOffset + 120))
            .zIndex(0)
            .clipped()
            .opacity(getOpacity())
        }
        .cornerRadius(12)
        .opacity(getOpacity())
        .offset(y: topOffset >= 120 ? 0 : -topOffset + 120)
        .overlay(
            GeometryReader { proxy in
                let minY = proxy.frame(in: .global).minY
                let maxY = proxy.frame(in: .global).maxY
                
                Color.clear.onAppear {
                    updateOffsets(minY: minY, maxY: maxY)
                }
                .onChange(of: minY) { _ in
                    updateOffsets(minY: minY, maxY: maxY)
                }
            }
        )
        .modifier(CornerModifier(bottomOffset: $bottomOffset))
    }
    
    private func updateOffsets(minY: CGFloat, maxY: CGFloat) {
        DispatchQueue.main.async {
            self.topOffset = minY
            self.bottomOffset = maxY - 120
        }
    }
    
    private func getOpacity() -> CGFloat {
        bottomOffset < 28 ? bottomOffset / 28 : 1
    }
    
    private func headerOpacity() -> CGFloat {
        let start: CGFloat = 120   // punto donde empieza a aparecer
        let end: CGFloat = 82      // punto donde está 100% visible
        
        if topOffset > start {
            return 0   // aún no toca arriba
        } else if topOffset < end {
            return 1   // ya está totalmente visible
        } else {
            // progreso lineal entre start y end
            let progress = (start - topOffset) / (start - end)
            return min(max(progress, 0), 1)
        }
    }
}

struct CornerModifier: ViewModifier {
    @Binding var bottomOffset: CGFloat
    
    func body(content: Content) -> some View {
        if bottomOffset < 38 {
            content
        } else {
            content.cornerRadius(12)
        }
    }
}
//
//#Preview {
//    CustomStackView()
//}
