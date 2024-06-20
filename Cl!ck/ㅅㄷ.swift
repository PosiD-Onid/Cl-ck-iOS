import SwiftUI

struct ShapeSelectionView: View {
    @State private var shapeASelected = false
    @State private var shapeBSelected = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                Rectangle()
                    .fill(shapeASelected ? Color.red : Color.gray)
                    .frame(width: 285, height: 154)
                    .onTapGesture {
                        shapeASelected.toggle()
                        if shapeASelected {
                            shapeBSelected = false
                        }
                    }
                
                Rectangle()
                    .fill(shapeBSelected ? Color.red : Color.gray)
                    .frame(width: 285, height: 154)
                    .onTapGesture {
                        shapeBSelected.toggle()
                        if shapeBSelected {
                            shapeASelected = false
                        }
                    }
            }
            
            Button(action: {
                // 버튼 클릭 액션
            }) {
                Text("확인")
                    .foregroundColor(.white)
                    .frame(width: 350, height: 50)
                    .background((shapeASelected || shapeBSelected) ? Color.blue : Color.gray.opacity(0.5))
                    .cornerRadius(10)
            }
            .disabled(!(shapeASelected || shapeBSelected))
            
        }
        .padding()
    }
}

struct ShapeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ShapeSelectionView()
    }
}
