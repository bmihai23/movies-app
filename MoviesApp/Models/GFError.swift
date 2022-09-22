//
//  GFError.swift
//  MoviesApp
//
//  Created by Mihai Bolojan on 2022-06-24.
//

import Foundation

enum GFError: String, Error {
    
    case invalidURL = "Unable to complete your request."
    case invalidData = "The data received from the server was invalid."
    case invalidResponse = "Invalid Response from the server."
}
