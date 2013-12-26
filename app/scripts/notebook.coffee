# Return a stringt that gives a readable description of
# obj
displayPretty = (obj) ->
  if obj is undefined
    'undefined'
  else
    obj.toString()

evaluateCell = (inputCell) ->
  realCell = $(enclosingCell(inputCell))
  existingOutput = realCell.next(".cell.output")
  existingOutput.remove()
  newOutputCell = $('<div class="cell output"></div>')
  realCell.after newOutputCell
  try
    result = CoffeeScript.eval inputCell.value
    newOutputCell.text displayPretty(result)
  catch error
    console.error error
    newOutputCell.html displayPretty(error) + "<br>See console for details."
    newOutputCell.addClass "error"

findOrCreateCellCursor = () ->
  cursor = $("#cursor")
  if cursor.length == 0
    cursor = $('<div class="cellCursor" id="cursor"></div>')
  else
    cursor = cursor[0]

insertCellCursorAfter = (cell) ->
  cell.after findOrCreateCellCursor()

insertCellCursorBefore = (cell) ->
  cell.before findOrCreateCellCursor()


moveCellCursorDown = () ->
  console.log "moveCellCursorDown"
  cursor = findOrCreateCellCursor()
  cell = $(cursor).next("div.cell")
  if cell
    insertCellCursorAfter(cell)

moveCellCursorUp = () ->
  console.log "moveCellCursorUp"
  cursor = findOrCreateCellCursor()
  cell = $(cursor).prev("div.cell")
  if cell
    insertCellCursorBefore(cell)

moveCellCursorRight = () ->
  console.log "moveCellCursorRight"
  cursor = findOrCreateCellCursor()
  nextCell = $(cursor).next(".cell")
  textarea = nextCell.children("textarea")
  editor = textarea[0].editor
  editor.focus()
  cursor.remove()

moveCellCursorLeft = () ->
  console.log "moveCellCursorLeft"
  cursor = findOrCreateCellCursor()
  previousCell = $(cursor).prev(".cell")
  textarea = previousCell.children("textarea")
  editor = textarea[0].editor
  editor.focus()
  editor.setCursor editor.lineCount() - 1, editor.getLine(editor.lineCount() - 1).length
  cursor.remove()


enclosingCell = (elem) ->
  elem.parentNode


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
        insertCellCursorAfter $(enclosingCell(inputCell))
        cm.getInputField().blur()
        null
      else
        # let CodeMirror handle this
        CodeMirror.Pass
    "Up" : (cm) ->
      if cm.getCursor().line == 0
        # we are at the first line in the cell and want to go up
        insertCellCursorBefore $(enclosingCell(inputCell))
        cm.getInputField().blur()
        null
      else
        # let CodeMirror handle this
        CodeMirror.Pass

makeInputCell = (inputCell) ->
  editor = CodeMirror.fromTextArea inputCell,
    mode: "coffeescript"
  inputCell.editor = editor
  addKeyMap editor, inputCell


for i in [1, 2, 3]
  input = document.getElementById("input_#{i}")
  makeInputCell input

$(document).bind 'keydown', 'down', (ev) -> moveCellCursorDown()
$(document).bind 'keydown', 'up', (ev) -> moveCellCursorUp()
$(document).bind 'keydown', 'right', (ev) -> moveCellCursorRight()
$(document).bind 'keydown', 'left', (ev) -> moveCellCursorLeft()
