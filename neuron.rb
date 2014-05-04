#!/usr/bin/env ruby

class Neuron                                                # Singular network neuron
    attr_reader :ws, :zs, :learning_rate, :generation

    def initialize zs                                       # Outputs
        @zs            = zs                                 # Array of target outputs
        @ws            = nil                                # Array of neuron weights
        @learning_rate = 0.1
        @generation    = 0

    end
                                                            # ::Generate the next generation
    def next_generation x, i                                # Input, Which Input
        @ws = Array.new(x.size,0) if @ws.nil?
        cs  = Array.new @ws.size, 0                         # Array of sensor outputs
        cs.each_index {|c| cs[c] = x[c] * @ws[c]}           # Input * weight

        sum     = cs.inject {|sum,c| sum + c}               # Sum of sensor outputs
        network = (1 / (1 + Math::E**(sum * -1))).round 3   # Sigmoid(sum)
        network = network**2                                # Square the network (optimization?)
        error   = @zs[i] - network                          # Error from target output
        d       = error * @learning_rate                    # Error correction

        @ws = (0..@ws.size-1).to_a.map do |w|               # Cycle through weights
            @ws[w] = (@ws[w] + x[w] * d).round 3            # w_f = w_i + x * d
        end

        @generation = @generation + 1
        
        return network
    end
end