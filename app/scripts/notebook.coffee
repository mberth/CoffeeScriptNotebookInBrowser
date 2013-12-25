cell = document.getElementById("cell1")
editor = CodeMirror.fromTextArea cell,
  mode: "coffeescript"

display_pretty = (obj) ->
  if obj is undefined
    'undefined'
  else
    obj.toString()

output = $("p.output")

editor.addKeyMap
  name: "notebook",
  "Shift-Enter": (cm) ->
    # save editor contents to textarea
    cm.save()
    result = CoffeeScript.eval cell.value
    output.text display_pretty(result)

