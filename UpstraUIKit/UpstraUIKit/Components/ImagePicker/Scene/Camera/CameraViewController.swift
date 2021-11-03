// The MIT License (MIT)
//
// Copyright (c) 2019 Joakim Gyllström
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

//import UIKit
//import AVFoundation
//
//class CameraViewController: UIViewController {
//    private let captureSession = AVCaptureSession()
//    private let previewView = CameraPreviewView()
//    private let captureSessionQueue = DispatchQueue(label: "session queue")
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        previewView.session = captureSession
//        previewView.frame = view.bounds
//        previewView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.addSubview(previewView)
//        
//        requestAuthorization()
//        setupSession()
//    }
//
//    private func requestAuthorization() {
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//        case .authorized:
//            break
//        case .notDetermined:
//            captureSessionQueue.suspend()
//            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] granted in
//                if granted {
//                    self?.captureSessionQueue.resume()
//                } else {
//                    DispatchQueue.main.async {
//                        self?.presentAlertController()
//                    }
//                }
//            })
//        case .denied, .restricted:
//            DispatchQueue.main.async {
//                self.presentAlertController()
//            }
//        }
//    }
//    
//    private func presentAlertController() {
//        let alertController = UIAlertController (title: AmityUIKitManagerInternal.shared.cameraPermissionDeniedText, message: "", preferredStyle: .alert)
//
//        let settingsAction = UIAlertAction(title: "OK", style: .default) { (_) -> Void in
//
//            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
//                return
//            }
//
//            if UIApplication.shared.canOpenURL(settingsUrl) {
//                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                    print("Settings opened: \(success)") // Prints true
//                })
//            }
//        }
//        alertController.addAction(settingsAction)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
//        alertController.addAction(cancelAction)
//
//        self.present(alertController, animated: true, completion: nil)
//    }
//
//    private func setupSession() {
//        captureSessionQueue.async {
//
//        }
//    }
//}
