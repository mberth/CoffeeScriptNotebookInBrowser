# Return a stringt that gives a readable description of
# obj
displayPretty = (obj) ->
  if obj is undefined
    'undefined'
  else
    obj.toString()


addKeyMap = (editor, inputCell, outputCell) ->
  editor.addKeyMap
    name: "notebook",
    "Shift-Enter": (cm) ->
      # save editor contents to textarea
      cm.save()
      result = CoffeeScript.eval inputCell.value
      outputCell.text displayPretty(result)



makeInputCell = (inputCell, outputCell) ->
  editor = CodeMirror.fromTextArea inputCell,
    mode: "coffeescript"
  addKeyMap editor, inputCell, outputCell


for i in [1, 2]
  input = document.getElementById("input_#{i}")
  output = $("#output_#{i}")
  makeInputCell input, output
