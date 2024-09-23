import SwiftUI

struct ProcessingResultsList: View {
    @State private var results: [String] = Array(repeating: "0", count: 18)
    @State private var isButtonEnabled: Bool = false
    @State private var hasSubmitted: Bool = false // 수정 사항 저장 상태

    var body: some View {
        VStack {
            ProcessingResultsListHeader()
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(1..<19) { index in
                        ProcessingResultsCell(
                            number: formattedNumber(index),
                            result: $results[index - 1],
                            isButtonEnabled: $isButtonEnabled
                        )
                    }
                }
            }
            
            // 버튼이 보일 조건을 변경하여 버튼이 비활성화된 상태에서 공간을 차지하지 않도록 함
            if !hasSubmitted && isButtonEnabled {
                Button(action: {
                    saveChanges()
                }) {
                    Text("저장")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(isButtonEnabled ? .white : .white.opacity(0))
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .background(isButtonEnabled ? Color("MainColor") : Color("MainColor").opacity(0))
                        .cornerRadius(6)
                }
                .padding(.horizontal, 29)
            }
        }
        .padding(.bottom, hasSubmitted ? 0 : 20) // 버튼이 사라진 후에도 공간을 줄이기 위해
    }
    
    private func formattedNumber(_ number: Int) -> String {
        return number < 10 ? String(format: "0%d", number) : "\(number)"
    }
    
    private func saveChanges() {
        // 저장 로직 구현 (예: 데이터베이스 저장, 서버 전송 등)
        hasSubmitted = true
        isButtonEnabled = false
    }
}

#Preview {
    ProcessingResultsList()
}
