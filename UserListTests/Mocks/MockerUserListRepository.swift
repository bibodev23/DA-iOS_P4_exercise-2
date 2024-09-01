//
//  MockerUserListRepository.swift
//  UserListTests
//
//  Created by Boualem Dahmane on 29/08/2024.
//

import Foundation
// Extracted f
func mockExecuteDataRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
    let sampleJSON = """
        {
            "results": [
                {
                    "name": {
                        "title": "Mr",
                        "first": "John",
                        "last": "Doe"
                    },
                    "dob": {
                        "date": "1990-01-01",
                        "age": 31
                    },
                    "picture": {
                        "large": "https://example.com/large.jpg",
                        "medium": "https://example.com/medium.jpg",
                        "thumbnail": "https://example.com/thumbnail.jpg"
                    }
                },
                {
                    "name": {
                        "title": "Ms",
                        "first": "Jane",
                        "last": "Smith"
                    },
                    "dob": {
                        "date": "1995-02-15",
                        "age": 26
                    },
                    "picture": {
                        "large": "https://example.com/large.jpg",
                        "medium": "https://example.com/medium.jpg",
                        "thumbnail": "https://example.com/thumbnail.jpg"
                    }
                }
            ]
        }
    """
    
    let data = sampleJSON.data(using: .utf8)!
    let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    return (data, response)
}
