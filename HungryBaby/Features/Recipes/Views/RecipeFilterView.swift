import SwiftUI

struct RecipeFilterView: View {
    @Binding var selectedStage: BabyStage?
    @Binding var selectedDifficulty: Difficulty?
    @Binding var selectedCookingTime: CookingTime?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("ステージ") {
                    ForEach(BabyStage.allCases) { stage in
                        HStack {
                            Circle()
                                .fill(stage.systemColor)
                                .frame(width: 10, height: 10)
                            Text(stage.displayName)
                            Spacer()
                            if selectedStage == stage {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedStage = selectedStage == stage ? nil : stage
                        }
                    }
                }

                Section("難易度") {
                    ForEach(Difficulty.allCases, id: \.rawValue) { difficulty in
                        HStack {
                            Text(difficulty.displayName)
                            Spacer()
                            if selectedDifficulty == difficulty {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedDifficulty = selectedDifficulty == difficulty ? nil : difficulty
                        }
                    }
                }

                Section("調理時間") {
                    ForEach(CookingTime.allCases, id: \.rawValue) { time in
                        HStack {
                            Text(time.displayName)
                            Spacer()
                            if selectedCookingTime == time {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedCookingTime = selectedCookingTime == time ? nil : time
                        }
                    }
                }
            }
            .navigationTitle("フィルター")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完了") { dismiss() }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("クリア") {
                        selectedStage = nil
                        selectedDifficulty = nil
                        selectedCookingTime = nil
                    }
                }
            }
        }
    }
}
