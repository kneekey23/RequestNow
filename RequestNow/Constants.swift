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
//https://e0rrchgsgb.execute-api.us-east-1.amazonaws.com/prod/get_event_id?event_code=691b
let API_ENDPOINT = "https://e0rrchgsgb.execute-api.us-east-1.amazonaws.com/prod/"
let API_KEY = "P2yy4ZmhCz15DxJsndejh8mAkeRXzmse1IjpbVVi"
let EVENT_DATA = API_ENDPOINT + "get_song_request_and_message_groups"
let DELETE_REQUEST = API_ENDPOINT + "delete_song_request_or_message_group"
let REGISTER_TOKEN = API_ENDPOINT + "register_device"
let EVENT_ID = API_ENDPOINT + "get_event_id"
let SEND_THANKYOU_NOTE = API_ENDPOINT + "send_thank_you"
let REPLY_REQUEST = API_ENDPOINT + "reply_message_group"
let LOGOUT = API_ENDPOINT + "logout"
let INFORM_UP_NEXT = API_ENDPOINT + "/inform_next_up"
let GET_RAFFLE_WINNER = API_ENDPOINT + "get_raffle_winner"

let UPDATE_REQUESTS = Notification.Name("updateRequests")

typealias CompletionHandler = (_ success: Bool) -> ()
