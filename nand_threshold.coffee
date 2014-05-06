class Nand

    # This particular neural network has the task of generationing the weights for a logical NAND

    constructor: (training_set) ->
        @xs = for x in training_set
            [1,x[0][0],x[0][1]]
        @zs = for z in training_set
            z[1]
        @ws = for q in [1..@xs[0].length]
            0
        @threshold     = 0.5
        @learning_rate = 0.1
        @generation    = 0

    next_generation: (debug) ->
        i = 0
        for x in @xs
            sum = 0
            cs  = for c in [0..x.length-1]
                sum = sum + x[c] * @ws[c]
            network = if sum > @threshold then 1 else 0
            error   = @zs[i] - network
            i = i + 1

            cache = network

            if debug
                console.log Math.round network

            d = error * @learning_rate

            @ws = for w in [0..@ws.length-1]
                @ws[w] = Math.round((@ws[w] + x[w] * d) * 1000) / 1000

        @generation = @generation + 1
        
        return @ws

    solve: ->
        state = true
        cache = []

        while state
            if @generation == 0
                cache.push this.next_generation false
            else
                tmp   = this.next_generation false
                state = not (cache.pop().toString() == tmp.toString())
                cache.push tmp

        return cache[0]

training_set = [[[0,0],1],[[0,1],1],[[1,0],1],[[1,1],0]]
nn = new Nand training_set
console.log nn.solve()