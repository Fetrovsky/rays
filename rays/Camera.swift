//
//  Camera.swift
//  rays
//
//  Created by Daniel Valencia on 4/20/22.
//

struct Camera: Thing {
    var dimension: Rectangle
    var location: Point
    var distance: Double
    var viewSize: (Int, Int)

    init(dimension: Rectangle, distance: Double, viewSize: (Int, Int)) {
        self.dimension = dimension
        self.location = dimension.getCenter()
        self.distance = distance
        self.viewSize = viewSize
    }

    func snap(shapes:[Shape], lights:[Light]) -> Bitmap {
        let normal = dimension.getNormal()
        let center = dimension.getCenter()
        let orthoNormal = normal.div(that:normal.getNorm())
        let vertex = center.sub(that:orthoNormal.mul(that:distance))

        var image = Array(repeating:Array(repeating:Color(), count:viewSize.0), count:viewSize.1)

        let worldPixelWidth = Vector(
            x: (dimension.topRight.x - dimension.topLeft.x) / Double(viewSize.0),
            y: (dimension.topRight.y - dimension.topLeft.y) / Double(viewSize.0),
            z: (dimension.topRight.z - dimension.topLeft.z) / Double(viewSize.0))

        let worldPixelHeight = Vector(
            x: (dimension.bottomLeft.x - dimension.topLeft.x) / Double(viewSize.1),
            y: (dimension.bottomLeft.y - dimension.topLeft.y) / Double(viewSize.1),
            z: (dimension.bottomLeft.z - dimension.topLeft.z) / Double(viewSize.1))

        var rowStart = dimension.topLeft

        var bitmap = Bitmap(width:viewSize.0, height:viewSize.1)

        for x in 0..<viewSize.0 {
            var pixel = rowStart

            for y in 0..<viewSize.1 {
                var intersection: Intersection? = nil
                var color = Color()

                let pixelRay = pixel.asVector().sub(that:vertex.asVector())
                let pixelRayNormalized = pixelRay.div(that:pixelRay.getNorm())

                for shape in shapes {
                    let currentIntersection = intersect(pixel:pixel, vector:pixelRayNormalized, shape:shape)

                    if (intersection == nil) {
                        intersection = currentIntersection
                        
                        if (intersection != nil) {
                            color = shape.color
                        }
                    } else
                    if (currentIntersection != nil) && (currentIntersection!.distance < intersection!.distance) {
                        intersection = currentIntersection
                        color = shape.color
                    }
                }

                if (intersection != nil) {
                    for light in lights {
                        // Make this random.
                        let surfacePoint = intersection!.point
                        let vector = light.location.asVector().sub(that:surfacePoint.asVector())
                        let unit = vector.div(that:vector.getNorm())
                        let intersectionWithLight = intersect(point:surfacePoint, vector:unit, light:light)

                        // Find blockers.  Ideally, lights are just other objects in the world.
                        if (intersectionWithLight == nil) {
                            // Should not happen.
                        }

                        let distance = intersectionWithLight!.distance
                        let cosineOfAngle = intersectionWithLight!.orthoNormal.dot(that:intersection!.orthoNormal)

                        if (cosineOfAngle > 0)
                        {
                            let intensity = (light.intensity * cosineOfAngle) / (distance * distance)
                            color = color.mul(that:light.color).mul(that:intensity)
                        }
                    }
                }

                image[x][y] = color

                pixel = pixel.add(that: worldPixelWidth)
            }

            rowStart = rowStart.add(that: worldPixelHeight)
        }

        var maxBitmapColorComponent = 0.0

        for y in 0..<viewSize.1 {
            for x in 0..<viewSize.0 {
                let color = image[x][y]
                
                if color.r > maxBitmapColorComponent {
                    maxBitmapColorComponent = color.r
                }
                
                if color.g > maxBitmapColorComponent {
                    maxBitmapColorComponent = color.g
                }
                
                if color.b > maxBitmapColorComponent {
                    maxBitmapColorComponent = color.b
                }
            }
        }

        for y in 0..<viewSize.1 {
            for x in 0..<viewSize.0 {
                let color = image[x][y]
                bitmap[x, y] = Bitmap.Color(v:color.div(that:maxBitmapColorComponent))
            }
        }

        return bitmap
    }

    func intersect(pixel:Point, vector:Vector, shape:Shape) -> Intersection?
    {
        let unitVector = vector.div(that:vector.getNorm())

        let intersections = shape.intersect(startingPoint:pixel, vector:unitVector)

        for intersection in intersections {
            // Intersections are sorted by distance.
            if (intersection.distance > 0) {
                return intersection
            }
        }
        
        return nil
    }

    func intersect(point:Point, vector:Vector, light:Light) -> Intersection?
    {
        let unitVector = vector.div(that:vector.getNorm())

        let intersections = light.intersect(startingPoint:point, vector:unitVector)

        for intersection in intersections {
            // Intersections are sorted by distance.
            if (intersection.distance > 0) {
                return intersection
            }
        }
        
        return nil
    }
}
