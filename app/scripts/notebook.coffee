# Return a stringt that gives a readable description of
# obj
displayPretty = (obj) ->
  if obj is undefined
    'undefined'
  else
    obj.toString()

evaluateCell = (inputCell) ->
  editorDiv = $(inputCell).next(".CodeMirror")
  existingOutput = editorDiv.next(".cell.output")
  existingOutput.remove()
  newOutputCell = $('<p class="cell output"></p>')
  editorDiv.after newOutputCell
  try
    result = CoffeeScript.eval inputCell.value
    newOutputCell.text displayPretty(result)
  catch error
    console.error error
    newOutputCell.html displayPretty(error) + "<br>See console for details."
    newOutputCell.addClass "error"

findOrCreateCursor = () ->
  cursor = $("#cursor")
  if cursor.length == 0
    cursor = $('<div class="cellCursor" id="cursor"></div>')
  else
    cursor = cursor[0]

insertCellCursorAfter = (inputCell) ->
  editorDiv = $(inputCell).next(".CodeMirror")
  editorDiv.after findOrCreateCursor()

insertCellCursorBefore = (inputCell) ->
  editorDiv = $(inputCell).next(".CodeMirror")
  editorDiv.before findOrCreateCursor()


addKeyMap = (editor, inputCell) ->
  editor.addKeyMap
    name: "notebook",
    "Shift-Enter": (cm) ->
      # save editor contents to textarea
      cm.save()
      evaluateCell(inputCell)
    "Down" : (cm) ->
      if cm.getCursor().line == cm.lineCount() - 1
        # we are at the last line in the cell and want to go down
        insertCellCursorAfter inputCell
        cm.getInputField().blur()
        null
      else
        # let CodeMirror handle this
        CodeMirror.Pass
    "Up" : (cm) ->
      if cm.getCursor().line == 0
        # we are at the first line in the cell and want to go up
        insertCellCursorBefore inputCell
        cm.getInputField().blur()
        null
      else
        # let CodeMirror handle this
        CodeMirror.Pass

makeInputCell = (inputCell) ->
  editor = CodeMirror.fromTextArea inputCell,
    mode: "coffeescript"
  addKeyMap editor, inputCell


for i in [1, 2]
  input = document.getElementById("input_#{i}")
  makeInputCell input
