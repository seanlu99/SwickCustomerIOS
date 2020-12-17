//
//  Constants.swift
//  Swick
//
//  Created by Sean Lu on 10/7/20.
//

import SwiftUI

// Set true for development environment, false for production environment
let DEVELOPMENT = true

let BACKEND_URL = DEVELOPMENT ? "http://localhost:8000" : "https://swickapp.herokuapp.com"

let PUSHER_KEY = DEVELOPMENT ? "3ceb32ba705e55a518b8" : "5e2d3e1693872ac3bf09"

// AWS cluster location for Pusher server (dev and prod cluster currently the same)
let PUSHER_CLUSTER = "us2"

#if CUSTOMER
// Mock scanned string for QR code scanner while using simulator
let MOCK_SCANNED_STRING = "swick-2-6"

let STRIPE_PUBLIC_KEY = DEVELOPMENT ? "pk_test_YoEmowu4ykyrOgUO8dfmShpQ00ck79Hp8Q" : "pk_live_KAaBNmQFb8gxOEbqBWrCy7yu00WWwJySvp"
#endif
