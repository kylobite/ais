#!/usr/bin/env ruby

class Network                                                   # Network together neurons (this is a neuron)
    attr_reader :neurons, :xs, :zs, :ws, :learning_rate, :generation

    def initialize training_set, neurons                        # [[Inputs],Ouputs], Hidden Layer Neurons
        @neurons = neurons                                      # Array of Neuron objects
        @xs = training_set.map {|x| [-1,x[0][0],x[0][1]]}       # Array of input vectors
        @zs = training_set.map {|z| z[1]}                       # Array of target outputs
        @ws = nil                                               # Array of neuron weights (to be set)
        @learning_rate = 0.1
        @generation    = 0

    end
                                                                # ::Generate the next generation
    def next_generation peek                                    # Peek at network?
        @generation = @generation.nil? ? 0 : @generation
        output      = Array.new                                 # Network output of Neuron objects
        cache       = Array.new                                 # Cache of network (for peek)

        @xs.each_with_index do |x,i|                            # Cycle through input vectors
            output[i] = [-1]                                    # Preset the treshold
            @neurons.each_with_index do |neuron,n|              # Cycle through Neuron objects
                output[i][n+1] = neuron.next_generation x, i    # Get generation's network output
            end
        end

        @ws = Array.new(output[0].size,0) if @ws.nil?           # Set default of neuron weights

        output.each_with_index do |o,i|                         # Cycle through network outputs
            cs = Array.new @ws.size, 0                          # Array of sensor outputs
            cs.each_index {|c| cs[c] = o[c] * @ws[c]}           # Input * weight

            sum     = cs.inject {|sum,c| sum + c}               # Sum of sensor outputs
            network = (1 / (1 + Math::E**(sum * -1))).round 3   # Sigmoid(sum)
            error   = @zs[i] - network                          # Error from target output
            d = error * @learning_rate                          # Error correction

            cache << network.round if peek                      # Cache the network (for peek)

            @ws = (0..@ws.size-1).to_a.map do |w|               # Cycle through weights
                @ws[w] = (@ws[w] + o[w] * d).round 3            # w_f = w_i + x * d
            end
        end

        @generation = @generation + 1

        p cache if peek                                         # Print cache (for peek)
        
        return @ws
    end
                                                                # ::Generate generations until solved
    def solve peek                                              # Peek at the output?
        state = true                                            # State of while loop
        cache = Array.new                                       # Cache of generations

        while state
            if @generation == 0                                 # Is this the first generation?
                cache.push next_generation false                # Initialize the cache
            else
                tmp   = next_generation false                   # Generation to compare to previous
                state = !(cache.pop == tmp)                     # Change state if generations match
                unless state                                    # Is this the last loop?
                    @ws = @ws.map {|w| w.round}                 # Round out the weights
                    tmp = @ws                                   # Use rounded weights
                end
                cache.push tmp                                  # Replace cache with last generation
            end
        end

        p cache[0] if peek                                      # Print first cache element (for peek)

        return cache[0]
    end
end