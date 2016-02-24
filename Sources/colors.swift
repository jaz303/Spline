public protocol ARGBConvertible {
	func toARGB() -> UInt32
}

public protocol RGBColor {
	var red : Double { get }
	var green : Double { get }
	var blue : Double { get }
}

public protocol RGBAColor : RGBColor {
	var alpha : Double { get }
}

public class Colors {
	public static let white 	= Color(r: 1.0, g: 1.0, b: 1.0)
	public static let black 	= Color(r: 0.0, g: 0.0, b: 0.0)
	public static let red 		= Color(r: 1.0, g: 0.0, b: 0.0)
	public static let green 	= Color(r: 0.0, g: 1.0, b: 0.0)
	public static let blue		= Color(r: 0.0, g: 0.0, b: 1.0)
	public static let yellow	= Color(r: 1.0, g: 1.0, b: 0.0)
	public static let cyan		= Color(r: 0.0, g: 1.0, b: 1.0)
}

public class Color : ARGBConvertible, RGBAColor {
	public let red : Double
	public let green : Double
	public let blue : Double
	public let alpha : Double

	public convenience init(gray: Double, a: Double = 1.0) {
		self.init(r: gray, g: gray, b: gray, a: a)
	}

	public init(r: Double, g: Double, b: Double, a: Double = 1.0) {
		red = r
		green = g
		blue = b
		alpha = a
	}

	public func withAlpha(newAlpha: Double) -> Color {
		return Color(r: red, g: green, b: blue, a: newAlpha)
	}

	public func toARGB() -> UInt32 {
		return (UInt32(alpha * 255) << 24)
				| (UInt32(red * 255) << 16)
				| (UInt32(green * 255) << 8)
				| UInt32(blue * 255)
	}
}