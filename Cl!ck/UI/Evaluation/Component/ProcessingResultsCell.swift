import SwiftUI

struct ProcessingResultsCell: View {
    let number: String
    @Binding var result: String
    @Binding var isButtonEnabled: Bool
    
    var body: some View {
        VStack {
            HStack(spacing: 50) {
                Text(number)
                Text("권예림")
                TextField("Enter result", text: $result)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 65, height: 15)
                    .multilineTextAlignment(.center)
                    .onChange(of: result) { _ in
                        checkIfButtonShouldBeEnabled()
                    }
                Text("false")
            }
            .font(.system(size: 15))
            .padding(.vertical)
            .padding(.leading)
            Divider()
        }
        .padding(.horizontal)
    }
    
    private func checkIfButtonShouldBeEnabled() {
        // 입력 필드의 값이 변경되면 버튼 활성화 여부를 결정
        let hasChanges = !result.isEmpty
        if hasChanges {
            isButtonEnabled = true
        }
    }
}

#Preview {
    ProcessingResultsCell(number: "01", result: .constant("0"), isButtonEnabled: .constant(false))
}
