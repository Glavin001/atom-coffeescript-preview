path = require 'path'
{$, $$$, ScrollView} = require 'atom'
coffeescript = require 'coffee-script'
_ = require 'underscore-plus'
nsh = require('node-syntaxhighlighter')
languageJS =  nsh.getLanguage('js')

module.exports =
class CoffeePreviewView extends ScrollView
  atom.deserializers.add(CoffeePreviewView)

  @deserialize: (state) ->
    new CoffeePreviewView(state)

  @content: ->
    @div
      class: 'coffeescript-preview native-key-bindings'
      tabindex: -1

  constructor: ({@editorId, filePath}) ->
    super

    if @editorId?
      @resolveEditor(@editorId)
    else
      if atom.workspace?
        @subscribeToFilePath(filePath)
      else
        @subscribe atom.packages.once 'activated', =>
          @subscribeToFilePath(filePath)

    # Update on Tab Change
    atom.workspaceView.on 'pane-container:active-pane-item-changed', =>
      updateOnTabChange =
        atom.config.get 'coffeescript-preview.updateOnTabChange'
      if updateOnTabChange
        currEditor = atom.workspace.getActiveEditor()
        if currEditor?
          grammar = currEditor.getGrammar().name
          if grammar is "CoffeeScript" or grammar is "CofffeeScript (Literate)"
            #console.log grammar
            @editor = currEditor
            @changeHandler()

  serialize: ->
    deserializer: 'CoffeePreviewView'
    filePath: @getPath()
    editorId: @editorId

  destroy: ->
    @unsubscribe()

  subscribeToFilePath: (filePath) ->
    @trigger 'title-changed'
    @handleEvents()
    @renderHTML()

  resolveEditor: (editorId) ->
    resolve = =>
      @editor = @editorForId(editorId)

      if @editor?
        @trigger 'title-changed' if @editor?
        @handleEvents()
      else
        # The editor this preview was created for has been closed so close
        # this preview since a preview cannot be rendered without an editor
        @parents('.pane').view()?.destroyItem(this)

    if atom.workspace?
      resolve()
    else
      @subscribe atom.packages.once 'activated', =>
        resolve()
        @renderHTML()

  editorForId: (editorId) ->
    for editor in atom.workspace.getEditors()
      return editor if editor.id?.toString() is editorId.toString()
    null

  handleEvents: ->

    if @editor?
      @subscribe(@editor.getBuffer(), 'contents-modified', @changeHandler)
      @subscribe @editor, 'path-changed', => @trigger 'title-changed'

  changeHandler: =>
    @renderHTML()
    pane = atom.workspace.paneForUri(@getUri())
    if pane? and pane isnt atom.workspace.getActivePane()
      pane.activateItem(this)

  renderHTML: ->
    @showLoading()
    if @editor?
      @renderHTMLCode(@editor.getText())

  renderHTMLCode: (text) =>
    try
      js = coffeescript.compile text
      html = nsh.highlight js, languageJS
      @html $ html
    catch e
      console.log e
      return @showError e

    @trigger 'coffeescript-preview:html-changed'

  getTitle: ->
    if @editor?
      "#{@editor.getTitle()} Preview"
    else
      "CoffeeScript Preview"

  getUri: ->
    "coffee-preview://editor/#{@editorId}"

  getPath: ->
    if @editor?
      @editor.getPath()

  showError: (result) ->
    failureMessage = result?.message

    @html $$$ ->
      @div
        class: 'coffee-preview-spinner'
        style: 'text-align: center'
        =>
          @span
            class: 'loading loading-spinner-large inline-block'
          @div
            class: 'text-highlight',
            'Previewing CoffeeScript Failed\u2026'
            =>
              @div
                class: 'text-error'
                failureMessage if failureMessage?
          @div
            class: 'text-warning'
            result?.stack

  showLoading: ->
    @html $$$ ->
      @div
        class: 'coffee-preview-spinner'
        style: 'text-align: center'
        =>
          @span
            class: 'loading loading-spinner-large inline-block'
          @div
            class: 'text-highlight',
            'Loading HTML Preview\u2026'
