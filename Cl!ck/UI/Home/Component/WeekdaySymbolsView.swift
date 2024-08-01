import SwiftUI

struct WeekdaySymbolsView: View {
    private let weekdaySymbols: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    
    var body: some View {
        HStack {
            ForEach(weekdaySymbols.indices, id: \.self) { index in
                Text(weekdaySymbols[index].uppercased())
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .font(.subheadline)
            }
        }
        .padding(.vertical, 8)
        .background(Color.white)
    }
}
