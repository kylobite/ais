#!/usr/bin/env ruby

class Neuron
    attr_reader :ws, :zs, :learning_rate, :generation

    def initialize zs
        @zs = zs
        @ws = nil
        @learning_rate = 0.1
        @generation    = 0

    end

    def next_generation x, i
        @ws   = Array.new(x.size,0) if @ws.nil?
        cs    = Array.new @ws.size, 0
        
        cs.each_index {|c| cs[c] = x[c] * @ws[c]}

        sum     = cs.inject {|sum,c| sum + c}
        network = (1 / (1 + Math::E**(sum * -1))).round 3
        error   = @zs[i] - network

        d = error * @learning_rate

        @ws = (0..@ws.size-1).to_a.map {|w| @ws[w] = (@ws[w] + x[w] * d).round 3}

        @generation = @generation + 1
        
        return network
    end
end