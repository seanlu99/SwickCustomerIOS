//
//  ScanVC.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/31/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import AVFoundation
import UIKit

class ScanVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    let activityIndicator = UIActivityIndicatorView()
    
    // Restaurant scanned
    var restaurant: Restaurant?
    // Table scanned
    var table: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Reset cart
        Cart.shared.reset()
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        //dismiss(animated: true)
    }
    
    // When QR code is found
    func found(code: String) {
        // Alert for invalid QR code error
        // "Ok" button restarts scanning
        let alertView = UIAlertController(
            title: "Error",
            message: "Invalid QR code. Please try scanning again.",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            self.captureSession.startRunning()
        }
        alertView.addAction(okAction)
        
        // Expected: "swick-<restaurantId>-<table>"
        let codeArray = code.components(separatedBy: "-")
        let swickString = codeArray[0]
        let restaurantId = Int(codeArray[1])
        table = Int(codeArray[2])
        if swickString != "swick" || restaurantId == nil || table == nil {
            self.present(alertView, animated: true, completion: nil)
        }
        else {
            // Show activity indicator while loading data
            Helper.showActivityIndicator(self.activityIndicator, view)
            
            // Load restaurant from API call
            APIManager.shared.getRestaurant(restaurantId: restaurantId!) { json in
                if (json["status"] == "success") {
                    self.restaurant = Restaurant(json: json["restaurant"])
                    self.performSegue(withIdentifier: "ScanToCart", sender: self)
                }
                else if (json["status"] == "restaurant_does_not_exist") {
                    self.present(alertView, animated: true, completion: nil)
                }
                else {
                    Helper.alert("Error", "Failed to get restaurant. Please restart app and try again.", self)
                }
                // Hide activity indicator when finished loading data
                Helper.hideActivityIndicator(self.activityIndicator)
            }
        }
    }
    
    // Send restaurant object to cart VC after scanning
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ScanToCart" {
            let cartVC = segue.destination as! CartVC
            cartVC.restaurant = restaurant
            cartVC.table = table
        }
    }
}
