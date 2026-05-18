import SwiftUI
import UIKit

// MARK: - App Colors
//
// Naming convention:
//   primary = Orange (Sunset) - the brand's main color, CTAs, hero moments
//   accent  = Purple (Indigo) - supporting accent for streaks, info, secondary brand moments
//
// 5-shade scales: 50 (lightest) -> 100 -> 300 -> 500 (base) -> 700 (darkest)
// Each shade in a scale is the same hue at different lightness/saturation.
// Skipping odd shade numbers (200/400/600/800) leaves room to add more later.
//
// Semantic states use 3 shades each: bg / base / textDark.
// Difficulty colors are tuned warmer to harmonize with the brand.
// Wheel colors are kept as a separate multi-hue set for that specific feature.
//
// Background: warm-tinted modern grey (#F6F5F2) - cleaner and more tech-product
// than cream, while still staying warm enough for the orange brand color.

enum AppColors {

    // MARK: - Backgrounds
    /// Primary background: warm-tinted modern grey (cleaner than cream).
    static let background        = Color(hex: "#F6F5F2")
    /// Alternate slightly deeper grey for layering and variety.
    static let backgroundAlt     = Color(hex: "#EFEEEA")
    /// Pure white for cards and surfaces that need to pop.
    static let surface           = Color.white
    /// Slightly off-white raised surface (for cards on white sections).
    static let surfaceRaised     = Color(hex: "#FBFBF9")
    /// Soft halo behind practice-complete mascot (warm peach).
    static let mascotBackdrop    = Color(hex: "#FCE8DE")

    // MARK: - Greys
    static let grey50            = Color(hex: "#EFEFEC")
    static let grey100           = Color(hex: "#E4E3DF")
    static let grey300           = Color(hex: "#B6B5B0")
    static let grey500           = Color(hex: "#6A6964")
    static let grey700           = Color(hex: "#1F1E1B")

    // MARK: - Text
    static let textPrimary       = grey700
    static let textSecondary     = grey500
    static let textTertiary      = grey300

    // MARK: - Primary (Sunset Orange)
    static let primary50         = Color(hex: "#FCE6D5")
    static let primary100        = Color(hex: "#F8B98C")
    static let primary300        = Color(hex: "#F08C52")
    static let primary500        = Color(hex: "#E8632A")
    static let primary700        = Color(hex: "#B14418")

    static let primary           = primary500
    static let primarySubtle     = primary50
    static let primaryMedium     = primary100

    // MARK: - Accent (Indigo Purple)
    static let accent50          = Color(hex: "#F1EEFB")
    static let accent100         = Color(hex: "#C9BEED")
    static let accent300         = Color(hex: "#9C8BDF")
    static let accent500         = Color(hex: "#7B6BD1")
    static let accent700         = Color(hex: "#3D2F87")

    static let accent            = accent500
    static let accentSubtle      = accent50
    static let accentMedium      = accent100

    // MARK: - Semantic States
    static let successBg         = Color(hex: "#E8F5EC")
    static let success           = Color(hex: "#2EA868")
    static let successText       = Color(hex: "#1A5C3A")

    static let warningBg         = Color(hex: "#FFF6E0")
    static let warning           = Color(hex: "#E8A02E")
    static let warningText       = Color(hex: "#7A4A00")

    static let errorBg           = Color(hex: "#FCEAE8")
    static let error             = Color(hex: "#D93D2E")
    static let errorText         = Color(hex: "#7A1F18")

    static let infoBg            = accent50
    static let info              = accent500
    static let infoText          = accent700

    // MARK: - Difficulty
    static let easyFg            = Color(hex: "#3F6B1A")
    static let easyBg            = Color(hex: "#E8F2DC")
    static let mediumFg          = Color(hex: "#C24D17")
    static let mediumBg          = primary50
    static let hardFg            = Color(hex: "#A02C20")
    static let hardBg            = Color(hex: "#FCE6DC")

    // MARK: - UI
    static let separator         = grey100
    static let tabInactive       = grey300

    // MARK: - XP / Progress
    /// Level / XP row on skill list cards (readable on white surfaces).
    static let xpMetricGold      = Color(hex: "#C29412")

    /// Outer stroke on XP progress capsules (faint black).
    static let xpMeterStroke     = Color.black.opacity(0.14)

    // MARK: - Daily Minute Wheel
    static let wheelGold         = Color(hex: "#FFC95F")
    static let wheelOrange       = Color(hex: "#F47632")
    static let wheelRim          = Color(hex: "#C9472F")
    static let wheelLine         = Color(hex: "#8E3428")
}

// MARK: - Typography

enum AppFonts {
    static func display(_ size: CGFloat, weight: Font.Weight = .bold) -> Font {
        dmSans(size, weight: weight)
    }

    static func title(_ size: CGFloat, weight: Font.Weight = .semibold) -> Font {
        dmSans(size, weight: weight)
    }

    static func body(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        dmSans(size, weight: weight)
    }

    static func label(_ size: CGFloat, weight: Font.Weight = .medium) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }

    private static func dmSans(_ size: CGFloat, weight: Font.Weight) -> Font {
        let name: String
        switch weight {
        case .bold, .heavy, .black: name = "DMSans-Bold"
        case .semibold:             name = "DMSans-SemiBold"
        case .medium:               name = "DMSans-Medium"
        default:                    name = "DMSans-Regular"
        }
        return .custom(name, size: size)
    }
}

// MARK: - Spacing

enum AppSpacing {
    static let xs:   CGFloat = 4
    static let sm:   CGFloat = 8
    static let md:   CGFloat = 12
    static let base: CGFloat = 16
    static let lg:   CGFloat = 20
    static let xl:   CGFloat = 24
    static let xxl:  CGFloat = 32
    static let xxxl: CGFloat = 48
}

// MARK: - Corner Radii

enum AppRadius {
    static let sm:   CGFloat = 8
    static let md:   CGFloat = 12
    static let lg:   CGFloat = 16
    static let xl:   CGFloat = 20
    static let xxl:  CGFloat = 28
    static let pill: CGFloat = 999
}

// MARK: - Shadows

extension View {
    func cardShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
            .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
    }

    func subtleShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Press Feedback

struct PressScaleModifier: ViewModifier {
    @State private var isPressed = false
    let scale: CGFloat

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? scale : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in isPressed = false }
            )
    }
}

extension View {
    func pressScale(_ scale: CGFloat = 0.97) -> some View {
        modifier(PressScaleModifier(scale: scale))
    }
}

// MARK: - Navigation Chrome

/// UIKit appearance for NavigationStack so pushes slide over the app background
/// instead of flashing black, and the back chevron stays a consistent dark color.
enum AppNavigationAppearance {
    static let backgroundUIColor = UIColor(
        red: 246 / 255,
        green: 245 / 255,
        blue: 242 / 255,
        alpha: 1
    )
    private static let tintUIColor = UIColor(
        red: 31 / 255,
        green: 30 / 255,
        blue: 27 / 255,
        alpha: 1
    )

    static func configure() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundUIColor
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: tintUIColor]
        appearance.largeTitleTextAttributes = [.foregroundColor: tintUIColor]

        let backButtonAppearance = UIBarButtonItemAppearance()
        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: tintUIColor]
        backButtonAppearance.highlighted.titleTextAttributes = [.foregroundColor: tintUIColor]
        backButtonAppearance.disabled.titleTextAttributes = [.foregroundColor: tintUIColor]
        appearance.backButtonAppearance = backButtonAppearance

        let navigationBar = UINavigationBar.appearance()
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactScrollEdgeAppearance = appearance
        navigationBar.tintColor = tintUIColor
    }
}

extension View {
    /// Practice flow screens: hide `UINavigationBar` and pin a non-adaptive back control.
    /// Scroll content (e.g. category gradient headers) must not live under the system bar —
    /// iOS still retints toolbar items there during appear transitions.
    func practiceFlowScreenChrome<Trailing: View>(
        title: String? = nil,
        @ViewBuilder trailing: @escaping () -> Trailing = { EmptyView() }
    ) -> some View {
        modifier(PracticeFlowScreenChromeModifier(title: title, trailing: trailing))
    }

    /// Apply to the root of each `NavigationStack` so stack pushes use the app background.
    func appNavigationHost() -> some View {
        background {
            AppColors.background.ignoresSafeArea()
            NavigationControllerBackgroundConfigurator()
        }
        .tint(AppColors.textPrimary)
    }

    /// Ensures edge swipe-back works when the navigation bar is hidden.
    func navigationSwipeBackEnabled() -> some View {
        background(NavigationInteractivePopEnabler())
    }

    /// Blocks edge swipe-back (for modal-style exits that use a close button).
    func navigationSwipeBackDisabled() -> some View {
        background(NavigationInteractivePopLocker())
    }

    /// Raised circular chrome for custom back/close controls on pushed screens.
    func circularNavigationButtonChrome(diameter: CGFloat = 46) -> some View {
        frame(width: diameter, height: diameter)
            .background(AppColors.surfaceRaised, in: Circle())
            .overlay {
                Circle()
                    .strokeBorder(AppColors.separator, lineWidth: 1)
            }
    }

    /// Trailing disclosure circle for tappable list rows (skills, history, scenarios).
    func rowDisclosureIndicatorChrome(diameter: CGFloat = 32) -> some View {
        frame(width: diameter, height: diameter)
            .background(AppColors.background, in: Circle())
            .overlay {
                Circle()
                    .strokeBorder(AppColors.separator.opacity(0.55), lineWidth: 1)
            }
    }
}

// MARK: - Navigation back button

struct NavigationBackButtonLabel: View {
    var body: some View {
        Image(systemName: "chevron.left")
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(AppColors.textPrimary)
            .circularNavigationButtonChrome()
    }
}

struct NavigationBackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            NavigationBackButtonLabel()
        }
        .buttonStyle(PressButtonStyle())
        .accessibilityLabel("Back")
    }
}

// MARK: - Practice flow top bar

private struct PracticeFlowTopBar<Trailing: View>: View {
    let title: String?
    let onBack: () -> Void
    @ViewBuilder let trailing: () -> Trailing

    var body: some View {
        ZStack {
            if let title {
                Text(title)
                    .font(AppFonts.title(18, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.82)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .accessibilityAddTraits(.isHeader)
            }

            HStack(alignment: .center, spacing: 0) {
                NavigationBackButton(action: onBack)

                Spacer(minLength: 0)

                Group {
                    trailing()
                }
                .frame(width: 46, height: 46, alignment: .trailing)
            }
        }
        .padding(.horizontal, AppSpacing.base)
        .padding(.bottom, AppSpacing.sm)
        .frame(maxWidth: .infinity)
        .background(AppColors.background)
    }
}

private struct PracticeFlowScreenChromeModifier<Trailing: View>: ViewModifier {
    let title: String?
    @ViewBuilder let trailing: () -> Trailing
    @Environment(\.dismiss) private var dismiss

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .safeAreaInset(edge: .top, spacing: 0) {
                PracticeFlowTopBar(title: title, onBack: { dismiss() }, trailing: trailing)
            }
            .navigationSwipeBackEnabled()
    }
}

// MARK: - Navigation controller background

/// Sets only the navigation controller container background (not every child UIView).
private struct NavigationControllerBackgroundConfigurator: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        NavigationControllerBackgroundHost()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

private final class NavigationControllerBackgroundHost: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = false
        view.backgroundColor = .clear
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.view.backgroundColor = AppNavigationAppearance.backgroundUIColor
    }
}

// MARK: - Navigation interactive pop

/// Allows the edge swipe when the nav bar is hidden (`interactivePopGestureRecognizer` defaults to off).
private final class NavigationInteractivePopGestureDelegate: NSObject, UIGestureRecognizerDelegate {
    weak var navigationController: UINavigationController?

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let navigationController else {
            return false
        }
        return navigationController.viewControllers.count > 1
    }
}

private struct NavigationInteractivePopEnabler: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        NavigationInteractivePopEnableHost()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        (uiViewController as? NavigationInteractivePopEnableHost)?.configureInteractivePop()
    }
}

private final class NavigationInteractivePopEnableHost: UIViewController {
    private let popGestureDelegate = NavigationInteractivePopGestureDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = false
        view.backgroundColor = .clear
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureInteractivePop()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureInteractivePop()
    }

    fileprivate func configureInteractivePop() {
        guard let navigationController else {
            return
        }
        popGestureDelegate.navigationController = navigationController
        guard let popGesture = navigationController.interactivePopGestureRecognizer else {
            return
        }
        popGesture.isEnabled = true
        popGesture.delegate = popGestureDelegate
    }
}

private struct NavigationInteractivePopLocker: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        NavigationInteractivePopLockHost()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

private final class NavigationInteractivePopLockHost: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}

// MARK: - Color Hex Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:  (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:  (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:  (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 200, 200, 200)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
