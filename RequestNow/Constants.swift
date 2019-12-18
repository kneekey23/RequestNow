//
//  Constants.swift
//  RequestNow
//
//  Created by Nicole Klein on 7/8/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import Foundation

let blueColor = "25a3d1"
let greyColor = "aaa"
let darkGreyColor = "bababa"

let HEADER = [
    "Content-Type": "application/json; charset=utf-8"
]

let API_ENDPOINT = "https://9f7yr4mpnf.execute-api.us-east-1.amazonaws.com/dev/"
let EVENT_DATA = API_ENDPOINT + "get_requests"
let DELETE_REQUEST = API_ENDPOINT + "delete_request"
let REGISTER_TOKEN = API_ENDPOINT + "sns_token_exchange"
let EVENT_ID = API_ENDPOINT + "get_event_id"

let UPDATE_REQUESTS = Notification.Name("updateRequests")

typealias CompletionHandler = (_ success: Bool) -> ()
