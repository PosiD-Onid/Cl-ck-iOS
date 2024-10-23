import SwiftUI

struct CalendarCellView: View {
    private var day: Int
    private var clicked: Bool
    private var isToday: Bool
    private var isCurrentMonthDay: Bool
    private var cellHeight: CGFloat
    private var isBViewVisible: Bool
    private var weekday: Int
    
    private var textColor: Color {
        if isToday {
            return Color.white
        } else if clicked {
            return Color.black
        } else if isCurrentMonthDay {
            switch weekday {
            case 1:
                return Color.red
            case 7:
                return Color.blue
            default:
                return Color.black
            }
        } else {
            return Color.clear
        }
    }
    
    private var backgroundColor: Color {
        if isToday {
            return Color.black.opacity(0.7)
        } else if clicked {
            return Color.gray.opacity(0.5)
        } else {
            return Color.clear
        }
    }
    
    private var rectangleColor: Color {
        if isBViewVisible {
            return Color.clear
        } else if isToday {
            return Color.gray.opacity(0.2)
        } else {
            return Color.clear
        }
    }
    
    init(
        day: Int,
        clicked: Bool = false,
        isToday: Bool = false,
        isCurrentMonthDay: Bool = true,
        cellHeight: CGFloat = 80,
        isBViewVisible: Bool = false,
        weekday: Int = 0
    ) {
        self.day = day
        self.clicked = clicked
        self.isToday = isToday
        self.isCurrentMonthDay = isCurrentMonthDay
        self.cellHeight = cellHeight
        self.isBViewVisible = isBViewVisible
        self.weekday = weekday
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if !isBViewVisible {
                Rectangle()
                    .frame(width: 80, height: 0.5)
                    .foregroundColor(.gray400)
            }
            if day != 0 {
                
                RoundedRectangle(cornerRadius: isBViewVisible ? 50 : 10)
                    .fill(backgroundColor)
                    .frame(width: 35, height: 35)
                    .overlay(
                        Text(String(day))
                            .foregroundColor(textColor)
                    )
                    .padding(.top)
            }
            Spacer()
        }
        .frame(height: cellHeight)
        .background(
            Rectangle()
                .frame(width: 52.7)
                .foregroundColor(rectangleColor)
        )
    }
}
