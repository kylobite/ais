#!/usr/bin/env ruby

require "./neuron"
require "./network"

and_neuron = Neuron.new [0,0,0,1]
or_neuron  = Neuron.new [0,1,1,1]
xor_vector = [[[0,0],0],[[0,1],1],[[1,0],1],[[1,1],0]]
xor_neuron = Network.new xor_vector, [and_neuron,or_neuron]

xor_neuron.solve true
xor_neuron.next_generation true