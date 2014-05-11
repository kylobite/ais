function Neuron(zs) {
    this.zs            = zs
    this.xs            = null
    this.ws            = null
    this.learning_rate = 0.1
    this.generation    = 0
    this.neurons       = null
}
        
Neuron.prototype.load_vector = function (xs) {
    this.xs = (function() {
        var results = []
        for (var i = 0; i < xs.length; i++) {
            x = xs[i]
            results.push([-1,x[0],x[1]])
        }
        return results
    }).call(this)
}
        
Neuron.prototype.load_neurons = function (neurons) {
    this.neurons = neurons
}
        
Neuron.prototype.next_generation = function (debug) {
    var ns    = [],
        cache = []

    var i = 0
    for (var a = 0; a < this.xs.length; a++) {
        var x = this.xs[a];
        ns[i] = [-1];

        n = 1;
        for (var b = 0; b < this.neurons.length; b++) {
            neuron = this.neurons[b]
            ns[i][n] = neuron.parse_neuron(x, i);
            n = n + 1;
        }
        i = i + 1;
    }

    if (this.ws === null) {
        this.ws = (function() {
            var results = [];
            for (var q = 0; q < ns[0].length; q++) {
                results.push(0);
            }
            return results;
        }).call(this);
    }

    i = 0
    for (var a = 0; a < ns.length; a++) {
        var n   = ns[a],
            sum = 0
        for (var c = 0; c < this.ws.length; c++) {
            sum = sum + n[c] * this.ws[c];
        }

        var network = 1 / (1 + Math.pow(Math.E, sum * -1)),
            error   = this.zs[i] - network,
            d       = error * this.learning_rate

        if (debug) { cache.push(Math.round(network * 1) / 1) }

        i = i + 1

        this.ws = (function() {
            var results = []
            for (var w = 0; w < this.ws.length; w++) {
                results.push(Math.round((this.ws[w] + n[w] * d) * 1000) / 1000)
            }
            return results
        }).call(this)
    }

    this.generation = this.generation + 1

    if (debug) { console.log(cache) }

    return this.ws
}
                            
Neuron.prototype.parse_neuron = function (x, i) {
    if (this.ws === null) {
        this.ws = (function() {
            var results = []
            for (var q = 0; q < x.length; q++) {
                results.push(0)
            }
            return results
        }).call(this)
    }

    var sum = 0
    for (var c = 0; c < this.ws.length; c++) {
        sum = sum + x[c] * this.ws[c];
    }

    var network = 1 / (1 + Math.pow(Math.E, sum * -1)),
        error   = this.zs[i] - network,
        d       = error * this.learning_rate

    i = i + 1

    this.ws = (function() {
        var results = []
        for (var w = 0; w < this.ws.length; w++) {
            results.push(Math.round((this.ws[w] + x[w] * d) * 1000) / 1000)
        }
        return results
    }).call(this)

    this.generation = this.generation + 1
    
    return network
}

Neuron.prototype.solve = function () {
    state = true
    cache = []

    while (state) {
        if (this.generation === 0) {
            cache.push(this.next_generation(false))
        }
        else {
            tmp   = this.next_generation(false)
            state = !(cache.pop().toString() == tmp.toString())
            if (!state) {
                this.ws = (function() {
                    var results = [];
                    for (var w = 0; w < this.ws.length; w++) {
                        results.push(Math.round(this.ws[w] * 1) / 1);
                    }
                    return results;
                }).call(this);
                tmp = this.ws
            }
            cache.push(tmp)
        }
    }

    return cache[0]
}

// XOR and XNOR
var and_neuron  = new Neuron([0,0,0,1])
var or_neuron   = new Neuron([0,1,1,1])
var xor_neuron  = new Neuron([0,1,1,0])
var xnor_neuron = new Neuron([1,0,0,1])

xor_neuron.load_vector([[0,0],[0,1],[1,0],[1,1]])
xor_neuron.load_neurons([and_neuron,or_neuron])

xor_neuron.solve()
xor_neuron.next_generation(true)

xnor_neuron.load_vector([[0,0],[0,1],[1,0],[1,1]])
xnor_neuron.load_neurons([and_neuron,or_neuron])

xnor_neuron.solve()
xnor_neuron.next_generation(true)