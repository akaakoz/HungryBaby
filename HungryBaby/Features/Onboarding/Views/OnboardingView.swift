import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(BabyProfileService.self) private var profileService
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = OnboardingViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()

                VStack(spacing: 12) {
                    Image(systemName: "fork.knife.circle.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.orange)

                    Text("HungryBaby")
                        .font(.largeTitle.bold())

                    Text("赤ちゃんの離乳食をサポートします")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                Spacer()

                VStack(alignment: .leading, spacing: 20) {
                    Text("赤ちゃんの情報を入力してください")
                        .font(.headline)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("ニックネーム（任意）")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("例：はなちゃん", text: $viewModel.nickname)
                            .textFieldStyle(.roundedBorder)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("生年月日")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        DatePicker(
                            "",
                            selection: $viewModel.birthDate,
                            in: ...Date.now,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .environment(\.locale, Locale(identifier: "ja_JP"))
                    }

                    if let stage = StageCalculator.stage(for: viewModel.birthDate) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundStyle(.blue)
                            Text("現在: \(stage.displayName)（\(stage.ageRangeDescription)）")
                                .font(.callout)
                                .foregroundStyle(.blue)
                        }
                        .padding(12)
                        .background(.blue.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(.horizontal)

                Spacer()

                Button {
                    viewModel.complete(using: profileService)
                    dismiss()
                } label: {
                    Text("はじめる")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.orange)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }
}

#Preview {
    OnboardingView()
        .environment(BabyProfileService(container: try! .init(for: BabyProfile.self)))
}
