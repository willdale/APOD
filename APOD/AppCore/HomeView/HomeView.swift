import Library
import class Networking.NetworkManager
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    
    init(networkManager: NetworkManager) {
        self._viewModel = StateObject(wrappedValue: HomeViewModel(networkManager: networkManager))
    }
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.viewState {
                case .loading:
                    LoadingView()
                        .task { await viewModel.fetchAPOD() }
                case .ideal(let apod):
                    IdealView(apod: apod)
                case .error:
                    ErrorView()
                        .refreshable { await viewModel.fetchAPOD() }
                }
            }
            .onChange(of: viewModel.date) { _ in
                Task { await viewModel.fetchAPOD() }
            }
            .sheet(isPresented: $viewModel.shouldShouldDateSelection) {
                DatePickerView()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.shouldShouldDateSelection = true
                    } label: {
                        Label("Date", systemImage: "calendar")
                    }
                    .accessibilityLabel(Text("Date Selection"))
                    .accessibilityHint(Text("Double Tap to open date selection"))
                }
            }
            .environmentObject(viewModel)
        }
    }
    
    private struct LoadingView: View {
        var body: some View {
            ProgressView()
                .progressViewStyle(.circular)
                .foregroundStyle(Color.primary)
        }
    }
    
    private struct IdealView: View {
        let apod: HomeViewModel.APOD
        
        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    MediaView(apod: apod)
                    HStack {
                        Spacer()
                        if let copyright = apod.copyright {
                            Text("Copyright: \(copyright)")
                                .font(.footnote)
                                .padding(.trailing)
                                .accessibilityIdentifier("copyright")
                        }
                    }
                    
                    Text(apod.title)
                        .font(.title)
                        .padding([.horizontal, .top])
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityIdentifier("title")
                    Text(apod.date, format: .dateLong)
                        .font(.footnote)
                        .padding()
                        .accessibilityIdentifier("date")
                    Text(apod.explanation)
                        .font(.body)
                        .padding(.horizontal)
                        .accessibilityIdentifier("explanation")
                }
            }
            .navigationTitle(Text("APOD"))
        }
    }
    
    private struct MediaView: View {
        let apod: HomeViewModel.APOD
        
        var body: some View {
            switch apod.mediaType {
            case .image:
                AsyncImage(url: apod.mediaURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .accessibilityAddTraits(.isImage)
                        .accessibilityIgnoresInvertColors()
                } placeholder: {
                    Rectangle()
                        .foregroundStyle(Color.gray)
                        .frame(height: 250)
                }
            case .video:
                CustomWebView(url: apod.mediaURL)
                    .frame(idealHeight: 400, maxHeight: 400)
            }
        }
    }
    
    private struct DatePickerView: View {
        @Environment(\.dismiss) private var dismiss
        @EnvironmentObject private var viewModel: HomeViewModel
        @State private var selectedDate: Date = .now
        
        var body: some View {
            NavigationStack {
                ScrollView {
                    DatePicker("Date Picker", selection: $selectedDate, in: viewModel.allowableDateRange(), displayedComponents: .date)
                        .datePickerStyle(.graphical)
                }
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            viewModel.date = selectedDate
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", role: .cancel) {
                            dismiss()
                        }
                    }
                }
                .onAppear {
                    selectedDate = viewModel.date
                }
            }
        }
    }
    
    private struct ErrorView: View {
        @EnvironmentObject private var viewModel: HomeViewModel
        
        var body: some View {
            ScrollView {
                VStack {
                    Text("Error")
                        .font(.title2)
                        .padding(.top)
                    Text("An error occored please try again or select another day")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button("Retry") {
                    Task { await viewModel.fetchAPOD() }
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}
