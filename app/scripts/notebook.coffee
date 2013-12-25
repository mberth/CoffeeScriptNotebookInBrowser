# Return a stringt that gives a readable description of
# obj
displayPretty = (obj) ->
  if obj is undefined
    'undefined'
  else
    obj.toString()

evaluateCell = (inputCell, outputCell) ->
  try
    result = CoffeeScript.eval inputCell.value
    editorDiv = $(inputCell).next(".CodeMirror")

    existingOutput = editorDiv.next(".cell.output")
    existingOutput.remove()
    newOutputCell = $('<p class="cell output"></p>')

    editorDiv.after newOutputCell
    newOutputCell.text displayPretty(result)

  catch error
    console.error error
    outputCell.html displayPretty(error) + "<br>See console for details."
    outputCell.addClass "error"

addKeyMap = (editor, inputCell, outputCell) ->
  editor.addKeyMap
    name: "notebook",
    "Shift-Enter": (cm) ->
      # save editor contents to textarea
      cm.save()
      evaluateCell(inputCell, outputCell)



makeInputCell = (inputCell, outputCell) ->
  editor = CodeMirror.fromTextArea inputCell,
    mode: "coffeescript"
  addKeyMap editor, inputCell, outputCell


for i in [1, 2]
  input = document.getElementById("input_#{i}")
  output = $("#output_#{i}")
  makeInputCell input, output
