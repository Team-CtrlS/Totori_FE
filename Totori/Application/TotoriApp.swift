//
//  TotoriApp.swift
//  Totori
//
//  Created by 정윤아 on 2/8/26.
//

import SwiftUI

@main
struct TotoriApp: App {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("userRole") private var userRole: String = ""
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isLoggedIn {
                    if userRole == "CHILD" {
                        NavigationStack {
                            MainView()
                        }
                    } else if userRole == "PARENT" {
                        NavigationStack {
                            WeeklyReportView()
                        }
                    } else {
                        Text("권한 오류: \(userRole)")
                    }
                } else {
                    StartView()
                }
            }
        }
    }
}
