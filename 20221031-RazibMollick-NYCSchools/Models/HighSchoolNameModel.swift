//
//  HighSchoolNameModel.swift
//  20221031-RazibMollick-NYCSchools
//
//  Created by Razib Mollick on 10/30/22.
//

import Foundation

struct HighSchoolNameModel: Codable, Hashable {
    /// dbn can be used as the unique identifier
    var dbn: String
    var school_name: String
}
