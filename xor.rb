#!/usr/bin/env ruby

require "./neuron"
require "./network"

and_neuron = Neuron.new [0,0,0,1]                           # AND gate neuron
or_neuron  = Neuron.new [0,1,1,1]                           #  OR gate neuron
xor_vector = [[[0,0],0],[[0,1],1],[[1,0],1],[[1,1],0]]      # XOR gate training set
xor_neuron = Network.new xor_vector, [and_neuron,or_neuron] # XOR gate neuron

xor_neuron.solve true                                       # Print XOR gate weights
xor_neuron.next_generation true                             # Print XOR gate network outputs (confirm)