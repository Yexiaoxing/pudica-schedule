
model = require '../model'
mixins = require '../utils/mixins'

Item = require './item'
DoneItem = require './done-item'

module.exports = React.createClass
  displayName: 'App'
  mixins: [mixins.listenTo]

  getInitialState: ->
    schedule: model.get()
    dragging: null

  componentDidMount: ->
    @listenTo model, @_onChange

  _onChange: ->
    @setState schedule: model.get()

  render: ->

    itemsList = @state.schedule
    .filter (item) => not item.done
    .map (item) => Item
      key: item.id
      item: item
      isDragging: @state.dragging is item.id
      onDragStart: (itemId) =>
        @setState dragging: itemId
      onDragEnd: (itemId) =>
        @setState dragging: null
      onDragEnter: (itemId) =>
        model.swap @state.dragging, itemId

    deadList = @state.schedule
    .filter (item) => item.done
    .map (item) => DoneItem key: item.id, item: item

    isListRich = @state.schedule.length > 0

    $$.if isListRich,
      => $.div id: 'paper',
        itemsList
        $.div id: 'space'
        deadList
        $.div id: 'add-wrap',
          $.div
            id: 'clear'
            onClick: =>
              model.clear()
            'clear'
      => $.div id: 'start-guide',
        "Press Enter to start..."
