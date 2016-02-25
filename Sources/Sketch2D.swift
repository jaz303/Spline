import SDL2
import Cairo
import Foundation

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

public func abs(x: Int) -> Int {
	return Int(Foundation.abs(Int32(x)))
}

public func abs(x: Double) -> Double {
	return Foundation.fabs(x)
}

public func ceil(x: Double) -> Double {
	return Foundation.ceil(x)
}

// TODO: generics?
public func clamp(val: Double, min: Double, max: Double) -> Double {
	if (val < min) { return min }
	if (val > max) { return max }
	return val
}

// TODO: generics?
public func clamp(val: Int, min: Int, max: Int) -> Int {
	if (val < min) { return min }
	if (val > max) { return max }
	return val
}

public func floor(val: Double) -> Double {
	return Foundation.floor(val)
}

public func lerp(val: Double, from: Double, to: Double) -> Double {
	return from + (to - from) * val
}

public func sq(val: Int) -> Int {
	return val * val
}

public func sq(val: Double) -> Double {
	return val * val
}

public func sqrt(val: Double) -> Double {
	return Foundation.sqrt(val)
}

//
// Trig

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

//
//

public class Sketch2D {
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
				sourceRect: &_canvasRect,
				destinationRect: &_canvasRect
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