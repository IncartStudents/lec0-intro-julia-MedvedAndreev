# Реализовать ниже алгоритм «Игра жизнь»:
# https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life

# Подсказка для граничных условий - тор:
# julia> mod1(10, 30)
# 10
# julia> mod1(31, 30)
# 1

mutable struct GameOfLife
    current_frame::Matrix{Int}
    next_frame::Matrix{Int}
end

function stepgame!(state::GameOfLife)
    curr = state.current_frame
    next = state.next_frame

    # Один шаг алгоритма "Игра жизнь"

    return nothing
end

using Plots

n = 30
m = 30
init = rand(0:1, n, m)

game = GameOfLife(init, zeros(n, m))

anim = @animate for time = 1:100
    stepgame!(game)
    cr = game.current_frame
    heatmap(cr)
end
gif(anim, "life.gif", fps = 10)
