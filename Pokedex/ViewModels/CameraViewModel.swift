import AVFoundation
import UIKit
import GoogleGenerativeAI

class CameraViewModel: NSObject, ObservableObject {
    @Published var capturedImage: UIImage?
    @Published var isAnalyzing = false
    @Published var analysisResult: String?
    
    let session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    private let model = GenerativeModel(name: "gemini-1.5-flash-002", apiKey: APIKey.default)
    
    override init() {
        super.init()
        setupCamera()
    }
    
    private func setupCamera() {
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            return
        }
        
        if session.canAddInput(input) && session.canAddOutput(output) {
            session.addInput(input)
            session.addOutput(output)
            
            DispatchQueue.global(qos: .background).async {
                self.session.startRunning()
            }
        }
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
    
    func retake() {
        capturedImage = nil
        analysisResult = nil
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
        }
    }
    
    private func analyzePokemon(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        isAnalyzing = true
        
        Task {
            do {
                let prompt = """
                    What is this Pokémon? Please provide:
                    1. Name
                    2. Type(s)
                    3. Brief description
                    
                    If no Pokémon is detected, simply respond with "No Pokémon detected in this image."
                    """
                
                // Based on the documentation example
                let response = try await model.generateContent(prompt, image)
                
                await MainActor.run {
                    self.analysisResult = response.text
                    self.isAnalyzing = false
                }
            } catch {
                await MainActor.run {
                    self.analysisResult = "Error analyzing image: \(error.localizedDescription)"
                    self.isAnalyzing = false
                }
            }
        }
    }
}

extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            return
        }
        
        DispatchQueue.main.async {
            self.capturedImage = image
            self.session.stopRunning()
            self.analyzePokemon(image: image)
        }
    }
}
