import SDL2_swift
import Cairo_swift

prefix operator * {}

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

public class Constants {
	public let QUARTER_PI = 0.7853982
	public let HALF_PI = 1.57079632679489661923
	public let PI = 3.14159265358979323846
	public let TWO_PI = 6.28318530717958647693
	public let TAU = 6.28318530717958647693

	public let WHITE = Colors.white
	public let BLACK = Colors.black
	public let RED = Colors.red
	public let GREEN = Colors.green
	public let BLUE = Colors.blue
	public let YELLOW = Colors.yellow
	public let CYAN = Colors.cyan
}

public class Sketch2D : Constants {
	public init(width: Int, height: Int) {
		
		SDL.start()

		_window = Window(title: "spline", width: width, height: height)
		_renderer = _window.renderer
		_texture = _renderer.createStreamingTexture(width: width, height: height)
		
		_surface = Surface(width: width, height: height)
		_cairoImageSurface = ImageSurface(
			data: _surface.pixels,
			width: _surface.width,
			height: _surface.height,
			stride: _surface.pitch
		)

		_canvasRect = Rect(x: 0, y: 0, w: Int32(width), h: Int32(height))
		
		ctx = Context(surface: _cairoImageSurface)
		
	}

	public func fps(fps: Double) {
		_fps = fps
	}

	public func start() {

		var clock = Clock(dt: 0.0)
		let fps = _fps
		let msPerFrame = UInt32(1000.0 / fps)

		var evt = Event()

		_running = true
		while _running {
			while Events.poll(&evt) {
				if evt.isWindow && evt.isWindowClose {
					_running = false
				}
			}
			

			clock.dt = Double(msPerFrame) / 1000.0
			oneFrame(clock)
			Timers.delay(Int(msPerFrame))

			_texture.copyFromSurface(_surface)
			_renderer.copyTexture(
				_texture,
				sourceRect: _canvasRect,
				destinationRect: _canvasRect
			)
			_renderer.present()
		}
	}

	public func loop(clock: Clock) {

	}

	private func oneFrame(clock: Clock) -> UInt32 {
		let frameStart = Timers.getTicks()
		loop(clock)
		return Timers.getTicks() - frameStart
	}

	public func clear() {
		clear(r: 0.0, g: 0.0, b: 0.0)
	}

	public func clear(color: RGBColor) {
		ctx.setSourceColor(
			red: color.red,
			green: color.green,
			blue: color.blue
		)
		ctx.clear()
	}

	public func clear(r r: Double, g: Double, b: Double) {
		ctx.setSourceColor(red: r, green: g, blue: b)
		ctx.clear()
	}

	public func stroke(color: RGBColor, alpha: Double) {
		ctx.setSourceColor(
			red: color.red,
			green: color.green,
			blue: color.blue,
			alpha: alpha
		)
	}

	public func stroke(color: RGBAColor) {
		ctx.setSourceColor(
			red: color.red,
			green: color.green,
			blue: color.blue,
			alpha: color.alpha
		)
	}

	public func stroke(r r: Double, g: Double, b: Double) {
		ctx.setSourceColor(red: r, green: g, blue: b)
	}

	public func begin() {
		ctx.beginPath()
	}

	public func moveTo(x x: Double, y: Double) {
		ctx.moveTo(x: x, y: y)
	}

	public func lineTo(x x: Double, y: Double) {
		ctx.lineTo(x: x, y: y)
	}

	public func stroke() {
		ctx.stroke()
	}

	//
	// Pixels

	public func plot(x: Int, _ y: Int, r: Double, g: Double, b: Double) {
		let red = UInt32(r * 255)
		let green = UInt32(g * 255)
		let blue = UInt32(b * 255)
		_surface.putPixel32(x, y, red << 16 | green << 8 | blue)
	}

	public func plot(x: Int, _ y: Int, color: ARGBConvertible) {
		_surface.putPixel32(x, y, color.toARGB())	
	}


 	//
 	// Matrix

 	public func transform(inout matrix: Matrix) {
 		ctx.transform(&matrix)
 	}

 	public func transform(  xx: Double,
 						  _ yx: Double,
 						  _ xy: Double,
 						  _ yy: Double,
 						  _ x0: Double,
 						  _ y0: Double) {
 		var m = Matrix(xx: xx, yx: yx, xy: xy, yy: yy, x0: x0, y0: y0)
 		ctx.transform(&m)				    
	}

 	public func setMatrix(inout matrix: Matrix) {
 		ctx.setMatrix(&matrix)
 	}

 	public func setMatrix(  xx: Double,
 						  _ yx: Double,
 						  _ xy: Double,
 						  _ yy: Double,
 						  _ x0: Double,
 						  _ y0: Double) {
 		var m = Matrix(xx: xx, yx: yx, xy: xy, yy: yy, x0: x0, y0: y0)
 		ctx.setMatrix(&m)
 	}

 	public func popMatrix() {
 		var matrix = _matrixStack.removeLast()
 		ctx.setMatrix(&matrix)
 	}

 	public func pushMatrix() {
 		var matrix = Matrix.zero()
 		ctx.getMatrix(&matrix)
 		_matrixStack.append(matrix)
 	}

 	public func resetMatrix() {
 		ctx.setIdentity()
 	}

 	public func rotate(theta: Double) {
 		ctx.rotate(theta)
 	}

 	public func scale(factor: Double) {
 		ctx.scale(factor)
 	}

 	public func scale(sx sx: Double, sy: Double) {
 		ctx.scale(sx: sx, sy: sy)
 	}

 	public func translate(dx dx: Double, dy: Double) {
 		ctx.translate(dx: dx, dy: dy)
 	}

 	//
 	//

	public var ctx: Context

	private var _canvasRect: Rect

	private var _running = false

	private var _surface: Surface
	private var _cairoImageSurface: ImageSurface

	private var _fps: Double = 30.0
	private var _window: Window
	private var _renderer: Renderer
	private var _texture: Texture

	private var _matrixStack = [Matrix]()
}

//
//

public class Spline {
	
}

//
// Clock

public struct Clock {
	var dt: Double
}

//
// Events

public class MouseEvent {
	
}

public class KeyDownEvent {
	
}

//
// Parameters

protocol Param {
	typealias ParamType
	func setValue(newValue: ParamType)
	func value() -> ParamType
}

public class Parameter<T>: Param {
	public init(name: String, initialValue val: T) {
		self.name = name
		self.val = val
	}

	public convenience init(_ val: T) {
		self.init(name: "Unnamed", initialValue: val)
	}

	func value() -> T {
		return val
	}

	func type() -> String {
		return "\(T.self)"
	}

	func setValue(newValue: T) {
		val = newValue
	}

	public let name: String
	var val: T
}

public class IntParam: Parameter<Int> {
	override public init(name: String, initialValue val: Int) {
		super.init(name: name, initialValue: val)
	}
}

public class DoubleParam: Parameter<Double> {
	override public init(name: String, initialValue val: Double) {
		super.init(name: name, initialValue: val)
	}
}

public class StringParam: Parameter<String> {
	override public init(name: String, initialValue val: String) {
		super.init(name: name, initialValue: val)
	}	
}

prefix func *<T>(v: Parameter<T>) -> T {
    return v.value()
}