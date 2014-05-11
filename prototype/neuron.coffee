class Neuron

    constructor: (zs) ->
        @zs            = zs
        @xs            = null
        @ws            = null
        @learning_rate = 0.1
        @generation    = 0
        @neurons       = null

    load_vector: (xs) ->
        @xs = for x in xs
            [-1,x[0],x[1]]

    load_neurons: (neurons) ->
        @neurons = neurons

    next_generation: (debug) ->
        ns    = new Array
        cache = new Array

        i = 0
        for x in @xs
            ns[i] = [-1]

            n = 1
            for neuron in @neurons
                ns[i][n] = neuron.parse_neuron x, i
                n = n + 1
            i = i + 1

        if @ws == null
            @ws = for q in [0..ns[0].length-1]
                0

        i = 0
        for n in ns
            sum = 0
            for c in [0..@ws.length-1]
                sum = sum + n[c] * @ws[c]

            network = 1 / (1 + Math.pow(Math.E, sum * -1))

            if debug
                cache.push Math.round(network * 1) / 1

            error = @zs[i] - network
            d     = error * @learning_rate

            i = i + 1

            @ws = for w in [0..@ws.length-1]
                @ws[w] = Math.round((@ws[w] + n[w] * d) * 1000) / 1000

        @generation = @generation + 1

        if debug
            console.log cache
        
        return @ws
                            
    parse_neuron: (x, i) ->
        if @ws == null
            @ws = for q in [0..x.length-1]
                0
        cs  = for q in [0..@ws.length-1]
            0

        sum     = 0
        for c in [0..cs.length-1]
            sum = sum + x[c] * @ws[c]

        network = 1 / (1 + Math.pow(Math.E, sum * -1))
        error   = @zs[i] - network
        d       = error * @learning_rate

        @ws = for w in [0..@ws.length-1]
            @ws[w] = Math.round((@ws[w] + x[w] * d) * 10000) / 10000

        @generation = @generation + 1
        
        return network

    solve: -> 
        state = true
        cache = new Array

        while state
            if @generation == 0
                cache.push this.next_generation false
            else
                tmp   = this.next_generation false
                state = not (cache.pop().toString() == tmp.toString())
                if not state
                    @ws = for w in @ws
                        Math.round(w * 1) / 1
                    tmp = @ws
                cache.push tmp

        return cache[0]

# XOR and XNOR
and_neuron  = new Neuron [0,0,0,1]
or_neuron   = new Neuron [0,1,1,1]
xor_neuron  = new Neuron [0,1,1,0]
xnor_neuron = new Neuron [1,0,0,1]

xor_neuron.load_vector  [[0,0],[0,1],[1,0],[1,1]]
xor_neuron.load_neurons [and_neuron,or_neuron]

xor_neuron.solve()
xor_neuron.next_generation true

xnor_neuron.load_vector  [[0,0],[0,1],[1,0],[1,1]]
xnor_neuron.load_neurons [and_neuron,or_neuron]

xnor_neuron.solve()
xnor_neuron.next_generation true