// This particular neural network has the task of generationing the weights for a logical NAND

function Nand(training_set) {
    this.xs = [];
    for (var x = 0; x < training_set.length; x++) {
        this.xs[x] = [1,training_set[x][0][0],training_set[x][0][1]];
    }
        
    this.zs = [];
    for (var z = 0; z < training_set.length; z++) {
        this.zs[z] = training_set[z][1];
    }

    this.ws = [];
    for (var i = 0; i < this.xs[0].length; i++) {
        this.ws.push(0);
    }
    this.threshold     = 0.5;
    this.learning_rate = 0.1;
    this.generation    = 0;
};

Nand.prototype.next_generation = function(debug) {
    for (var i = 0; i < this.xs.length; i++) {
        var sum = 0,
            x   = this.xs[i];
        
        for (var c = 0; c < x.length; c++) {
            sum = sum + x[c] * this.ws[c];
        }
            
        var network = 1 / (1 + Math.pow(Math.E, sum * -1)),
            error   = this.zs[i] - network;

        if (debug) {
            console.log(Math.round(network));
        }

        var d = error * this.learning_rate;

        this.ws = (function() {
            var results = [];
            for (var w = 0; w < this.ws.length; w++) {
                results.push(Math.round((this.ws[w] + x[w] * d) * 1000) / 1000);
            }
            return results;
        }).call(this);
    }

    this.generation = this.generation + 1;
    
    return this.ws;
};

Nand.prototype.solve = function() {
    var state = true,
        cache = [];
    while (state) {
        if (this.generation === 0) {
            cache.push(this.next_generation(false));
        } else {
            var tmp = this.next_generation(false);
            state = !(cache.pop().toString() === tmp.toString());
            cache.push(tmp);
        }
    }

    cache[0] = (function() {
        var results = [];
        for (var c = 0; c < this.ws.length; c++) {
            results.push(Math.round(cache[0][c] * 1) / 1);
        }
        return results;
    }).call(this);

    return cache[0];
};

var training_set = [[[0,0],1],[[0,1],1],[[1,0],1],[[1,1],0]],
    nn = new Nand(training_set);

console.log(nn.solve());