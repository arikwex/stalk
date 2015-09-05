GameController = require('./GameController')

class KeyboardController extends GameController
  constructor: (@target) ->
    @triggers = []
    @keys = new Array(256)
    @keydownCallback = => @keydown.apply(@, arguments)
    @keyupCallback = => @keyup.apply(@, arguments)
    document.addEventListener('keydown', @keydownCallback)
    document.addEventListener('keyup', @keyupCallback)
    return

  onDown: (inputs, method, params...) ->
    @register(inputs, 'any', method, params)
    return

  onPress: (inputs, method, params...) ->
    @register(inputs, 'press', method, params)
    return

  onRelease: (inputs, method, params...) ->
    @register(inputs, 'release', method, params)
    return

  onNone: (method, params...) ->
    @register([], 'none', method, params)
    return

  register: (inputs, context, method, params...) ->
    # Transform the input fields to custom inputKey objects
    inputKeys = []
    for input in inputs
      key = @convertToInputKey(input)
      inputKeys.push(key)

    # Trigger object
    trigger =
      context: context
      valid: (ctx, keys) ->
        inputsMatch = false
        for key in inputKeys
          correctContext = (@context == ctx or @context == 'any')
          correctKeyStatus = keys[key.code] ^ key.negate
          if not(correctContext and correctKeyStatus)
            return false
        return true
      invoke: (target) ->
        targetMethod = target[method]
        if targetMethod
          targetMethod.apply(target, params)
        return
    @triggers.push(trigger)
    return

  convertToInputKey: (input) ->
    negate = input.startsWith('!')
    if negate then input = input.substr(1)
    key =
      negate: negate
      code: KEYMAP[input.toLowerCase()]
    return key

  keydown: (evt) ->
    context = 'press'
    code = evt.keyCode
    if !@keys[code]
      context = 'press'
    else
      context = 'hold'
    @keys[code] = true
    @applyTriggers(context)
    return

  keyup: (evt) ->
    code = evt.keyCode
    @keys[code] = false
    @applyTriggers('release')
    return

  applyTriggers: (context) ->
    noneTriggered = true
    for trigger in @triggers
      if trigger.valid(context, @keys)
        if (trigger.context != 'none') or (trigger.context == 'none' and noneTriggered)
          trigger.invoke(@target)
          noneTriggered = false

module.exports = KeyboardController

KEYMAP =
  'shift': 16
  'left': 37
  'up': 38
  'right': 39
  'down': 40

for charCode in ['A'.charCodeAt(0)..'Z'.charCodeAt(0)]
  KEYMAP[String.fromCharCode(charCode).toLowerCase()] = charCode