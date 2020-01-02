//
//  RequestCellViewModel.swift
//  RequestNow
//
//  Created by Nicole Klein on 1/1/20.
//  Copyright © 2020 Confir Inc. All rights reserved.
//

import Combine
import SwiftUI

final class RequestCellViewModel: ObservableObject {

    @Published var time: String = ""
    @Published var songName: String = ""
    @Published var artist: String = ""
    @Published var originalMessages: [String] = []
    @Published var count: String = ""
    @Published var id: String = ""
   
    private let request: Request
    
    init(request: Request) {
        self.request = request
        setUpBindings()
    }
    
    func setUpBindings() {
        time = request.timeOfRequest.toTime()
        songName = request.songName ?? ""
        artist = request.artist ?? ""
        originalMessages = request.originalRequests
        count = request.count
        id = request.id
    }
}
