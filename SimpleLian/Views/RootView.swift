import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            Tab("今天", systemImage: "checkmark.circle") {
                TodayView()
            }
            Tab("题库", systemImage: "books.vertical") {
                LibraryView()
            }
            Tab("数据", systemImage: "externaldrive") {
                DataView()
            }
        }
    }
}
