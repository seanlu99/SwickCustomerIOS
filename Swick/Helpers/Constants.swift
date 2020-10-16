//
//  Constants.swift
//  Swick
//
//  Created by Sean Lu on 10/7/20.
//

// Set true for development environment, false for production environment
let DEVELOPMENT = true

// Backend URL
let BACKEND_URL = DEVELOPMENT ? "http://localhost:8000" : "https://swickapp.herokuapp.com"

#if CUSTOMER
// Mock scanned string for QR code scanner while using simulator
let MOCK_SCANNED_STRING = "swick-1-1"

let STRIPE_PUBLIC_KEY = "pk_test_YoEmowu4ykyrOgUO8dfmShpQ00ck79Hp8Q"
#endif
