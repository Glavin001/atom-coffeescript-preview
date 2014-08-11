###
# This file is the entry point of your package. It will be loaded once as a
# singleton.
#
# For more information:
# https://atom.io/docs/latest/creating-a-package#source-code
###

url = require 'url'
CoffeePreviewView = require './coffeescript-preview-view'
DeprecationView = require './deprecation-view.coffee'

module.exports =
  configDefaults:
    updateOnTabChange: true
    refreshDebouncePeriod: 100

  coffeePreviewView: null

  ###
  # This required method is called when your package is activated. It is passed
  # the state data from the last time the window was serialized if your module
  # implements the serialize() method. Use this to do initialization work when
  # your package is started (like setting up DOM elements or binding events).
  ###
  activate: (state) ->
    # console.log 'activate(state)'
    # console.log state
    atom.workspaceView.command 'coffeescript-preview:toggle', =>
      @toggle()

    # Display Deprecation warning
    @deprecationView = new DeprecationView()
    atom.workspaceView.appendToTop @deprecationView
    console.log @deprecationView
    
    atom.workspace.registerOpener (uriToOpen) ->
      try
        {protocol, host, pathname} = url.parse(uriToOpen)
      catch error
        return
      return unless protocol is 'coffeescript-preview:'
      try
        pathname = decodeURI(pathname) if pathname
      catch error
        return
      # Create and show preview!
      new CoffeePreviewView()

  ###
  # This optional method is called when the window is shutting down, allowing
  # you to return JSON to represent the state of your component. When the
  # window is later restored, the data you returned is passed to your module's
  # activate method so you can restore your view to where the user left off.
  ###
  serialize: ->
    console.log 'serialize()'

  ###
  # This optional method is called when the window is shutting down. If your
  # package is watching any files or holding external resources in any other
  # way, release them here. If you're just subscribing to things on window, you
  # don't need to worry because that's getting torn down anyway.
  ###
  deactivate: ->
    console.log 'deactivate()'

  toggle: ->
    editor = atom.workspace.getActiveEditor()
    return unless editor?
    uri = "coffeescript-preview://editor"
    previewPane = atom.workspace.paneForUri(uri)
    if previewPane
      previewPane.destroyItem(previewPane.itemForUri(uri))
      return
    previousActivePane = atom.workspace.getActivePane()
    atom.workspace.open(uri, split: 'right', searchAllPanes: true)
    .done (coffeePreviewView) ->
      if coffeePreviewView instanceof CoffeePreviewView
        coffeePreviewView.renderHTML()
        previousActivePane.activate()
