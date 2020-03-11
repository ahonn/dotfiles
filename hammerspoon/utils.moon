utils =
  notify: (title, informativeText) =>
    hs.notify.new({
      title: title,
      informativeText: informativeText,
      withdrawAfter: 1,
    })\send!

  logger: (variable) =>
    print hs.inspect.inspect(variable)
utils
