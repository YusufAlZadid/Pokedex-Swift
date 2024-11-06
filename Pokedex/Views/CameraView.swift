import SwiftUI
import AVFoundation

struct CameraView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CameraViewModel()
    @State private var showCopiedAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Camera preview
                CameraPreviewView(session: viewModel.session)
                    .ignoresSafeArea()
                
                // Capture button and UI overlay
                VStack {
                    Spacer()
                    
                    if let image = viewModel.capturedImage {
                        // Show captured image and analysis
                        VStack(spacing: 16) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 300)
                            
                            if viewModel.isAnalyzing {
                                ProgressView("Analyzing Pokémon...")
                                    .foregroundColor(.white)
                            } else if let result = viewModel.analysisResult {
                                // Analysis Result Card
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text("Gemini's Analysis")
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Button(action: {
                                            UIPasteboard.general.string = result
                                            showCopiedAlert = true
                                            HapticFeedback.impact()
                                        }) {
                                            Image(systemName: "doc.on.doc")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    
                                    Text(result)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                }
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(15)
                                .padding(.horizontal)
                            }
                            
                            HStack(spacing: 20) {
                                Button(action: {
                                    viewModel.retake()
                                    HapticFeedback.impact()
                                }) {
                                    Label("Retake", systemImage: "camera.rotate")
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                }
                                .buttonStyle(.bordered)
                                
                                Button(action: {
                                    dismiss()
                                }) {
                                    Label("Done", systemImage: "checkmark")
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.7))
                    } else {
                        // Camera capture button
                        Button(action: {
                            viewModel.capturePhoto()
                            HapticFeedback.impact()
                        }) {
                            Circle()
                                .stroke(Color.white, lineWidth: 3)
                                .frame(width: 70, height: 70)
                                .overlay(
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 60, height: 60)
                                )
                        }
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("Pokémon Scanner")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .alert("Copied to Clipboard", isPresented: $showCopiedAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}

struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: CGRect.zero)
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            previewLayer.frame = uiView.bounds
        }
    }
} 