Application.controller 'colorpickerController',
['$scope', 'Color', 'Theme', ($scope, Color, Theme) ->

  $scope.picker_options = { inline: true, letterCase: 'uppercase' }
  $scope.Theme = Theme
  $scope.colorpalette = []
  $scope.color = {
    hex: null
    alpha: 1
    rgba: {}
    hsla: {}
    hsva: {}
  }

  $scope.update_current_color = (new_color) ->
    $scope.CP.rule[$scope.CP.selector] = Color.tm_encode(Color.tm_decode(new_color))

  $scope.update_alpha = ->
    current_color = Color.tm_decode($scope.CP.rule[$scope.CP.selector])
    current_color.setAlpha($scope.color.alpha/100)
    $scope.CP.rule[$scope.CP.selector] = Color.tm_encode(current_color)

  update_colors = (color) ->
    return unless color
    decoded_color = Color.tm_decode($scope.CP.rule[$scope.CP.selector])

    rgba = decoded_color.toRgb()
    hsla = decoded_color.toHsl()
    hsva = decoded_color.toHsv()

    hsla.h = hsla.h.round()
    hsla.s = (hsla.s*100).round()
    hsla.l = (hsla.l*100).round()

    hsva.h = hsva.h.round()
    hsva.s = (hsva.s*100).round()
    hsva.v = (hsva.v*100).round()

    $scope.color.hex = decoded_color.toHexString()
    $scope.color.alpha = (hsla.a*100).round()
    $scope.color.rgba = rgba
    $scope.color.hsla = hsla
    $scope.color.hsva = hsva

  $scope.$watch 'Theme.json', (-> $scope.colorpalette = $scope.Theme.color_palette()), true
  $scope.$watch 'Theme.gcolors', (-> $scope.colorpalette = $scope.Theme.color_palette()), true

  $scope.$watch "CP.rule[CP.selector]", update_colors
  $scope.$watch "color.hex", (color) ->
    return unless color
    current_color = Color.tm_decode($scope.color.hex)
    current_color.setAlpha($scope.color.alpha/100)
    $scope.CP.rule[$scope.CP.selector] = Color.tm_encode(current_color)

  $scope.select_color_from_palette = (color) ->
    $scope.CP.rule[$scope.CP.selector] = Color.tm_encode(color)

  $scope.slider_gradient = (source, base, min, max, step) ->
    checkboard_bg = 'url(data:image/png;charset=utf-8;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAAAAACoWZBhAAAAFklEQVR4AWP4DwJnQIAkJpgE80lhAgBENVmnMdln/AAAAABJRU5ErkJggg==)'
    steps = []
    for value in [min..max] by step
      step_color = angular.copy(source)
      step_color[base] = value
      steps.push "#{Color.tm_decode(step_color).toHslString()} #{(value/max)*100}%"
    "background-image: linear-gradient(to right, #{steps.join(',')}), #{checkboard_bg};"

  return
]
