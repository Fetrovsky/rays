//
//  Bitmap.swift
//  rays
//
//  Created by Daniel Valencia on 4/20/22.
//

// import Foundation

struct Bitmap {
    public var pixels: [Color]
    let width: Int
    let height: Int

    struct Color {
        var r: UInt8
        var g: UInt8
        var b: UInt8
        var a: UInt8

        public init(r:UInt8, g:UInt8, b:UInt8) {
            self.r = r
            self.g = g
            self.b = b
            self.a = 1
        }

        public init(v:rays.Color) {
            self.init(r:Color.fromDouble(v:v.r), g:Color.fromDouble(v:v.g), b:Color.fromDouble(v:v.b))
        }

        static func fromDouble(v:Double) -> UInt8 {
            let x = v * 255
            
            if (x < 0) {
                return 0
            }

            if (x < 255) {
                return UInt8(x)
            }

            return 255
        }
    }

    public init(width:Int, height:Int)
    {
        self.width = width
        self.height = height
        self.pixels = Array(repeating:Bitmap.Color(r:0, g:0, b:0), count:width*height)
    }

    func makeIndex(x: Int, y: Int) -> Int {
        return (y * width) + x
    }

    subscript(x: Int, y: Int) -> Color {
        get { return pixels[makeIndex(x:x, y:y)] }
        set { pixels[makeIndex(x:x, y:y)] = newValue }
    }
}

