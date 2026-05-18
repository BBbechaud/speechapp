import SwiftUI

struct CustomScenariosScreen: View {
    let viewModel: PracticeFlowViewModel

    @State private var appeared = false

    private var savedScenarios: [CustomScenario] {
        viewModel.customScenarioStore.scenarios
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.base) {
                // Create new row
                Button { viewModel.presentCustomScenarioCreate() } label: {
                    CustomScenarioCreateRow()
                }
                .buttonStyle(PressButtonStyle())
                .accessibilityLabel("Create a custom scenario")
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 10)
                .animation(.spring(response: 0.45, dampingFraction: 0.8).delay(0.05), value: appeared)

                // Saved scenarios
                if !savedScenarios.isEmpty {
                    Text("Saved")
                        .font(AppFonts.label(13, weight: .semibold))
                        .foregroundStyle(AppColors.textSecondary)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 8)
                        .animation(.spring(response: 0.45, dampingFraction: 0.8).delay(0.1), value: appeared)

                    ForEach(Array(savedScenarios.enumerated()), id: \.element.id) { index, custom in
                        Button { viewModel.selectCustomScenario(custom) } label: {
                            CustomScenarioSavedRow(scenario: custom)
                        }
                        .buttonStyle(PressButtonStyle())
                        .contextMenu {
                            Button { viewModel.presentCustomScenarioEdit(custom) } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            Button(role: .destructive) {
                                viewModel.deleteCustomScenario(id: custom.id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 10)
                        .animation(
                            .spring(response: 0.45, dampingFraction: 0.8)
                                .delay(0.12 + Double(index) * 0.05),
                            value: appeared
                        )
                    }
                }
            }
            .padding(.horizontal, AppSpacing.base)
            .padding(.top, AppSpacing.md)
            .padding(.bottom, AppSpacing.xxxl)
        }
        .background(AppColors.background)
        .practiceFlowScreenChrome(title: "Custom Scenarios")
        .onAppear {
            appeared = true
        }
    }
}
