//
//  FError.swift
//  Diary of feelings - drop your feelings according to the cloud village
//
//  Created by dan phi on 24/05/2023.
//

import Foundation
struct ErrorResponse: Codable {
    let message: String?
    let errorCode: String?

    private enum CodingKeys: String, CodingKey {
        case message
        case errorCode = "error_code"
    }
}

enum FError: Error, Equatable {
    case noInternet
    case knownError(errorCode: String)
    case serialization
    case underMaintenance
    case unknownError
    case explicitlyCancelled
    case unauthenticated

    var description: String {
        switch self {
        case .noInternet:
            return "There is no internet connection.".localized
        case let .knownError(errorCode):
            return  "Unknown error." //AppString.getErrorMessage(for: errorCode) ??
        case .serialization:
            return "Please try again later.".localized
        case .underMaintenance:
            return "The app is under maintenance, we are sorry for this inconvenience.".localized
        case .explicitlyCancelled:
            return "The request is canceled".localized
        case .unknownError:
            return "We are facing difficulty, please try again later.".localized
        case .unauthenticated:
            return "Your login session has been ended.".localized
        }
    }

    var localizedDescription: String { description.localized }
}
