//
//  AppFonts.swift
//  DesignSystem
//
//  Created by Ameya on 14/09/25.
//

import SwiftUI

public enum AppFonts {
    public static var title: Font {
        .title
    }
    
    public static var title2: Font {
        .title2
    }
    
    public static var title3: Font {
        .title3
    }
    
    public static var title3Medium: Font {
        .title3
        .weight(.medium)
    }
    
    public static var title2SemiBold: Font {
        .title2
        .weight(.semibold)
    }
    
    public static var headline: Font {
        .headline
    }
    
    public static var headlineMedium: Font {
        .headline
        .weight(.medium)
    }
    
    public static var headlineRegular: Font {
        .headline
        .weight(.regular)
    }
    
    public static var captionMedium: Font {
        .caption
        .weight(.medium)
    }
    
    public static var subHeadline: Font {
        .subheadline
    }
    
    public static var subHeadlineMedium: Font {
        .subheadline
        .weight(.medium)
    }
    
    public static var subHeadlineBold: Font {
        .subheadline
        .weight(.bold)
    }
    
    public static var mediumSixteen: Font {
        .system(size: 16)
        .weight(.medium)
    }
    
    public static var mediumThirty: Font {
        .system(size: 30)
        .weight(.medium)
    }
}
