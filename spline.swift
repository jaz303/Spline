import SDL2_swift
import Cairo_swift

prefix operator * {}

public class Constants {
	public let QUARTER_PI = 0.7853982
	public let HALF_PI = 1.57079632679489661923
	public let PI = 3.14159265358979323846
	public let TWO_PI = 6.28318530717958647693
	public let TAU = 6.28318530717958647693
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
			Events.wait(&evt, timeout: 1)
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

	public func clear(r r: Double, g: Double, b: Double) {
		ctx.setSourceColor(red: r, green: g, blue: b)
		ctx.clear()
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