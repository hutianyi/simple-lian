import SwiftData
import SwiftUI

@main
struct SimpleLianApp: App {
    private let storage: StorageState

    init() {
        do {
            storage = .ready(try ModelContainer(for: AppSchema.schema))
        } catch {
            storage = .failed(error.localizedDescription)
        }
    }

    var body: some Scene {
        WindowGroup {
            switch storage {
            case .ready(let container):
                RootView().modelContainer(container)
            case .failed(let detail):
                ContentUnavailableView(
                    "无法打开本地题库",
                    systemImage: "externaldrive.badge.exclamationmark",
                    description: Text("请先保留现有数据，不要卸载 App，然后联系开发者处理。\n\n\(detail)")
                )
            }
        }
    }
}

private enum StorageState {
    case ready(ModelContainer)
    case failed(String)
}

enum AppSchema {
    static let schema = Schema([
        ImportBatch.self,
        ProblemGroup.self,
        Question.self,
        ReviewState.self,
        PracticeSession.self,
        Attempt.self,
        SessionGroupProgress.self
    ])
}
