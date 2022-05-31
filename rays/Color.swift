//
//  Color.swift
//  rays
//
//  Created by Daniel Valencia on 4/20/22.
//

struct Color {
    var r: Double
    var g: Double
    var b: Double

    init(r:Double, g:Double, b:Double) {
        self.r = r
        self.g = g
        self.b = b
    }

    init(r:Int, g:Int, b: Int) {
        self.init(r:Double(r), g:Double(g), b:Double(b))
    }

    // Initializes as black.
    init() {
        self.init(r:0, g:0, b:0)
    }

    // Adds corresponding elements.
    func add(that: Color) -> Color {
        return Color(r: r + that.r, g: g + that.g, b: b + that.b)
    }

    // Subtracts corresponding elements.
    func sub(that: Color) -> Color {
        return Color(r: r - that.r, g: g - that.g, b: b - that.b)
    }

    // Multiplies elements by constant.
    func mul(that: Color) -> Color {
        return Color(r: r * that.r, g: g * that.g, b: b * that.b)
    }

    // Multiplies corresponding elements.
    func mul(that: Double) -> Color {
        return Color(r: r * that, g: g * that, b: b * that)
    }

    // Divides corresponding elements.
    func div(that: Color) -> Color {
        return Color(r: r / that.r, g: g / that.g, b: b / that.b)
    }

    // Divides elements by constant.
    func div(that: Double) -> Color {
        return Color(r: r / that, g: g / that, b: b / that)
    }
}
