#!/usr/bin/env ruby

class Network
    attr_reader :neurons, :xs, :zs, :ws, :learning_rate, :generation

    def initialize training_set, neurons # An array of Neuron objects
        @neurons = neurons
        @xs = training_set.map {|x| [-1,x[0][0],x[0][1]]}
        @zs = training_set.map {|z| z[1]}
        @ws = nil #Array.new @xs[0].size, 0
        @learning_rate = 0.1
        @generation    = 0

    end

    def next_generation peek
        @generation = @generation.nil? ? 0 : @generation
        output      = Array.new
        cache       = Array.new

        @xs.each_with_index do |x,i|
            output[i] = [-1]
            @neurons.each_with_index do |neuron,n|
                output[i][n+1] = neuron.next_generation x, i
            end
        end

        @ws = Array.new(output[0].size,0) if @ws.nil?

        output.each_with_index do |o,i|
            cs = Array.new @ws.size, 0
            cs.each_index {|c| cs[c] = o[c] * @ws[c]}

            sum     = cs.inject {|sum,c| sum + c}
            network = (1 / (1 + Math::E**(sum * -1))).round 3
            error   = @zs[i] - network

            cache << network.round if peek

            d = error * @learning_rate

            @ws = (0..@ws.size-1).to_a.map {|w| @ws[w] = (@ws[w] + o[w] * d).round 3}
        end

        @generation = @generation + 1

        p cache if peek
        
        return @ws
    end

    def solve peek
        state = true
        cache = Array.new

        while state
            if @generation == 0
                cache.push next_generation false
            else
                tmp   = next_generation false
                state = cache.pop == tmp ? false : true
                unless state
                    @ws = @ws.map {|w| w.round}
                    tmp = @ws
                end
                cache.push tmp
            end
        end

        p cache[0] if peek

        return cache[0]
    end
end