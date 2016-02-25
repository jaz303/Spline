import Foundation

let DEG2RAD = 180.0 / PI
let RAD2DEG = PI / 180.0

public struct Rad {
	public init(_ v: Double) { value = v }
	public let value: Double

	public func toRadians() -> Rad { return self }
	public func toDegrees() -> Deg { return Deg(value * RAD2DEG) }
}

public struct Deg {
	public init(_ v: Double) { value = v }
	public let value: Double

	public func toRadians() -> Rad { return Rad(value * DEG2RAD) }
	public func toDegrees() -> Deg { return self }
}

public func degrees(x: Double) -> Deg { return Deg(x * RAD2DEG) }
public func degrees(x: Rad) -> Deg { return Deg(x.value * RAD2DEG) }
public func degrees(x: Deg) -> Deg { return x }

public func radians(x: Double) -> Rad { return Rad(x * DEG2RAD) }
public func radians(x: Rad) -> Rad { return x }
public func radians(x: Deg) -> Rad { return Rad(x.value * DEG2RAD) }

public func acos(x: Double) -> Rad { return Rad(Foundation.acos(x)) }
public func asin(x: Double) -> Rad { return Rad(Foundation.asin(x)) }
public func atan(x: Double) -> Rad { return Rad(Foundation.atan(x)) }
public func atan2(y: Double, x: Double) -> Rad { return Rad(Foundation.atan2(y, x)) }

public func sin(x: Deg) -> Double { return Foundation.sin(x.value * DEG2RAD) }
public func cos(x: Deg) -> Double { return Foundation.cos(x.value * DEG2RAD) }
public func tan(x: Deg) -> Double { return Foundation.tan(x.value * DEG2RAD) }

public func sin(x: Rad) -> Double { return Foundation.sin(x.value) }
public func cos(x: Rad) -> Double { return Foundation.cos(x.value) }
public func tan(x: Rad) -> Double { return Foundation.tan(x.value) }