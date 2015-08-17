
_ = require 'lodash'

module.exports = (ko) ->
  if !ko.mapping?
    throw Error "You need to load knockout-mapping for the exercise editor."
  class TaskViewModel
    constructor: (data) ->
      if data?
        ko.mapping.fromJS data, {}, this
      @hasTitle = ko.computed => @title()? and @title().trim() isnt ''

      @solution ?= ko.observable ''

  class ExercisePageViewModel
    constructor: (params) ->
      @number = ko.observable()
      @tasks = ko.observableArray()
      @exerciseNotFound = ko.observable(no)
      @isOld = ko.observable true

      @getExercise params.id, (exercise, status, error) =>
        if exercise?
          @exercise = exercise
          @number exercise.number

          tasks = _.map exercise.tasks, (t) -> new TaskViewModel t
          _.each tasks, (t) =>
            t.solution.subscribe => @submit t
            @tasks.push t

          @isOld Date.parse(exercise.dueDate) < Date.now()
        else if status is 404
          @exerciseNotFound yes
        else
          # TODO some other error occurred...

    submit: (task) =>
      if task? #submit this task only
        @saveTask task.id, ko.mapping.toJS(task), (status) ->
          console.log 'Submit: ' + status
      else #submit everything
        @saveExercise exercise.id, ko.mapping.toJS(@tasks), (status) ->
          console.log 'Submit: ' + status

    # called through afterRender event in template html
    init: () =>
      $(".popupinfo").popup()

  ExercisePageViewModel: ExercisePageViewModel
