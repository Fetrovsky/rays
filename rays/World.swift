//
//  ContentView.swift
//  rays
//
//  Created by Daniel Valencia on 4/16/22.
//

import SwiftUI

protocol Thing {
    var location: Point {get set}
}

struct Rectangle {
    var topLeft: Point
    var topRight: Point
    var bottomLeft: Point
    var bottomRight: Point

    let makeBottomRightImpl = {
        (tl:Point, tr:Point, bl:Point) -> Point in
        return bl.add(that:Vector(p:tr.sub(that:Vector(p:tl))))
    }

    init(tl: Point, tr: Point, bl: Point)
    {
        topLeft = tl
        topRight = tr
        bottomLeft = bl
        bottomRight = makeBottomRightImpl(tl, tr, bl)
    }

    func makeBottomRight() -> Point {
        return makeBottomRightImpl(topLeft, topRight, bottomLeft)
    }

    func getCenter() -> Point {
        return Point(
            x: (bottomRight.x + topLeft.x) / 2,
            y: (bottomRight.y + topLeft.y) / 2,
            z: (bottomRight.z + topLeft.z) / 2)
    }

    func getSize() -> (Double, Double) {
        return (topLeft.distanceTo(that:topRight), topLeft.distanceTo(that:bottomLeft))
    }

    func getNormal() -> Vector {
        let x = Vector(p:topRight.sub(that:topLeft.asVector()))
        let y = Vector(p:bottomLeft.sub(that:topLeft.asVector()))
        return x.cross(that:y)
    }
    
    // Paning (movement) functions: left, right, up, down.
    // Rotating functions: left/right, up/down, anti/clockwise.
    // Resizing functions.
}

struct World {
    var cameras: [Camera]
    var lights: [Light]
    var shapes: [Shape]

    typealias PutPixelType = (Int, Int, (Double, Double, Double)) -> Void

    func draw(camera: Int) -> Bitmap {
        return cameras[camera].snap(shapes:shapes, lights:lights)
    }
}

struct ContentView: View {
    var world = World(
        cameras: [
            Camera(
                dimension:Rectangle(tl:Point(x:-5, y:5, z:20), tr:Point(x:5, y:5, z:20),bl:Point(x:-5, y:-5, z:20)),
                distance:50,
                viewSize: (1000, 1000))
        ],
        lights: [
//            Light(x:100.0, y:100.0, z:10.0, r:10.0, color:Color(r:1, g:1, b:1), i:10),
            Light(x:-100.0, y:-100.0, z:10.0, r:10.0, color:Color(r:0, g:1, b:0.5), i:10)
        ],
        shapes:[
//            Sphere(x:5, y:5, z:5, r:2, c:Color(r:1.0, g:0.6, b:0.3)),
            Sphere(x:4, y:1, z:2, r:5, c:Color(r:0.3, g:0.6, b:1.0)),
            Sphere(x:3, y:4, z:-30, r:10, c:Color(r:1.0, g:0.6, b:1.0)),
            Sphere(x:-1, y:1, z:10, r:0.1, c:Color(r:1.0, g:1.0, b:1.0)),
            Sphere(x:1, y:1, z:10, r:0.1, c:Color(r:1.0, g:0.0, b:0.0)),
            Sphere(x:-1, y:-1, z:10, r:0.1, c:Color(r:0.0, g:1.0, b:0.0)),
            Sphere(x:1, y:-1, z:10, r:0.1, c:Color(r:0.0, g:0.0, b:1.0))
        ])

    var body: some View {
        Image(decorative:ContentView.makeImage(bitmap:world.draw(camera:0))!, scale:1.0, orientation:.up)
    }

    static func makeImage(bitmap:Bitmap) -> CGImage? {
        guard
            let dataProvider = CGDataProvider(data:Data(bytes:bitmap.pixels, count:bitmap.pixels.count * 4) as CFData)
        else {
            return nil
        }

        return CGImage(
            width: bitmap.width,
            height: bitmap.height,
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: 4 * bitmap.width,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue:CGImageAlphaInfo.noneSkipLast.rawValue),
            provider: dataProvider,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
