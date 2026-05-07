import SwiftUI

struct CustomScenarioEditorScreen: View {
    @Bindable var viewModel: PracticeFlowViewModel

    @State private var name: String = ""
    @State private var prompt: String = ""
    @State private var selectedPersonaID: PersonaID?
    @State private var hasPopulatedFromExisting: Bool = false
    @State private var appeared: Bool = false
    @State private var showDeleteConfirm: Bool = false
    @FocusState private var focusedField: Field?

    private enum Field: Hashable {
        case name
        case prompt
    }

    private let columns = [
        GridItem(.flexible(), spacing: AppSpacing.md),
        GridItem(.flexible(), spacing: AppSpacing.md),
    ]

    private var isEditing: Bool {
        viewModel.editingCustomScenarioID != nil
    }

    private var existingScenario: CustomScenario? {
        guard let id = viewModel.editingCustomScenarioID else { return nil }
        return viewModel.customScenarioStore.scenario(with: id)
    }

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var trimmedPrompt: String {
        prompt.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canSave: Bool {
        !trimmedName.isEmpty
            && !trimmedPrompt.isEmpty
            && selectedPersonaID != nil
            && trimmedName.count <= CustomScenarioLimits.nameLimit
            && trimmedPrompt.count <= CustomScenarioLimits.promptLimit
    }

    private var saveButtonTitle: String {
        isEditing ? "Save Changes" : "Create Scenario"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.xl) {
                introBanner
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.05), value: appeared)

                nameSection
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.1), value: appeared)

                promptSection
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.15), value: appeared)

                personaSection
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.2), value: appeared)

                if isEditing {
                    deleteButton
                        .opacity(appeared ? 1 : 0)
                        .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.25), value: appeared)
                }
            }
            .padding(.horizontal, AppSpacing.base)
            .padding(.top, AppSpacing.base)
            .padding(.bottom, 120)
        }
        .background(AppColors.background)
        .navigationTitle(isEditing ? "Edit Scenario" : "Create Scenario")
        .navigationBarTitleDisplayMode(.inline)
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) {
            saveButton
                .padding(.horizontal, AppSpacing.base)
                .padding(.vertical, AppSpacing.md)
                .background(AppColors.background)
                .opacity(appeared ? 1 : 0)
                .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.3), value: appeared)
        }
        .alert("Delete this scenario?", isPresented: $showDeleteConfirm) {
            Button("Delete", role: .destructive) {
                handleDelete()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will remove your saved custom scenario. You can always create a new one.")
        }
        .onAppear {
            populateInitialValuesIfNeeded()
            appeared = true
        }
    }

    // MARK: - Sections

    private var introBanner: some View {
        HStack(alignment: .top, spacing: AppSpacing.md) {
            ZStack {
                Circle()
                    .fill(AppColors.surface)
                    .frame(width: 44, height: 44)

                Image(systemName: "sparkles")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(AppColors.primary)
            }
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(isEditing ? "Refine your scenario" : "Design your own practice")
                    .font(AppFonts.title(16))
                    .foregroundStyle(AppColors.textPrimary)

                Text(isEditing
                    ? "Update what you want to rehearse, then save it for next time."
                    : "Describe the conversation you want to rehearse. Be as specific as you can.")
                    .font(AppFonts.body(13))
                    .foregroundStyle(AppColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(AppSpacing.base)
        .background {
            RoundedRectangle(cornerRadius: AppRadius.xl)
                .fill(AppColors.primarySubtle)
        }
    }

    private var nameSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            sectionHeader(
                title: "Scenario Name",
                trailing: "\(trimmedName.count)/\(CustomScenarioLimits.nameLimit)"
            )

            ZStack(alignment: .leading) {
                if name.isEmpty {
                    Text("e.g., Asking my manager for a raise")
                        .font(AppFonts.body(15))
                        .foregroundStyle(AppColors.textTertiary)
                        .padding(.horizontal, AppSpacing.base)
                        .allowsHitTesting(false)
                }

                TextField("", text: $name)
                    .font(AppFonts.body(15))
                    .foregroundStyle(AppColors.textPrimary)
                    .focused($focusedField, equals: .name)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .prompt }
                    .padding(.horizontal, AppSpacing.base)
                    .onChange(of: name) { _, newValue in
                        if newValue.count > CustomScenarioLimits.nameLimit {
                            name = String(newValue.prefix(CustomScenarioLimits.nameLimit))
                        }
                    }
            }
            .frame(minHeight: 52)
            .background {
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .fill(AppColors.surface)
            }
            .overlay {
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .strokeBorder(
                        focusedField == .name ? AppColors.primary : AppColors.separator,
                        lineWidth: focusedField == .name ? 1.5 : 1
                    )
                    .animation(.easeInOut(duration: 0.15), value: focusedField)
            }
        }
    }

    private var promptSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            sectionHeader(
                title: "The Prompt",
                trailing: "\(prompt.count)/\(CustomScenarioLimits.promptLimit)"
            )

            ZStack(alignment: .topLeading) {
                if prompt.isEmpty {
                    Text("e.g., I'm asking my boss for a deadline extension on a project I'm behind on…")
                        .font(AppFonts.body(15))
                        .foregroundStyle(AppColors.textTertiary)
                        .padding(.horizontal, AppSpacing.base)
                        .padding(.top, 14)
                        .allowsHitTesting(false)
                }

                TextEditor(text: $prompt)
                    .font(AppFonts.body(15))
                    .foregroundStyle(AppColors.textPrimary)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .focused($focusedField, equals: .prompt)
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.vertical, AppSpacing.sm)
                    .onChange(of: prompt) { _, newValue in
                        if newValue.count > CustomScenarioLimits.promptLimit {
                            prompt = String(newValue.prefix(CustomScenarioLimits.promptLimit))
                        }
                    }
            }
            .frame(minHeight: 140)
            .background {
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .fill(AppColors.surface)
            }
            .overlay {
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .strokeBorder(
                        focusedField == .prompt ? AppColors.primary : AppColors.separator,
                        lineWidth: focusedField == .prompt ? 1.5 : 1
                    )
                    .animation(.easeInOut(duration: 0.15), value: focusedField)
            }
        }
    }

    private var personaSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            sectionHeader(title: "Select Persona", trailing: nil)

            LazyVGrid(columns: columns, spacing: AppSpacing.md) {
                ForEach(Persona.all) { persona in
                    CustomPersonaCard(
                        persona: persona,
                        isSelected: selectedPersonaID == persona.id
                    )
                    .onTapGesture {
                        focusedField = nil
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedPersonaID = persona.id
                        }
                    }
                }
            }
        }
    }

    private var deleteButton: some View {
        Button(role: .destructive) {
            showDeleteConfirm = true
        } label: {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: "trash")
                    .font(.system(size: 14, weight: .semibold))
                Text("Delete Scenario")
                    .font(AppFonts.label(15, weight: .semibold))
            }
            .foregroundStyle(AppColors.error)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.base)
            .background {
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .fill(AppColors.errorBg)
            }
        }
        .buttonStyle(PressButtonStyle())
    }

    private var saveButton: some View {
        PrimaryButton(title: saveButtonTitle) {
            handleSave()
        }
        .opacity(canSave ? 1 : 0.5)
        .disabled(!canSave)
        .animation(.easeInOut(duration: 0.15), value: canSave)
    }

    // MARK: - Helpers

    private func sectionHeader(title: String, trailing: String?) -> some View {
        HStack {
            Text(title.uppercased())
                .font(AppFonts.label(11, weight: .bold))
                .foregroundStyle(AppColors.textSecondary)
                .tracking(0.6)

            Spacer()

            if let trailing {
                Text(trailing)
                    .font(AppFonts.label(11, weight: .medium))
                    .foregroundStyle(AppColors.textTertiary)
            }
        }
    }

    private func populateInitialValuesIfNeeded() {
        guard !hasPopulatedFromExisting else { return }
        hasPopulatedFromExisting = true

        if let existing = existingScenario {
            name = existing.name
            prompt = existing.prompt
            selectedPersonaID = existing.personaID
        } else {
            selectedPersonaID = Persona.all.first?.id
        }
    }

    private func handleSave() {
        guard canSave, let personaID = selectedPersonaID else { return }
        focusedField = nil

        if let editingID = viewModel.editingCustomScenarioID {
            viewModel.updateCustomScenario(
                id: editingID,
                name: trimmedName,
                prompt: trimmedPrompt,
                personaID: personaID
            )
        } else {
            viewModel.createCustomScenarioAndStart(
                name: trimmedName,
                prompt: trimmedPrompt,
                personaID: personaID
            )
        }
    }

    private func handleDelete() {
        guard let editingID = viewModel.editingCustomScenarioID else { return }
        viewModel.deleteCustomScenario(id: editingID)
    }
}

// MARK: - Persona Card

private struct CustomPersonaCard: View {
    let persona: Persona
    let isSelected: Bool

    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            ZStack(alignment: .topTrailing) {
                PersonaAvatarView(name: persona.name, size: 64)
                    .overlay {
                        if isSelected {
                            Circle()
                                .strokeBorder(AppColors.primary, lineWidth: 2.5)
                        }
                    }
                    .scaleEffect(isSelected ? 1.04 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)

                if isSelected {
                    ZStack {
                        Circle()
                            .fill(AppColors.primary)
                            .frame(width: 22, height: 22)
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .offset(x: 4, y: -4)
                    .transition(.scale.combined(with: .opacity))
                }
            }

            Text(persona.name)
                .font(AppFonts.title(15))
                .foregroundStyle(AppColors.textPrimary)

            DifficultyBadge(difficulty: persona.difficulty)

            Text(persona.tagline)
                .font(AppFonts.body(12))
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2, reservesSpace: true)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, AppSpacing.base)
        .padding(.horizontal, AppSpacing.sm)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .fill(AppColors.surface)
                .subtleShadow()
        }
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .strokeBorder(
                    isSelected ? AppColors.primary : Color.clear,
                    lineWidth: 2
                )
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

#Preview("Create") {
    NavigationStack {
        CustomScenarioEditorScreen(viewModel: PracticeFlowViewModel())
    }
}

#Preview("Edit") {
    NavigationStack {
        CustomScenarioEditorScreen(
            viewModel: {
                let store = CustomScenarioStore(
                    userDefaults: UserDefaults(suiteName: "preview.customScenario")!,
                    storageKey: "preview.customScenarios"
                )
                let saved = store.upsert(
                    CustomScenario(
                        name: "Asking for a raise",
                        prompt: "I'm asking my manager for a raise after a strong year. I want to anchor on impact, not just hours.",
                        personaIDRawValue: Persona.all[1].id.rawValue
                    )
                )
                let vm = PracticeFlowViewModel(customScenarioStore: store)
                vm.editingCustomScenarioID = saved.id
                return vm
            }()
        )
    }
}
