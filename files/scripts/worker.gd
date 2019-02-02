extends Reference

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
	id = state.workeridcounter
	state.workeridcounter += 1
	maxenergy = data.maxenergy
	energy = data.maxenergy
	icon = data.icon
	state.workers[id] = self

func restoreenergy():
	var value = maxenergy - energy
	if state.food > value:
		energy += value
		state.food -= value
		return true
	else:
		if state.food == 0:
			return false
		energy += state.food
		state.food = 0
		return true
