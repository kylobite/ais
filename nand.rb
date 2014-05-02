#!/usr/bin/env ruby

class Nand

    # This particular neural network has the task of generationing the weights for a logical NAND

    attr_reader :xs, :zs, :ws, :threshold, :learning_rate, :generation

    def initialize
        training_set =  [[[0,0],1],[[0,1],1],[[1,0],1],[[1,1],0]]
        @xs = training_set.map {|x| [1,x[0][0],x[0][1]]}
        @zs = training_set.map {|z| z[1]}
        @ws = Array.new @xs[0].size, 0
        @threshold     = 0.5
        @learning_rate = 0.1
        @generation    = 0
    end

    def next_generation
        @generation = @generation.nil? ? 0 : @generation

        cache = Array.new

        @xs.each_with_index do |x,i|
            cs = Array.new 3, 0
            cs.each_index {|c| cs[c] = x[c] * @ws[c]}

            sum     = cs.inject {|sum,c| sum + c}
            network = sum > @threshold ? 1 : 0
            error   = @zs[i] - network

            d = error * @learning_rate

            @ws = (0..@ws.size-1).to_a.map {|w| @ws[w] = (sprintf "%.1f", @ws[w] + x[w] * d).to_f}
        end

        @generation = @generation + 1
        
        return @ws
    end

    def solve
        state = true
        cache = Array.new

        while state
            if @generation == 0
                cache.push next_generation
            else
                tmp   = next_generation
                state = cache.pop == tmp ? false : true
                cache.push tmp
            end
        end

        return cache[0]
    end
end