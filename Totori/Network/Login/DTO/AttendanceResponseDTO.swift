//
//  AttendanceResponseDTO.swift
//  Totori
//
//  Created by 정윤아 on 4/18/26.
//

struct AttendanceResponseDTO: Decodable {
    let newlyAttended: Bool
    let totalAttendanceDays: Int
}
