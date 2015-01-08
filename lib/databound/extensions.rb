def swallow_nil
  yield
rescue NoMethodError
  nil
end
