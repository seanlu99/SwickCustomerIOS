//
//  Constants.swift
//  Swick
//
//  Created by Sean Lu on 10/7/20.
//

import SwiftUI

// If DEVELOPMENT == true -> development environment
// If DEVELOPMENT == false && STAGING == true -> staging environment
// IF DEVELOPMENT == false && STAGING == false -> production environment
let DEVELOPMENT = true
let STAGING = true

let BACKEND_URL = DEVELOPMENT ? "http://localhost:8000" :
    (STAGING ? "https://swick-staging.herokuapp.com" : "https://swick-production.herokuapp.com")

let PUSHER_KEY = DEVELOPMENT ? "3ceb32ba705e55a518b8" :
    (STAGING ? "21ae4cf29046209f03f6" : "5e2d3e1693872ac3bf09")
let PUSHER_CLUSTER = "us2"

#if CUSTOMER
// Mock scanned string for QR code scanner while using simulator
let MOCK_SCANNED_STRING = "swick-1-6"

let STRIPE_PUBLIC_KEY = DEVELOPMENT ? "pk_test_YoEmowu4ykyrOgUO8dfmShpQ00ck79Hp8Q" :
    (STAGING ? "pk_test_YoEmowu4ykyrOgUO8dfmShpQ00ck79Hp8Q" : "pk_live_KAaBNmQFb8gxOEbqBWrCy7yu00WWwJySvp")
#endif
