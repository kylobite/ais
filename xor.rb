#!/usr/bin/env ruby

require "./neuron"

and_neuron  = Neuron.new [0,0,0,1]
or_neuron   = Neuron.new [0,1,1,1]
xor_neuron  = Neuron.new [0,1,1,0]
xnor_neuron = Neuron.new [1,0,0,1]

xor_neuron.load_vector  [[0,0],[0,1],[1,0],[1,1]]
xor_neuron.load_neurons [and_neuron,or_neuron]

xor_neuron.solve
xor_neuron.next_generation true

xnor_neuron.load_vector  [[0,0],[0,1],[1,0],[1,1]]
xnor_neuron.load_neurons [and_neuron,or_neuron]

xnor_neuron.solve
xnor_neuron.next_generation true

