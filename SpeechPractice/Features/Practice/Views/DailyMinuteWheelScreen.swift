import SwiftUI

struct DailyMinuteWheelScreen: View {
    @Bindable var viewModel: PracticeFlowViewModel

    @Environment(\.dismiss) private var dismiss
    @State private var wheelRotation: Double = 0
    @State private var isSpinning = false
    @State private var selectedPrompt: DailyMinutePrompt?
    @State private var appeared = false

    private let spinDuration: TimeInterval = 2.35

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xl) {
                header
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)

                DailyMinuteWheel(rotation: wheelRotation)
                    .frame(maxWidth: 280)
                    .frame(height: 310)
                    .padding(.top, AppSpacing.md)
                    .opacity(appeared ? 1 : 0)
                    .scaleEffect(appeared ? 1 : 0.95)

                resultSection
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 12)
            }
            .padding(.horizontal, AppSpacing.xl)
            .padding(.top, AppSpacing.md)
            .padding(.bottom, AppSpacing.xxxl)
        }
        .background(AppColors.surface)
        .toolbar(.hidden, for: .navigationBar)
        .safeAreaInset(edge: .top) {
            topBar
        }
        .safeAreaInset(edge: .bottom) {
            bottomAction
        }
        .onAppear {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.82)) {
                appeared = true
            }
        }
    }

    private var topBar: some View {
        HStack(spacing: AppSpacing.md) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppColors.textPrimary)
                    .frame(width: 40, height: 40)
                    .background(AppColors.surfaceRaised, in: Circle())
            }
            .buttonStyle(PressButtonStyle())
            .accessibilityLabel("Back")

            VStack(alignment: .leading, spacing: 2) {
                Text("Daily Minute")
                    .font(AppFonts.title(24, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)

                Text("SPIN FOR YOUR CHALLENGE")
                    .font(AppFonts.label(11, weight: .bold))
                    .foregroundStyle(AppColors.primary)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, AppSpacing.xl)
        .padding(.top, AppSpacing.sm)
        .padding(.bottom, AppSpacing.md)
        .background(AppColors.surface)
    }

    private var header: some View {
        VStack(spacing: AppSpacing.sm) {
            Text("What will you get?")
                .font(AppFonts.title(24, weight: .bold))
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.center)

            Text("Spin once, then speak for 60 seconds with clean pauses and no filler words.")
                .font(AppFonts.body(15, weight: .medium))
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.top, AppSpacing.lg)
    }

    @ViewBuilder
    private var resultSection: some View {
        if let selectedPrompt {
            VStack(spacing: AppSpacing.md) {
                Label {
                    Text(selectedPrompt.category)
                        .font(AppFonts.label(12, weight: .bold))
                } icon: {
                    Image(systemName: selectedPrompt.sfSymbol)
                        .font(.system(size: 15, weight: .bold))
                }
                .foregroundStyle(AppColors.primary)

                Text(selectedPrompt.title)
                    .font(AppFonts.display(26, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                Text(selectedPrompt.prompt)
                    .font(AppFonts.body(16, weight: .medium))
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(AppSpacing.xl)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: AppRadius.xxl)
                    .fill(AppColors.primarySubtle)
            }
            .transition(.move(edge: .bottom).combined(with: .opacity))
        } else {
            VStack(spacing: AppSpacing.sm) {
                Text("Ready for the prompt?")
                    .font(AppFonts.title(22, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)
                    .multilineTextAlignment(.center)

                Text("Tap the button to spin the wheel and receive your 60-second speaking challenge.")
                    .font(AppFonts.body(15, weight: .medium))
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }

    private var bottomAction: some View {
        VStack(spacing: 0) {
            if let selectedPrompt {
                Button {
                    viewModel.startDailyMinute(prompt: selectedPrompt)
                } label: {
                    HStack(spacing: AppSpacing.sm) {
                        Image(systemName: "timer")
                            .font(.system(size: 17, weight: .bold))
                            .accessibilityHidden(true)

                        Text("Start 60 Seconds")
                            .font(AppFonts.label(17, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(AppColors.primary, in: RoundedRectangle(cornerRadius: AppRadius.pill))
                }
                .buttonStyle(PressButtonStyle())
                .accessibilityHint("Starts the one-minute speaking challenge")
                .transition(.move(edge: .bottom).combined(with: .opacity))
            } else {
                Button {
                    spinWheel()
                } label: {
                    HStack(spacing: AppSpacing.sm) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.system(size: 17, weight: .bold))
                            .accessibilityHidden(true)

                        Text(isSpinning ? "Spinning..." : "Spin the Wheel")
                            .font(AppFonts.label(17, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        isSpinning ? AppColors.textTertiary : AppColors.primary,
                        in: RoundedRectangle(cornerRadius: AppRadius.pill)
                    )
                }
                .buttonStyle(PressButtonStyle())
                .disabled(isSpinning)
                .accessibilityHint("Randomly selects one speaking prompt")
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .padding(.horizontal, AppSpacing.xl)
        .padding(.top, AppSpacing.md)
        .padding(.bottom, AppSpacing.lg)
        .background(.ultraThinMaterial)
        .animation(.spring(response: 0.35, dampingFraction: 0.82), value: selectedPrompt)
    }

    private func spinWheel() {
        guard !isSpinning else { return }

        let prompts = DailyMinutePrompt.all
        guard !prompts.isEmpty else {
            preconditionFailure("Daily Minute requires at least one prompt.")
        }

        let selectedIndex = Int.random(in: prompts.indices)
        let prompt = prompts[selectedIndex]
        let segmentAngle = 360.0 / Double(prompts.count)
        let landingRotation = 360.0 - (Double(selectedIndex) * segmentAngle + segmentAngle / 2.0)
        let fullTurns = Double(Int.random(in: 4...6)) * 360.0
        let targetRotation = wheelRotation + fullTurns + landingRotation

        isSpinning = true
        selectedPrompt = nil

        withAnimation(.timingCurve(0.16, 1.0, 0.3, 1.0, duration: spinDuration)) {
            wheelRotation = targetRotation
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + spinDuration) {
            withAnimation(.spring(response: 0.42, dampingFraction: 0.82)) {
                selectedPrompt = prompt
                isSpinning = false
            }
        }
    }
}

private struct DailyMinuteWheel: View {
    let rotation: Double

    private var prompts: [DailyMinutePrompt] {
        DailyMinutePrompt.all
    }

    var body: some View {
        GeometryReader { proxy in
            let size = min(proxy.size.width, proxy.size.height - 44)
            let wheelTop = (proxy.size.height - size - 24) / 2

            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    ZStack {
                        wheelFace(size: size)
                            .rotationEffect(.degrees(rotation))

                        Circle()
                            .fill(AppColors.wheelRim)
                            .frame(width: size * 0.18, height: size * 0.18)

                        Circle()
                            .strokeBorder(AppColors.wheelLine.opacity(0.5), lineWidth: 3)
                            .frame(width: size * 0.11, height: size * 0.11)
                    }
                    .frame(width: size, height: size)
                    .padding(.top, wheelTop)

                    WheelStand()
                        .frame(width: size * 0.58, height: 52)
                        .offset(y: -8)
                }

                WheelPointer()
                    .fill(AppColors.primary)
                    .frame(width: 38, height: 56)
                    .shadow(color: AppColors.wheelLine.opacity(0.22), radius: 4, x: 0, y: 2)
                    .offset(y: max(0, wheelTop - 20))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Daily Minute prompt wheel")
    }

    private func wheelFace(size: CGFloat) -> some View {
        let prompts = prompts
        guard !prompts.isEmpty else {
            preconditionFailure("Daily Minute wheel requires at least one prompt.")
        }

        let segmentAngle = 360.0 / Double(prompts.count)

        return ZStack {
            ForEach(Array(prompts.enumerated()), id: \.element.id) { index, prompt in
                let startAngle = Angle.degrees(-90.0 + Double(index) * segmentAngle)
                let endAngle = Angle.degrees(-90.0 + Double(index + 1) * segmentAngle)
                let labelAngle = Double(index) * segmentAngle + segmentAngle / 2.0

                WheelSegmentShape(startAngle: startAngle, endAngle: endAngle)
                    .fill(index.isMultiple(of: 2) ? AppColors.wheelGold : AppColors.wheelOrange)

                WheelSegmentShape(startAngle: startAngle, endAngle: endAngle)
                    .stroke(AppColors.wheelLine.opacity(0.52), lineWidth: 1.5)

                Text(prompt.category.uppercased())
                    .font(AppFonts.label(9, weight: .bold))
                    .foregroundStyle(AppColors.wheelLine.opacity(0.82))
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)
                    .frame(width: size * 0.34)
                    .rotationEffect(.degrees(labelAngle))
                    .offset(y: -size * 0.29)
                    .rotationEffect(.degrees(labelAngle > 90 && labelAngle < 270 ? 180 : 0))
            }

            Circle()
                .strokeBorder(AppColors.wheelRim, lineWidth: 12)

            Circle()
                .strokeBorder(AppColors.wheelLine.opacity(0.55), lineWidth: 3)
                .padding(8)
        }
        .frame(width: size, height: size)
        .cardShadow()
    }
}

private struct WheelSegmentShape: Shape {
    let startAngle: Angle
    let endAngle: Angle

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        var path = Path()
        path.move(to: center)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        path.closeSubpath()

        return path
    }
}

private struct WheelPointer: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + 6, y: rect.minY + 16))
        path.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.minY),
            control: CGPoint(x: rect.minX + 10, y: rect.minY)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - 6, y: rect.minY + 16),
            control: CGPoint(x: rect.maxX - 10, y: rect.minY)
        )
        path.closeSubpath()

        return path
    }
}

private struct WheelStand: View {
    var body: some View {
        VStack(spacing: 0) {
            TrapezoidShape(topInset: 16)
                .fill(AppColors.wheelOrange)
                .frame(height: 38)

            RoundedRectangle(cornerRadius: AppRadius.sm)
                .fill(AppColors.wheelOrange)
                .overlay {
                    RoundedRectangle(cornerRadius: AppRadius.sm)
                        .strokeBorder(AppColors.wheelLine.opacity(0.52), lineWidth: 2)
                }
                .frame(height: 14)
        }
    }
}

private struct TrapezoidShape: Shape {
    let topInset: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + topInset, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - topInset, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()

        return path
    }
}

#Preview {
    NavigationStack {
        DailyMinuteWheelScreen(viewModel: PracticeFlowViewModel())
    }
}
