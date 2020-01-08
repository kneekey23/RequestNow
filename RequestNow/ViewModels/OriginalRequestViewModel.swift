//
//  OriginalRequestViewModel.swift
//  RequestNow
//
//  Created by Nicole Klein on 1/5/20.
//  Copyright © 2020 Confir Inc. All rights reserved.
//

import Combine
import SwiftUI

final class OriginalRequestViewModel: ObservableObject {
    @Published var original: String = ""
    @Published var name: String = ""
    @Published var id: UUID  = UUID()
    
    private let originalRequest: OriginalRequest
    
    init(originalRequest: OriginalRequest) {
        self.originalRequest = originalRequest
        setUpBindings()
    }
    
    func setUpBindings() {
        original = originalRequest.original
        id = originalRequest.id
        name = originalRequest.name ?? ""
    }
        
}
