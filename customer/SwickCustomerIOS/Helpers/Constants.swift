//
//  Constants.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/13/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import Foundation

// Set true for development environment, false for production environment
let DEVELOPMENT = true

// If in development environement, set the following string for QR code scanning override
let SCANNED_STRING = "swick-1-1"

// Backend URL
let BACKEND_URL = DEVELOPMENT ? "http://localhost:8000" : "https://swickapp.herokuapp.com"

let STRIPE_PUBLIC_KEY = "pk_test_YoEmowu4ykyrOgUO8dfmShpQ00ck79Hp8Q"
