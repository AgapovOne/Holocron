//: [Previous](@previous)

import Foundation

private extension String {
    var notEmpty: String? {
        return isEmpty ? nil : self
    }
}

var str = "Hello, playground"
var str2 = ""
var str3: String?

str.notEmpty
str2.notEmpty
str3?.notEmpty

//: [Next](@next)
