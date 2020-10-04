import UIKit
/// 1
var name = "Yurii"
for letter in name {
    print("Give me a \(letter)")
}

let letter = name[name.index(name.startIndex, offsetBy: 0)]// poly4im Y
// tože samoe 4to swerchy
extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

let letter2 = name[0]

///2
let password = "12345"
password.hasPrefix("123")
password.hasSuffix("456")

extension String {
    func delitingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else {
            return self
        }
        return String(self.dropFirst(prefix.count))
    }
    
    func delitingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else {
            return self
        }
        
        return String(self.dropLast(suffix.count))
    }
}

///3
let weather = "it's goin to rain"
print(weather.capitalized)

extension String {
    var capitalizeFirst: String {
        guard let firstLetter = self.first else {
            return ""
        }
        return firstLetter.uppercased() + self.dropFirst()
    }
}

///4
let input = "Swift is like Objective-C without the C"
input.contains("Swift")

let languages = ["Python", "Ruby", "Swift"]
languages.contains("Swift")

extension String {
    func containsAny(of array: [String] ) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        return false
    }
}

input.containsAny(of: languages)

languages.contains(where: input.contains)


//// NSAttribyteString
///5
let string = "This is a test string"

let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .backgroundColor: UIColor.red, .font: UIFont.boldSystemFont(ofSize: 36)]

let attributeString = NSAttributedString(string: string, attributes: attributes)

let attributedString = NSMutableAttributedString(string: string)

attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))

NSAttributedString.Key.strikethroughStyle


// add prefix
let addPrefix = "Car"

extension String {
    func withPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) {
            return self
        }
        
        return prefix.capitalizeFirst + self.lowercased()
    }
}
addPrefix.withPrefix("pen")

// check numeric
let numeric = "yurii has 22 year old"
extension String {
    func isNumeric() -> Bool {
        for char in self {
            if char.isNumber {
                return true
            }
        }
        return false
    }
}
numeric.isNumeric()

// separated String
let separated = "yurii\n has\n year\n old"
extension String {
    func lines() -> [String] {
        var array = [String]()
        for char in self {
            if char.isLetter {
                array.append(String(char))
            }
            
        }
        return array
    }
}
print(separated.lines())

///
extension Int {
    func times(_ closure: () -> Void) {
        guard self > 0 else {return}
        
        for _ in 0 ..< self {
            closure()
        }
    }
}
7.times {
    print("5")
}
///
var tests = ["yurii", "has", "yurii", "year", "old", "has"]

extension Array where Element: Comparable {
    mutating func remove(item: Element)  {
        if let element = self.firstIndex(of: item) {
            self.remove(at: element)
            
        }
    }
}
tests.remove(item: "yurii")
