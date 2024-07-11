import SwiftUI

// MARK: - Cell View
struct CalendarCellView: View {
    @Binding public var onClick: Bool
    @Binding public var isTapSideMenu: Bool
    
    private var day: Int
    private var clicked: Bool
    private var isToday: Bool
    private var isCurrentMonthDay: Bool
    
    private var textColor: Color {
        if isToday {
            return Color.white
        } else if clicked {
            return Color.black
        } else if isCurrentMonthDay {
            return Color.black
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
        if isToday {
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
        onClick: Binding<Bool>,
        isTapSideMenu: Binding<Bool>
    ) {
        self.day = day
        self.clicked = clicked
        self.isToday = isToday
        self.isCurrentMonthDay = isCurrentMonthDay
        self._onClick = onClick
        self._isTapSideMenu = isTapSideMenu
    }
    
    var body: some View {
        VStack {
            Text("\(day)")
                .foregroundColor(textColor)
                .background(Circle().fill(backgroundColor))
                .onTapGesture {
                    if isCurrentMonthDay {
                        onClick.toggle()
                    }
                }
            
            if clicked {
                SideMenu(onClick: $onClick, isTapSideMenu: $isTapSideMenu)
            }
        }
        .background(Rectangle().fill(rectangleColor))
    }
}
