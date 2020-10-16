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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isScanning = true
    @State var scannedRestaurant = Restaurant(
        id: 0,
        name: "",
        address: "",
        imageUrl: ""
    )
    @State var scannedTable: Int = 0
    @State var showCartView = false
    @State var showInvalidAlert = false
    @Binding var tabIndex: Int
    
    func loadRestaurant(_ restaurantId: Int, _ table: Int) {
        API.getRestaurant(restaurantId) { json in
            if (json["status"] == "success") {
                let rest = json["restaurant"]
                scannedRestaurant = Restaurant(
                    id: rest["id"].int ?? 0,
                    name: rest["name"].string ?? "",
                    address: rest["address"].string ?? "",
                    imageUrl: (rest["image"].string ?? "")
                )
                scannedTable = table
                showCartView = true
            }
            else if (json["status"] == "restaurant_does_not_exist") {
                showInvalidAlert = true
            }
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
                            showInvalidAlert = true
                            return
                        }
                        let swickString = scannedArray[0]
                        let restaurantId = Int(scannedArray[1])
                        let table = Int(scannedArray[2])
                        if swickString != "swick"
                            || restaurantId == nil
                            || table == nil {
                            showInvalidAlert = true
                            return
                        }
                        loadRestaurant(restaurantId!, table!)
                    }
                }
            }
            .navigationBarTitle(Text("Scan"))
            .onAppear(perform: {isScanning = true})
            .background(
                // Navigation link to cart view
                NavigationLink(
                    destination: CartView(
                        tabIndex: $tabIndex,
                        restaurant: scannedRestaurant,
                        table: scannedTable
                    ),
                    isActive: $showCartView
                ) { }
            )
            .alert(isPresented: $showInvalidAlert) {
                let okButton = Alert.Button.default(Text("Ok")) {
                    isScanning = true
                }
                return Alert(
                    title: Text("Error"),
                    message: Text("Invalid QR code. Please try again."),
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
