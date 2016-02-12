import SDL2_swift
import Cairo_swift

prefix operator * {}

public class Sketch2D {
	public init() {
		SDL.start()
		_fps = 30
	}

	public func fps(fps: Double) {
		_fps = fps
	}

	public func size(width width: Int, height: Int) {
		_window = Window(title: "spline", width: width, height: height)
	}

	public func start() {
		setup()

		var clock = Clock(dt: 0.0)
		let fps = _fps
		let msPerFrame = UInt32(1000.0 / fps)

		var evt = Event()

		while true {
			Events.wait(&evt)
			clock.dt = Double(msPerFrame) / 1000.0
			oneFrame(clock)
			Timers.delay(Int(msPerFrame))
		}
	}

	public func setup() {

	}

	public func loop(clock: Clock) {

	}

	private func oneFrame(clock: Clock) -> UInt32 {
		let frameStart = Timers.getTicks()
		loop(clock)
		return Timers.getTicks() - frameStart
	}

	private var _fps: Double
	private var _window: Window?
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