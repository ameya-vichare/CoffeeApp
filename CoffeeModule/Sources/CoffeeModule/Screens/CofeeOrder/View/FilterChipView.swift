//
//  SwiftUIView.swift
//  CoffeeModule
//
//  Created by Ameya on 10/10/25.
//

import SwiftUI
import DesignSystem

struct FilterChipView: View {
    var body: some View {
        HStack {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .foregroundStyle(AppColors.primaryGray)
            Text("Filters")
                .font(AppFonts.subHeadline)
                .foregroundStyle(AppColors.primaryGray)
            Image(systemName: "chevron.down")
                .foregroundStyle(AppColors.primaryGray)
        }
        .padding(AppPointSystem.point_8)
        .overlay(
            RoundedRectangle(cornerRadius: AppPointSystem.point_8)
                .stroke(AppColors.primaryGray, lineWidth: 0.5)
        )
    }
}

#Preview {
    FilterChipView()
}
