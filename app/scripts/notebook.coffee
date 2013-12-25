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

addKeyMap = (editor, inputCell) ->
  editor.addKeyMap
    name: "notebook",
    "Shift-Enter": (cm) ->
      # save editor contents to textarea
      cm.save()
      evaluateCell(inputCell)



makeInputCell = (inputCell) ->
  editor = CodeMirror.fromTextArea inputCell,
    mode: "coffeescript"
  addKeyMap editor, inputCell


for i in [1, 2]
  input = document.getElementById("input_#{i}")
  makeInputCell input
