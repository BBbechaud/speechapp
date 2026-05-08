import SwiftUI

struct CategoryScenariosScreen: View {
    let viewModel: PracticeFlowViewModel
    let category: ScenarioCategory

    @State private var appeared = false

    private var scenarios: [Scenario] {
        Scenario.scenarios(for: category)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.base) {
                // Category header card
                categoryHeader
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 14)
                    .animation(.spring(response: 0.45, dampingFraction: 0.8).delay(0.05), value: appeared)

                // Scenarios list
                ForEach(Array(scenarios.enumerated()), id: \.element.id) { index, scenario in
                    Button { viewModel.select(scenario: scenario) } label: {
                        ScenarioRow(scenario: scenario)
                    }
                    .buttonStyle(PressButtonStyle())
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
                    .animation(
                        .spring(response: 0.45, dampingFraction: 0.8)
                            .delay(0.1 + Double(index) * 0.06),
                        value: appeared
                    )
                }
            }
            .padding(.horizontal, AppSpacing.base)
            .padding(.top, AppSpacing.md)
            .padding(.bottom, AppSpacing.xxxl)
        }
        .background(AppColors.background)
        .navigationTitle(category.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(AppColors.background, for: .navigationBar)
        .onAppear {
            appeared = true
        }
    }

    // MARK: - Category Header

    private var categoryHeader: some View {
        ZStack(alignment: .topLeading) {
            // Decorative arcs
            GeometryReader { geo in
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.1))
                        .frame(width: geo.size.height * 1.4)
                        .offset(x: geo.size.width * 0.5, y: geo.size.height * 0.1)
                    Circle()
                        .fill(.white.opacity(0.07))
                        .frame(width: geo.size.height * 1.0)
                        .offset(x: geo.size.width * 0.65, y: geo.size.height * 0.5)
                }
            }
            .clipped()

            HStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.2))
                        .frame(width: 48, height: 48)
                    Image(systemName: category.sfSymbol)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 3) {
                    Text(category.rawValue)
                        .font(AppFonts.title(18, weight: .bold))
                        .foregroundStyle(.white)

                    Text(category.subtitle)
                        .font(AppFonts.body(13))
                        .foregroundStyle(.white.opacity(0.8))
                }

                Spacer(minLength: 0)

                ZStack {
                    Circle()
                        .fill(.white.opacity(0.2))
                        .frame(width: 36, height: 36)
                    Text("\(scenarios.count)")
                        .font(AppFonts.label(15, weight: .bold))
                        .foregroundStyle(.white)
                }
                .accessibilityLabel("\(scenarios.count) scenarios")
            }
            .padding(.horizontal, AppSpacing.xl)
            .padding(.vertical, AppSpacing.lg)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 88)
        .background {
            RoundedRectangle(cornerRadius: AppRadius.xl)
                .fill(
                    LinearGradient(
                        colors: category.gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cardShadow()
        }
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.xl))
    }
}
