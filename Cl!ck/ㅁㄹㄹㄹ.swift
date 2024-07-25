import SwiftUI

struct exff: View {
    @State private var isBViewVisible = false
    @State private var dragOffset = CGSize.zero
    @State private var bViewOffset = CGFloat(0)
    @State private var selectedDate = Date()  // 추가된 상태 변수

    var body: some View {
        VStack {
            AView(isBViewVisible: $isBViewVisible, showBView: showBView, selectedDate: $selectedDate)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
            
            if isBViewVisible {
                ScheduleListView()
                    .offset(y: bViewOffset)
                    .transition(.move(edge: .bottom))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation
                                if dragOffset.height > 0 {
                                    bViewOffset = dragOffset.height
                                }
                            }
                            .onEnded { value in
                                if bViewOffset > 200 { // Drag distance to hide BView
                                    hideBView()
                                } else {
                                    withAnimation {
                                        bViewOffset = 0
                                    }
                                }
                            }
                    )
                    .animation(.spring(), value: bViewOffset)
            }
        }
        .animation(.easeInOut, value: isBViewVisible)
    }
    
    private func showBView() {
        withAnimation {
            isBViewVisible = true
            bViewOffset = 0
        }
    }
    
    private func hideBView() {
        withAnimation {
            isBViewVisible = false
            bViewOffset = UIScreen.main.bounds.height
        }
    }
}

struct AView: View {
    @Binding var isBViewVisible: Bool
    let showBView: () -> Void
    @Binding var selectedDate: Date  // 추가된 바인딩 변수
    
    var body: some View {
        VStack {
            DatePicker(
                "Select a date:",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(GraphicalDatePickerStyle()) // 달력 스타일
            .padding()
            
            Button(action: {
                showBView()
            }) {
                Text("Show BView")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .background(Color.gray.opacity(0.2))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        exff()
    }
}
