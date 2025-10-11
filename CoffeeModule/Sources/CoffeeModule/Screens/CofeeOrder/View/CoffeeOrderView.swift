//
//  CoffeeOrderView.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import SwiftUI
import DesignSystem

public struct CoffeeOrderView: View {
    @State private var showSheet: Bool = false
    
    public init() {}
    
    public var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    FilterChipView()
                        .onTapGesture {
                            showSheet = true
                        }
                        .sheet(isPresented: $showSheet) {
                            Text("Hello")
                                
                                .presentationDetents([.medium, .large])
                                .presentationDragIndicator(.visible)
                                .presentationCornerRadius(AppPointSystem.point_20)
                        }
                    
                    FilterChipView()
                    
                    FilterChipView()
                    
                    FilterChipView()
                    
                    FilterChipView()
                }
                .safeAreaPadding(
                    EdgeInsets(
                        top: AppPointSystem.point_0,
                        leading: AppPointSystem.point_20,
                        bottom: AppPointSystem.point_0,
                        trailing: AppPointSystem.point_20
                    )
                )
            }
            .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
    }
}

#Preview {
    CoffeeOrderView()
}
