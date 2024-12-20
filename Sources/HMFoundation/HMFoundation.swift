//
//  HMFoundation.swift
//
//
//  Created by 松本青空 on 2018/10/10.
//  Copyright © 2018年 松本青空. All rights reserved.
//
import Foundation

public extension CustomStringConvertible {
    
    /// Writes the textual representations of the item into the standard
    /// output.
    func printed() -> Self {
        print(self)
        return self
    }
}

/// Writes a newline character into the standard output.
public func printIndex() {
    print("\n")
}

/// Writes the line number into the standard output.
public func printLine(_ line: Int = #line) {
    print(line)
}

/// Writes the textual representations of the given items into the standard
/// output.
///
/// You can pass zero or more items to the `print(_:separator:terminator:)`
/// function. The textual representation for each item is the same as that
/// obtained by calling `String(item)`. The following example prints a string,
/// a closed range of integers, and a group of floating-point values to
/// standard output:
///
///     print("One two three four five")
///     // Prints "One two three four five"
///
///     print(1...5)
///     // Prints "1...5"
///
///     print(1.0, 2.0, 3.0, 4.0, 5.0)
///     // Prints "1.0 2.0 3.0 4.0 5.0"
///
/// To print the items separated by something other than a space, pass a string
/// as `separator`.
///
///     print(1.0, 2.0, 3.0, 4.0, 5.0, separator: " ... ")
///     // Prints "1.0 ... 2.0 ... 3.0 ... 4.0 ... 5.0"
///
/// The output from each call to `print(_:separator:terminator:)` includes a
/// newline by default. To print the items without a trailing newline, pass an
/// empty string as `terminator`.
///
///     for n in 1...5 {
///         print(n, terminator: "")
///     }
///     // Prints "12345"
///
/// - Parameters:
///   - items: Zero or more items to print.
///   - separator: A string to print between each item. The default is a single
///     space (`" "`).
///   - terminator: The string to print after all items have been printed. The
///     default is a newline (`"\n"`).

/// Writes the textual representations of the given items into the standard
/// output as the following format.
/// The separator is a comma and a space.
/// The terminator is a newline.
/// - Parameters:
///  - items: Zero or more items to print.
public func HMPrint(_ items: Any...) {
    var initial = true
    for item in items {
        if initial {
            initial = false
        } else {
            print(", ", terminator: "")
        }
        switch item {/*
             case let it as SimpleCGRect:
             print(CGRect(sRect: it), terminator: "")*/
        default:
            print(item, terminator: "")
        }
    }
    print("")
}

/// Side is a type that represents the four sides of a rectangle.
/// - right: The right side of a rectangle.
/// - up: The up side of a rectangle.
/// - left: The left side of a rectangle.
/// - low: The low side of a rectangle.
public enum Side {
    case right,up,left,low
}

/// Place is a type that represents the ten places of a rectangle.
/// - previous: The previous place of a rectangle.
/// - center: The center of a rectangle.
/// - upperRight: The upper right of a rectangle.
/// - up: The up of a rectangle.
/// - upperLeft: The upper left of a rectangle.
/// - Left: The left of a rectangle.
/// - lowerLeft: The lower left of a rectangle.
/// - low: The low of a rectangle.
/// - lowerRight: The lower right of a rectangle.
/// - inner: The inner of a rectangle.
/// - next: The next place of a rectangle.
///
/// The following figure shows the places in a rectangle.
/// ```
/// upperLeft     up     upperRight
/// Left        center
/// lowerLeft     low    lowerRight
/// ```
///
/// The following figure shows the places of a rectangle.
/// ```
///           ┌─────────┐
/// previous  │  inner  │      next
///           └─────────┘
/// ```
public enum Place: Int {
    case previous,center,upperRight,up,upperLeft,Left,lowerLeft,low,lowerRight,inner,next
}

public extension ArraySlice {
    
    /// Copy the array slice to an array.
    /// - Returns: An array that copied the array slice.
    /// - Complexity: O(*n*), where *n* is the length of the array slice.
    /// - Note: The array slice is independent of the array.
    func independentized() -> Array<Element> {
        return self.map { $0 }
    }
}

public extension Character {
    
    /// Returns a boolean value indicating whether the character is a hiragana.
    /// - Returns: `true` if the character is a hiragana; otherwise, `false`.
    /// - SeeAlso: [Unicode.org](https://unicode.org/charts/PDF/U3040.pdf)
    var isHiragana: Bool {
        return 0x3040...0x309f ~= self.unicodeScalars.first!.value//なんか汚い
    }
}

public extension StringProtocol {
    
    /// Returns a string with hiragana converted to katakana.
    /// - Returns: A string with hiragana converted to katakana.
    /// - SeeAlso: [Unicode.org](https://unicode.org/charts/PDF/U30A0.pdf)
    var katakanalized: String {
        let mapped = self.map { (character: Character) -> String in
            if character.isHiragana {
                return String(UnicodeScalar(character.unicodeScalars.first!.value + UInt32(0x30a0 - 0x3040))!)
            }
            return String(character)
        }
        
        let joined = mapped.joined()
        
        return joined
    }
}

/// \*\* is a power operator.
infix operator **: PowerPrecedence//publicいらない

/// **PowerPrecedence** is a precedence group that represents the power operator.
precedencegroup PowerPrecedence {//publicいらない
    higherThan: MultiplicationPrecedence
    lowerThan: BitwiseShiftPrecedence
    associativity: right
}

/// \*\*= is a power assignment operator.
infix operator **=: AssignmentPrecedence

/// **Powerable** is a protocol that represents the power operation.
/// - Note: The power operation is defined in [Wikipedia](https://en.wikipedia.org/wiki/Exponentiation)
public protocol Powerable {
    
    /// Returns the result of the power operation.
    /// - Parameters:
    ///  - radix: The base number.
    ///  - power: The exponent.
    /// - Returns: The result of the power operation.
    static func ** (_: Self, _: Self) -> Self
}

public extension Powerable {
    
    /// Assigns the result of the power operation to the left operand.
    /// - Parameters:
    /// - lhs: The left operand.
    /// - rhs: The right operand.
    static func **= (lhs: inout Self, rhs: Self) {
        lhs = lhs ** rhs
    }
}

extension Double: Powerable {
    public static func ** (radix: Double, power: Double) -> Double {
        return pow(radix,power)
    }
}

extension Int: Powerable {
    public static func ** (radix: Int, power: Int) -> Int {
        var result = 1
        for _ in 0..<power {
            result *= radix
        }
        
        return result
    }
}

extension Float: Powerable {
    public static func ** (radix: Float, power: Float) -> Float {
        return pow(radix,power)
    }
}

#if os(macOS)
extension Float80: Powerable {
    public static func ** (radix: Float80, power: Float80) -> Float80 {
        return pow(radix,power)
    }
}
#endif

public extension Array {
    
    /// Writes the textual representations of the array elements into the standard output.
    /// The separator is a newline.
    /// The terminator is a newline.
    func printEach() {
        for one in self {
            print(one)
        }
    }
}



//MARK: system
#if os(macOS)

/// Executes the given shell command.
/// - Parameters:
/// - body: The shell command.
/// - Throws: An error if the shell command is invalid.
/// - Note: The shell command is written to a temporary file.
/// The temporary file is executed by the shell.
/// The standard output and the standard error are written to the standard output.
/// - SeeAlso: [Wikipedia](https://en.wikipedia.org/wiki/Shell_script)
public func system(_ body: String) throws {
    let process = Process()
    let transProcess = Process()
    let pipe = Pipe()
    
    let directory: URL
    if #available(macOS 10.12, *)  {
        directory = FileManager.default.temporaryDirectory
    } else {
        directory = URL(fileURLWithPath: NSTemporaryDirectory())
    }
    let file = directory.appendingPathComponent("system.bash")
    try body.write(to: file, atomically: true, encoding: .utf8)
    
    process.arguments = [file.path]
    transProcess.arguments = [file.path]
    process.standardOutput = pipe
    process.standardError = pipe
    
    #if swift(>=4.1)
    if #available(macOS 10.13, *) {
        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        transProcess.executableURL = URL(fileURLWithPath: "/usr/local/bin/dos2unix")
        try transProcess.run()
        try process.run()
    } else {
        process.launchPath = "/bin/bash"
        transProcess.launchPath = "/usr/local/bin/dos2unix"
        transProcess.launch()
        process.launch()
    }
    #else
    process.launchPath = "/bin/bash"
    transProcess.launchPath = "/usr/local/bin/dos2unix"
    transProcess.launch()
    process.launch()
    #endif
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()//availableDataで一つのコマンドの結果を出力する
    let output = String(data: data, encoding: String.Encoding.utf8)!
    print(output, terminator: "")
}
#endif

public extension Bundle {
    
    /// Returns the value associated with the specified key in the localized or normal information dictionary.
    /// - Parameters:
    /// - key: The key in the information dictionary.
    /// - Returns: The value associated with the key in the localized or normal information dictionary.
    /// - Note: The localized information dictionary is preferred.
    func getValueFromLocalizedOrNormalInfoDictionary<T>(ofKey key: String, as type: T.Type) -> T? {
        if let it = localizedInfoDictionary {
            if let value = it[key] {
                return value as? T
            }
        }
        
        if let it = infoDictionary {
            if let value = it[key] {
                return value as? T
            }
        }
        
        return nil
    }
}


/************************************************Type Precedence***************************************************/
/*
protocol Ordered {}
protocol TypePrecedence {}

enum SingleTypePrecedence: Int, TypePrecedence {
    case cgFloat, double, int
}
extension TypePrecedence {
    var singel: SingleTypePrecedence{
        return self as! SingleTypePrecedence
    }
    
    var double: DoubleTypePrecedence{
        return self as! DoubleTypePrecedence
    }
}
protocol SingleOrdered: Ordered {}
extension Int: SingleOrdered {}
extension Double: SingleOrdered {}
extension CGFloat: SingleOrdered {}

struct HMQuantity {
    var type: TypePrecedence = SingleTypePrecedence.int
    var value: Ordered?
}

func transformedIntoHMQuantity(_ value: Ordered) -> HMQuantity {
    switch value {
    case is CGFloat:
        return HMQuantity(type: SingleTypePrecedence.cgFloat, value: value)
    case is Double:
        return HMQuantity(type: SingleTypePrecedence.double, value: value)
    case is Int:
        return HMQuantity(type: SingleTypePrecedence.int, value: value)
        
    case is CGPoint:
        return HMQuantity(type: DoubleTypePrecedence.cgPoint, value: value)
    case is CGSize:
        return HMQuantity(type: DoubleTypePrecedence.cgSize, value: value)
    default:
        assertionFailure()
        return HMQuantity()
    }
}
/*できたらこいつで一気に処理したい
func tranformedIntoOrdered(_ hmQuantity: HMQuantity) -> Ordered {
    switch hmQuantity.type {
    case SingleTypePrecedence.int:
        return hmQuantity.value as! Int
    case SingleTypePrecedence.double:
        return hmQuantity.value as! Double
    case SingleTypePrecedence.cgFloat:
        return hmQuantity.value as! CGFloat
        
    case DoubleTypePrecedence.cgPoint:
        return hmQuantity.value as! CGPoint
    case DoubleTypePrecedence.cgSize:
        return hmQuantity.value as! CGSize
    default:
        assertionFailure()
        return Int()
    }
}*/

func typeTransition(_ quantity: inout HMQuantity, to type: TypePrecedence) {
    switch type {
    case let singleType as SingleTypePrecedence:
        repeat {
            switch quantity.type {
            case SingleTypePrecedence.int:
                quantity.value = Double(quantity.value as! Int)
                quantity.type = SingleTypePrecedence.double
            case SingleTypePrecedence.double:
                quantity.value = CGFloat(quantity.value as! Double)
                quantity.type = SingleTypePrecedence.cgFloat
            case SingleTypePrecedence.cgFloat:
                assertionFailure()
            default:
                assertionFailure()
            }
        } while quantity.type as! SingleTypePrecedence != singleType
    case let doubleType as DoubleTypePrecedence:
        repeat {
            switch quantity.type {
            case DoubleTypePrecedence.cgSize:
                quantity.value = CGPoint(quantity.value as! CGSize)
                quantity.type = DoubleTypePrecedence.cgPoint
            case DoubleTypePrecedence.cgPoint:
                assertionFailure()
            default:
                assertionFailure()
            }
        } while quantity.type as! DoubleTypePrecedence != doubleType
    default:
        assertionFailure()
    }
}

func + (left: Ordered, right: Ordered) -> Ordered {//処理重くなる？
    var leftQuantity = HMQuantity()
    var rightQuantity = HMQuantity()
    
    leftQuantity = transformedIntoHMQuantity(left)
    rightQuantity = transformedIntoHMQuantity(right)
    
    if leftQuantity.type.singel.rawValue < rightQuantity.type.singel.rawValue {
        typeTransition(&rightQuantity, to: leftQuantity.type)
    } else if leftQuantity.type.singel.rawValue > rightQuantity.type.singel.rawValue {
        typeTransition(&leftQuantity, to: rightQuantity.type)
    }
    
    
    switch leftQuantity.type {
    case SingleTypePrecedence.int:
        return (leftQuantity.value as! Int) + (rightQuantity.value as! Int)
    case SingleTypePrecedence.double:
        return (leftQuantity.value as! Double) + (rightQuantity.value as! Double)
    case SingleTypePrecedence.cgFloat:
        return (leftQuantity.value as! CGFloat) + (rightQuantity.value as! CGFloat)
    case DoubleTypePrecedence.cgPoint:
        let leftCGPoint = leftQuantity.value as! CGPoint
        let rightCGPoint = rightQuantity.value as! CGPoint
        return CGPoint(x: leftCGPoint.x + rightCGPoint.x, y: leftCGPoint.y + rightCGPoint.y)
    case DoubleTypePrecedence.cgSize:
        let leftCGSize = leftQuantity.value as! CGSize
        let rightCGSize = rightQuantity.value as! CGSize
        return CGSize(width: leftCGSize.width + rightCGSize.width, height: leftCGSize.height + rightCGSize.height)
    default:
        assertionFailure()
        return Int()
    }
}

enum DoubleTypePrecedence: Int, TypePrecedence {
    case cgPoint, cgSize
}
protocol DoubleOrdered: Ordered {}
extension CGPoint: DoubleOrdered {}
extension CGSize: DoubleOrdered {}
//extension (SingleOrdered, SingleOrdered): DoubleOrdered {} これがやりたいいいいいいいいいいいいい
/*
func + (left: DoubleOrdered, right: DoubleOrdered) -> DoubleOrdered {//処理重くなる？
    var leftQuantity: HMQuantity? = nil
    var rightQuantity: HMQuantity? = nil
    
    switch left {
    case let value as CGPoint:
        leftQuantity = HMQuantity(type: DoubleTypePrecedence.cgPoint, value: value)
    case let value as CGSize:
        leftQuantity = HMQuantity(type: DoubleTypePrecedence.cgSize, value: value)
    /*case let value as (SingleOrdered, SingleOrdered):
         leftQuantity = HMQuantity(type: DoubleTypePrecedence.tuple, value: value) tupleはプロトコルをつけることができない*/
    }
    
    switch right {
    case let value as CGPoint:
        rightQuantity = HMQuantity(type: DoubleTypePrecedence.cgPoint, value: value)
    case let value as CGSize:
        rightQuantity = HMQuantity(type: DoubleTypePrecedence.cgSize, value: value)
    /*case let value as (SingleOrdered, SingleOrdered):
        rightQuantity = HMQuantity(type: DoubleTypePrecedence.tuple, value: value)*/
    }
    
    if leftQuantity!.type.double.rawValue < rightQuantity!.type.double.rawValue {
        typeTransition(&rightQuantity!, to: leftQuantity!.type)
    } else if leftQuantity!.type.singel.rawValue > rightQuantity!.type.singel.rawValue {
        typeTransition(&leftQuantity!, to: rightQuantity!.type)
    }
    
    switch leftQuantity!.type {
    case DoubleTypePrecedence.cgPoint:
        let leftCGPoint = leftQuantity!.value as! CGPoint
        let rightCGPoint = rightQuantity!.value as! CGPoint
        return CGPoint(x: leftCGPoint.x + rightCGPoint.x, y: leftCGPoint.y + rightCGPoint.y)
    case DoubleTypePrecedence.cgSize:
        let leftCGSize = leftQuantity!.value as! CGSize
        let rightCGSize = rightQuantity!.value as! CGSize
        return CGSize(width: leftCGSize.width + rightCGSize.width, height: leftCGSize.height + rightCGSize.height)/*
    case DoubleTypePrecedence.tuple:
        let leftTuple = left as! (SingleOrdered, SingleOrdered)
        let rightTuple = right as! (SingleOrdered, SingleOrdered)
        return (leftTuple.0 + rightTuple.0, leftTuple.1 + rightTuple.1) as! DoubleOrdered*/
    }
}*/
*/
/************************************************Type Precedence***************************************************/


