using Luxor
#fdddd
const numBoids = 100
const visualRange = 75
boids = []
width = 200
height = 200

function initBoids()
    for i in 1:numBoids
        x = rand() * width
        y = rand() * height
        dx = rand() * 10 - 5
        dy = rand() * 10 - 5
        history = []
        a = [x, y, dx, dy, history]
        push!(boids, a)
    end
end


function distance(boid1, boid2)
    return sqrt((boid1[1] - boid2[1])^2 + (boid1[2] - boid2[2])^2)
end

function nClosestBoids(boid, n)
    # Make a copy
    sorted = copy(boids)
    # Sort the copy by distance from `boid`
    sort!(sorted, by = boid -> distance(boid, boid))
    # Return the first `n` closest
    return sorted[2:n+1]
end

function keepWithinBounds(boid, margin, turnFactor, width, height)
    if boid[1] < margin
        boid[3] += turnFactor
    end
    if boid[1] > width - margin
        boid[3] -= turnFactor
    end
    if boid[2] < margin
        boid[4] += turnFactor
    end
    if boid[2] > height - margin
        boid[4] -= turnFactor
    end
end

function flyTowardsCenter(boid, boids, visualRange, centeringFactor)
    centerX = 0
    centerY = 0
    numNeighbors = 0

    for otherBoid in boids
        if distance(boid, otherBoid) < visualRange
            centerX += otherBoid[1]
            centerY += otherBoid[2]
            numNeighbors += 1
        end
    end

    if numNeighbors != 0
        centerX /= numNeighbors
        centerY /= numNeighbors

        boid[3] += (centerX - boid[1]) * centeringFactor
        boid[4] += (centerY - boid[2]) * centeringFactor
    end
end

function avoidOthers(boid, boids, minDistance, avoidFactor)
    moveX = 0
    moveY = 0
    for otherBoid in boids
        if otherBoid !== boid
            if distance(boid, otherBoid) < minDistance
                moveX += boid[1] - otherBoid[1]
                moveY += boid[2] - otherBoid[2]
            end
        end
    end
    boid[3] += moveX * avoidFactor
    boid[4] += moveY * avoidFactor
    return boid
end

function matchVelocity(boid, boids, visualRange, matchingFactor)
    avgDX = 0
    avgDY = 0
    numNeighbors = 0
    
    for otherBoid in boids
        if distance(boid, otherBoid) < visualRange
            avgDX += otherBoid[3]
            avgDY += otherBoid[4]
            numNeighbors += 1
        end
    end
    
    if numNeighbors != 0
        avgDX /= numNeighbors
        avgDY /= numNeighbors

        boid[3] += (avgDX - boid[3]) * matchingFactor
        boid[4] += (avgDY - boid[4]) * matchingFactor
    end
end

function limitSpeed(boid, speedLimit)
    speed = sqrt(boid[3] * boid[3] + boid[4] * boid[4])
    if speed > speedLimit
        boid[3] = (boid[3] / speed) * speedLimit
        boid[4] = (boid[4] / speed) * speedLimit
    end
end

#function triangle(drawing, d, b, c)
    #poly(drawing, [d, b, c], :fill, close=true)
#end


function drawBoid(boid)
    start = [boid[1], boid[2]]    # начальная точка птицы
    direction = sqrt(boid[3] * boid[3] + boid[4] * boid[4])  # вектор скорости птицы
    #drawing = Drawing(800, 600, "boid.png") # Создаем изображение размером 800x600
    sethue("black")  # устанавливаем цвет черным
    setline(2)  # устанавливаем толщину линии

    # Рисуем треугольник, представляющий птицу
    Points = [Point(start[1], start[2]), Point(start[1] + direction, start[2] + direction), Point(start[1]+ 0.8 * direction + 0.2 * direction, start[2]+ 0.8 * direction + 0.2 * direction)]
    poly(Points)
    finish()  # завершаем рисование и сохраняем изображение
end




function animationLoop(boids, width, height, num_frames)
    drawing = Movie(width, height, "boid", 1:num_frames)
    for frame in 1:num_frames
        #origin()
        for boid in boids
            flyTowardsCenter(boid, boids, 75, 1)
            avoidOthers(boid, boids, 10, 20)
            matchVelocity(boid, boids, 75, 40)
            limitSpeed(boid, 10)
            keepWithinBounds(boid, 100, 10, 500, 500)
        
            boid[1] += boid[3]
            boid[2] += boid[4]
            push!(boid[5], [boid[1], boid[2]])
            boid[5] = boid[5][max(1, end-49):end]
        end

        function boidz(scene, frame)
            background("white")
            for boid in boids
                drawBoid(boid)
            end
        end


        #animate(drawing, [Scene(drawing, backdrop, 0:num_frames), Scene(drawing, boidz, 0:num_frames)])
        animate(drawing,[Scene(drawing, boidz, 1:2)], creategif=true,pathname="juliaspinner.gif")
        print(1)
        #finish()
        #preview()
    end
end




function init()
    #sizeCanvas()
    #window_resize = bind(window, "resize") do
        #sizeCanvas()
    #end
    #sizeCanvas()
    initBoids()
    animationLoop(boids, 1000, 1000, 1)
end

init()

