import SwiftUI

// Tab 데이터 모델
struct Tab: Identifiable, Hashable, Comparable, TabTitleConvertible {
    let id: Int
    let title: String
    
    static func < (lhs: Tab, rhs: Tab) -> Bool {
        return lhs.id < rhs.id
    }
}

public protocol TabTitleConvertible {
    var title: String { get }
}

public struct CustomScrollTabView<Selection>: View where Selection: Hashable & Identifiable & Comparable & TabTitleConvertible {
    var views: [Selection: AnyView]
    @Binding var selection: Selection
    @State private var barXOffset: CGFloat = 0
    @State private var barIsActive = false

    public init(views: [Selection: AnyView], selection: Binding<Selection>) {
        self.views = views
        self._selection = selection
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                ForEach(views.keys.sorted()) { key in
                    Button(action: {
                        selection = key
                    }) {
                        Text(key.title)
                            .font(.system(size: 19, weight: key == selection ? .bold : .regular))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(key == selection ? Color.main : Color.white)
                                    .frame(height: 40)
                            )
                            .foregroundColor(
                                key == selection ? Color.white : Color.black
                            )
                    }
                }
            }
            .onAppear {
                barIsActive = true
            }
            .onChange(of: selection) { newValue in
                DispatchQueue.main.async {
                    if let index = views.keys.sorted().firstIndex(of: newValue) {
                        barXOffset = CGFloat(index) * 100
                    }
                }
            }
        }
    }
}

struct ProcessingResultsView: View {
    @State private var selectedTab = Tab(id: 1, title: "1-1")
    @State private var showTabMenu = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                VStack {
                    CustomScrollTabView(
                        views: [
                            Tab(id: 1, title: "1-1"): AnyView(Text("1-1")),
                            Tab(id: 2, title: "1-2"): AnyView(Text("1-2")),
                            Tab(id: 3, title: "1-3"): AnyView(Text("1-3")),
                            Tab(id: 4, title: "1-4"): AnyView(Text("1-4")),
                            Tab(id: 5, title: "2-1"): AnyView(Text("2-1")),
                            Tab(id: 6, title: "2-2"): AnyView(Text("2-2")),
                            Tab(id: 7, title: "2-3"): AnyView(Text("2-3")),
                            Tab(id: 8, title: "2-4"): AnyView(Text("2-4")),
                            Tab(id: 9, title: "3-1"): AnyView(Text("3-1")),
                            Tab(id: 10, title: "3-2"): AnyView(Text("3-2")),
                            Tab(id: 11, title: "3-3"): AnyView(Text("3-3")),
                            Tab(id: 12, title: "3-4"): AnyView(Text("3-4"))
                        ],
                        selection: $selectedTab
                    )
                    .padding(.horizontal)
                    selectedTabView(for: selectedTab)
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("성적 처리")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.black)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: {
                            showTabMenu.toggle()
                        }) {
                            Image(systemName: "line.3.horizontal")
                                .resizable()
                                .frame(width: 22, height: 17)
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .sheet(isPresented: $showTabMenu) {
                TabMenuView(selectedTab: $selectedTab)
            }
        }
    }
    
    @ViewBuilder
    func selectedTabView(for tab: Tab) -> some View {
        switch tab.id {
        case 1: ProcessingResultsList()
        case 2: ProcessingResultsList()
        case 3: ProcessingResultsList()
        case 4: ProcessingResultsList()
        case 5: ProcessingResultsList()
        case 6: ProcessingResultsList()
        case 7: ProcessingResultsList()
        case 8: ProcessingResultsList()
        case 9: ProcessingResultsList()
        case 10: ProcessingResultsList()
        case 11: ProcessingResultsList()
        case 12: ProcessingResultsList()
        default: Text("Select a tab")
        }
    }
}

struct TabMenuView: View {
    @Binding var selectedTab: Tab
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach([
                    Tab(id: 1, title: "1-1"),
                    Tab(id: 2, title: "1-2"),
                    Tab(id: 3, title: "1-3"),
                    Tab(id: 4, title: "1-4"),
                    Tab(id: 5, title: "2-1"),
                    Tab(id: 6, title: "2-2"),
                    Tab(id: 7, title: "2-3"),
                    Tab(id: 8, title: "2-4"),
                    Tab(id: 9, title: "3-1"),
                    Tab(id: 10, title: "3-2"),
                    Tab(id: 11, title: "3-3"),
                    Tab(id: 12, title: "3-4")
                ]) { tab in
                    Button(action: {
                        selectedTab = tab
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text(tab.title)
                            .font(.system(size: 18))
                    }
                }
            }
            .navigationTitle("탭 선택")
            .navigationBarItems(trailing: Button("닫기") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

#Preview {
    ProcessingResultsView()
}
