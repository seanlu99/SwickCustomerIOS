//
//  Constants.swift
//  SwickServerIOS
//
//  Created by Sean Lu on 8/12/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import Foundation

// Set true for development environment, false for production environment
let DEVELOPMENT = false

// Server URL
let SERVER_URL = DEVELOPMENT ? "http://localhost:8000" : "https://swickapp.herokuapp.com"

// Django -> Applications client_id
let CLIENT_ID = DEVELOPMENT ? "u477FLg4uiW1h7sitAdNERhQadzDtreHgDouWDFR" : "vdc3Lf5TkZLSS1lxe3duFhsfT3XqOWqQX2MtPeXo"

// Django -> Applications client_secret
let CLIENT_SECRET = DEVELOPMENT ?  "zqnOA9ONGgrjVxASCLMGZWlmGGJt3Vo0P694rC3L2kMfG9NuSf89E9pslkCpHbT0P5fIJZEElged3XDrQiEednSxh6nfjjNVu3HQYjPbKiMPn5GiHmdW0rxBpQYRUdki" : "QURxttv00m3SA3c5yuzf4WyLz8SFdvk2ycYUHq9x69SzhQeHGd2Mwo3EbT80oQhfXenYi6hxX2MJ4vtNVj7ewoSOmZ8I4EsRoNJkg2o5RFCWEnIAywdL7tk4rffNEZnK"
