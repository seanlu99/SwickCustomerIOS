//
//  ScanView.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//

import SwiftUI
import CarBode
import AVFoundation

struct ScanView: View {
    // Initial
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isWaiting = false
    @Binding var tabIndex: Int
    // Navigation
    @State var showCartView = false
    // Alerts
    @State var showAlert = false
    @State var alertMessage = ""
    // Properties
    @State var isScanning = true
    @State var scannedRestaurant = Restaurant()
    @State var scannedRequestOptions = [RequestOption]()
    @State var scannedTable: Int = 0
   
    func loadRestaurant(_ restaurantId: Int, _ table: Int) {
        isWaiting = true
        API.getRestaurant(restaurantId) { json in
            if (json["status"] == "success") {
                // Get restaurant
                let restJson = json["restaurant"]
                // Get request options
                var requestOptions = [RequestOption]()
                let optionJsonList = json["request_options"].array ?? []
                for optionJson in optionJsonList {
                    requestOptions.append(RequestOption(optionJson))
                }
                scannedRestaurant = Restaurant(restJson)
                scannedRequestOptions = requestOptions
                scannedTable = table
                showCartView = true
            }
            else if (json["status"] == "restaurant_does_not_exist") {
                alertMessage = "Invalid QR code. Please try again."
                showAlert = true
            }
            else {
                alertMessage = "Failed to load restaurant. Please try again."
                showAlert = true
            }
            isWaiting = false
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if isScanning {
                    CBScanner(
                        supportBarcode: .constant([.qr]),
                        scanInterval: .constant(1.0),
                        mockBarCode: .constant(BarcodeData(value: MOCK_SCANNED_STRING, type: .qr))
                    ) {
                        isScanning = false
                        // Check if scanned string is valid
                        // Expected: "swick-<restaurantId>-<table>"
                        let scannedString = $0.value
                        let scannedArray = scannedString.components(separatedBy: "-")
                        if scannedArray.count != 3 {
                            alertMessage = "Invalid QR code. Please try again."
                            showAlert = true
                            return
                        }
                        let swickString = scannedArray[0]
                        let restaurantId = Int(scannedArray[1])
                        let table = Int(scannedArray[2])
                        if swickString != "swick"
                            || restaurantId == nil
                            || table == nil {
                            alertMessage = "Invalid QR code. Please try again."
                            showAlert = true
                            return
                        }
                        loadRestaurant(restaurantId!, table!)
                    }
                }
            }
            .navigationBarTitle(Text("Scan"))
            .onAppear(perform: {isScanning = true})
            .waitingView($isWaiting)
            .background(
                // Navigation link to cart view
                NavigationLink(
                    destination: CartView(
                        tabIndex: $tabIndex,
                        restaurant: scannedRestaurant,
                        requestOptions: scannedRequestOptions,
                        table: scannedTable
                    ),
                    isActive: $showCartView
                ) { }
            )
            .alert(isPresented: $showAlert) {
                let okButton = Alert.Button.default(Text("Ok")) {
                    isScanning = true
                }
                return Alert(
                    title: Text("Error"),
                    message: Text(alertMessage),
                    dismissButton: okButton
                )
            }
        }
    }
}

struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        ScanView(tabIndex: .constant(1))
            .environmentObject(UserData())
    }
}
