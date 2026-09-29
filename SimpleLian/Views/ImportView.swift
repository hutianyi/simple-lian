import SwiftData
import SwiftUI
import UniformTypeIdentifiers

struct ImportView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var rawText = ""
    @State private var preview: ImportPreview?
    @State private var errorMessage: String?
    @State private var allowDuplicate = false

    var body: some View {
        NavigationStack {
            Form {
                Section("粘贴题库") {
                    TextEditor(text: $rawText)
                        .frame(minHeight: 220)
                        .font(.system(.body, design: .monospaced))
                    HStack {
                        PasteButton(payloadType: String.self) { values in rawText = values.first ?? ""; inspect() }
                        Button("检查内容", action: inspect).buttonStyle(.borderedProminent)
                    }
                }
                if let preview {
                    Section("导入预览") {
                        LabeledContent("标题", value: preview.payload.batchTitle)
                        LabeledContent("题型", value: "\(preview.groupCount)")
                        LabeledContent("扩展题", value: "\(preview.variantCount)")
                        if preview.isDuplicate {
                            Toggle("仍然作为副本导入", isOn: $allowDuplicate)
                            Text("已存在内容相同的题库。默认会阻止重复导入。")
                                .foregroundStyle(.orange)
                        }
                    }
                    if !preview.report.issues.isEmpty {
                        Section("检查结果") {
                            ForEach(preview.report.issues) { issue in
                                Label {
                                    VStack(alignment: .leading) {
                                        Text(issue.message)
                                        Text(issue.location).font(.caption).foregroundStyle(.secondary)
                                    }
                                } icon: {
                                    Image(systemName: issue.severity == .error ? "xmark.octagon.fill" : "exclamationmark.triangle.fill")
                                        .foregroundStyle(issue.severity == .error ? .red : .orange)
                                }
                            }
                        }
                    }
                    Section {
                        Button("确认导入") { commit(preview) }
                            .disabled(!preview.report.canImport || (preview.isDuplicate && !allowDuplicate))
                    }
                }
            }
            .navigationTitle("导入题库")
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("取消") { dismiss() } } }
            .alert("导入失败", isPresented: .constant(errorMessage != nil), presenting: errorMessage) { _ in
                Button("好") { errorMessage = nil }
            } message: { Text($0) }
        }
    }

    private func inspect() {
        do { preview = try ImportService.preview(text: rawText, context: context); errorMessage = nil }
        catch { preview = nil; errorMessage = error.localizedDescription }
    }

    private func commit(_ preview: ImportPreview) {
        do { try ImportService.commit(preview, context: context, allowDuplicate: allowDuplicate); dismiss() }
        catch { errorMessage = error.localizedDescription }
    }
}
