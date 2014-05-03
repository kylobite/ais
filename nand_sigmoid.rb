#!/usr/bin/env ruby

class Nand

    # This particular neural network has the task of generationing the weights for a logical NAND

    attr_reader :xs, :zs, :ws, :learning_rate, :generation

    def initialize training_set
        @xs = training_set.map {|x| [-1,x[0][0],x[0][1]]}
        @zs = training_set.map {|z| z[1]}
        @ws = Array.new @xs[0].size, 0
        @learning_rate = 0.1
        @generation    = 0

    end

    def next_generation debug
        @generation = @generation.nil? ? 0 : @generation

        @xs.each_with_index do |x,i|
            cs = Array.new @ws.size, 0
            cs.each_index {|c| cs[c] = x[c] * @ws[c]}

            sum     = cs.inject {|sum,c| sum + c}
            network = (1 / (1 + Math::E**(sum * -1))).round 3
            error   = @zs[i] - network

            if debug
                p network.round
            end

            d = error * @learning_rate

            @ws = (0..@ws.size-1).to_a.map {|w| @ws[w] = (@ws[w] + x[w] * d).round 3}
        end

        @generation = @generation + 1
        
        return @ws
    end

    def solve
        state = true
        cache = Array.new

        while state
            if @generation == 0
                cache.push next_generation false
            else
                tmp   = next_generation false
                state = cache.pop == tmp ? false : true
                cache.push tmp
            end
        end

        return cache[0]
    end
end

training_set = [[[0,0],1],[[0,1],1],[[1,0],1],[[1,1],0]]
nn = Nand.new training_set