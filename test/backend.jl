xs = rand(20)
d = Affine(20, 10)

@tfonly let dt = tf(d)
  @test d(xs) ≈ dt(xs)
end

@mxonly let dm = mxnet(d, (1, 20))
  @test d(xs) ≈ dm(xs)
end

# TensorFlow native integration

@tfonly let
  using TensorFlow

  sess = TensorFlow.Session()
  X = placeholder(Float32)
  Y = Tensor(d, X)
  run(sess, initialize_all_variables())

  @test run(sess, Y, Dict(X=>xs')) ≈ d(xs)'
end
