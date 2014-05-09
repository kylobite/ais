#!/usr/bin/env ruby

class Neuron
    attr_reader :zs, :xs, :ws, :learning_rate, :generation, :neurons

    def initialize zs
        @zs            = zs
        @xs            = nil
        @ws            = nil
        @learning_rate = 0.1
        @generation    = 0
        @neurons       = nil
    end

    def load_vector xs
        @xs = xs.map {|x| [-1,x[0],x[1]]}
    end

    def load_neurons neurons
        @neurons = neurons
    end

    def next_generation debug
        ns    = Array.new
        cache = Array.new

        @xs.each_with_index do |x,i|
            ns[i] = [-1]
            @neurons.each_with_index do |neuron,n|
                ns[i][n+1] = neuron.parse_neuron x, i
            end
        end

        @ws = Array.new(ns[0].size,0) if @ws.nil?

        ns.each_with_index do |n,i|
            cs = Array.new @ws.size, 0
            cs.each_index {|c| cs[c] = n[c] * @ws[c]}

            sum     = cs.inject {|sum,c| sum + c}
            network = (1 / (1 + Math::E**(sum * -1))).round 3
            network = network**2

            if debug
                cache << network.round
            end

            error   = @zs[i] - network
            d = error * @learning_rate

            @ws = (0..@ws.size-1).to_a.map do |w|
                @ws[w] = (@ws[w] + n[w] * d).round 3
            end
        end

        @generation = @generation + 1

        if debug
            p cache
        end
        
        return @ws
    end
                            
    def parse_neuron x, i
        @ws = Array.new(x.size,0) if @ws.nil?
        cs  = Array.new @ws.size, 0
        cs.each_index {|c| cs[c] = x[c] * @ws[c]}

        sum     = cs.inject {|sum,c| sum + c}
        network = (1 / (1 + Math::E**(sum * -1))).round 3
        network = network**2
        error   = @zs[i] - network
        d       = error * @learning_rate

        @ws = (0..@ws.size-1).to_a.map do |w|
            @ws[w] = (@ws[w] + x[w] * d).round 3
        end

        @generation = @generation + 1
        
        return network
    end

    def solve 
        state = true
        cache = Array.new

        while state
            if @generation == 0
                cache.push next_generation false
            else
                tmp   = next_generation false
                state = !(cache.pop == tmp)
                unless state
                    @ws = @ws.map {|w| w.round}
                    tmp = @ws
                end
                cache.push tmp
            end
        end

        return cache[0]
    end
end