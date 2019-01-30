extends Node

var name
var type
var id
var task
var energy
var maxenergy
var currenttask
var icon
var model
var autoconsume = true

func create(data):
	name = data.name
	type = data.type
	id = globals.state.workeridcounter
	globals.state.workeridcounter += 1
	maxenergy = data.maxenergy
	energy = data.maxenergy
	icon = data.icon
	globals.state.workers[id] = self

func restoreenergy():
	var value = maxenergy - energy
	if globals.state.food > value:
		energy += value
		globals.state.food -= value
		return true
	else:
		if globals.state.food == 0:
			return false
		energy += globals.state.food
		globals.state.food = 0
		return true
