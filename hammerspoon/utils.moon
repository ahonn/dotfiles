utils =
  notify: (title, informativeText) =>
    hs.notify.new({
      title: title,
      informativeText: informativeText,
      withdrawAfter: 1,
    })\send!

  alert: (message) =>
    hs.alert.show(message)

  inspect: (variable) =>
    print hs.inspect.inspect(variable)
utils
