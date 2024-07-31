import SwiftUI

struct MyResultsCell: View {
    let subject: String
    let result: Int
    @State private var isChecked: Bool = false

    var body: some View {
        VStack {
            HStack {
                Text(subject)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                Text("\(result)")
                    .frame(maxWidth: .infinity, alignment: .center)
                Button(action: {
                    isChecked.toggle()
                }) {
                    Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.gray)
                        .background(Color.white)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 60)
            }
            .font(.system(size: 15))
            .padding(.vertical)
            Divider()
        }
        .padding(.horizontal)
    }
}

#Preview {
    MyResultsCell(subject: "웹프로그래밍", result: 100)
}
