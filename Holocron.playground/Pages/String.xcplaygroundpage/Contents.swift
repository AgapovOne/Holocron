//: [Previous](@previous)

import Foundation

private extension String {
    var notEmpty: String? {
        return isEmpty ? nil : self
    }
}

var str = "Hello, playground"
var str2 = ""

str.notEmpty
str2.notEmpty

//: [Next](@next)
