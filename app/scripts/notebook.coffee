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
    compiled = CoffeeScript.compile inputCell.value
    # remove the outer (function() ...).call(this);
    compiled = compiled[14...-17]
    result = eval.call window, compiled
    newOutputCell.text displayPretty(result)
  catch error
    console.error error
    newOutputCell.html displayPretty(error) + "<br>See console for details."
    newOutputCell.addClass "error"
  insertCellCursorAfter newOutputCell
  inputCell.editor.getInputField().blur()

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
  cursor = findOrCreateCellCursor()
  cell = $(cursor).next("div.cell")
  if cell
    insertCellCursorAfter(cell)

moveCellCursorUp = () ->
  cursor = findOrCreateCellCursor()
  cell = $(cursor).prev("div.cell")
  if cell
    insertCellCursorBefore(cell)

moveCellCursorRight = () ->
  cursor = findOrCreateCellCursor()
  nextCell = $(cursor).next(".cell")
  textarea = nextCell.children("textarea")
  editor = textarea[0].editor
  editor.focus()
  cursor.remove()

setCursorToEndOfDoc = (editor) ->
  editor.setCursor editor.lineCount() - 1, editor.getLine(editor.lineCount() - 1).length

moveCellCursorLeft = () ->
  cursor = findOrCreateCellCursor()
  previousCell = $(cursor).prev(".cell")
  textarea = previousCell.children("textarea")
  editor = textarea[0].editor
  editor.focus()
  setCursorToEndOfDoc(editor)
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


$(document).bind 'keydown', 'down', (ev) -> moveCellCursorDown()
$(document).bind 'keydown', 'up', (ev) -> moveCellCursorUp()
$(document).bind 'keydown', 'right', (ev) -> moveCellCursorRight()
$(document).bind 'keydown', 'left', (ev) -> moveCellCursorLeft()

$(document).keypress (ev) ->
  if ev.target.nodeName.toLowerCase() == "body"
    # we're not inside a textarea, create a new input cell
    inputCellDiv = $ '<div class="cell input"><textarea id="input_1" rows="3" cols="80"></textarea></div>'
    $(findOrCreateCellCursor()).replaceWith(inputCellDiv)
    textarea = inputCellDiv.children("textarea")[0]
    textarea.value = String.fromCharCode(ev.which)
    editor = makeInputCell(textarea)
    setCursorToEndOfDoc(editor)
    editor.focus()

$(".notebook").click (ev) ->
  if ev.target.className == 'notebook'
    point = {x: ev.pageX, y: ev.pageY}
    cells = $.nearest(point, ".cell")
    if point.y >= cells[0].offsetTop
      insertCellCursorAfter($(cells[0]))
    else
      insertCellCursorBefore($(cells[0]))


# Initialize the example notebook
# -------------------------------

makeInputCell = (inputCell) ->
  editor = CodeMirror.fromTextArea inputCell,
    mode: "coffeescript"
  inputCell.editor = editor
  addKeyMap editor, inputCell
  editor

makeInputCell(c) for c in $(".cell.input > textarea")
