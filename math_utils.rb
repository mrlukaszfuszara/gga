class MathUtils
  def vectors_add(vector1, vector2)
    result = Array.new
    if vector1.size == vector2.size
      for i in 0...vector1.size
        result[i] = vector1[i] + vector2[i]
      end
    else
      puts 'ERROR VECTOR ADD: Vectors size is not equal.'
    end
    result
  end
  
  def vectors_sub(vector1, vector2)
    result = Array.new
    if vector1.size == vector2.size
      for i in 0...vector1.size
        result[i] = vector1[i] - vector2[i]
      end
    else
      puts 'ERROR VECTOR SUB: Vectors size is not equal.'
    end
    result
  end
  
  def vectors_mult(vector1, vector2)
    result = Array.new
    if vector1.size == vector2.size
      for i in 0...vector1.size
        result[i] = vector1[i] * vector2[i]
      end
    else
      puts 'ERROR VECTOR MULT: Vectors size is not equal.'
    end
    result
  end
  
  def vectors_div(vector1, vector2)
    result = Array.new
    if vector1.size == vector2.size
      for i in 0...vector1.size
        if !vector2[i].zero?
          result[i] = vector1[i] / vector2[i]
        else
          puts 'ERROR VECTOR DIV: Vector two value equals to zero.'
        end
      end
    else
      puts 'ERROR VECTOR DIV: Vectors size is not equal.'
    end
    result
  end
  
  def vectors_dot(vector1, vector2, alpha = 0)
    result = 0
    if vector1.size == vector2.size
      for i in 0...vector1.size
        result[i] += vector1[i] * vector2[i] * Math.cos(alpha)
      end
    else
      puts 'ERROR VECTOR DOT: Vectors size is not equal.'
    end
    result
  end
  
  def matrices_add(matrix1, matrix2)
    result = Array.new
    if matrix1.size == matrix2.size
      if matrix1.first.size == matrix2.first.size
        for i in 0...matrix1.size
          result[i] = vectors_add(matrix1[i], matrix2[i])
        end
      else
        puts 'ERROR MATRIX ADD: Matrices columns not match.'
      end
    else
      puts 'ERROR MATRIX ADD: Matrices rows not match.'
    end
    result
  end
  
  def matrices_sub(matrix1, matrix2)
    result = Array.new
    if matrix1.size == matrix2.size
      if matrix1.first.size == matrix2.first.size
        for i in 0...matrix1.size
          result[i] = vectors_sub(matrix1[i], matrix2[i])
        end
      else
        puts 'ERROR MATRIX SUB: Matrices columns not match.'
      end
    else
      puts 'ERROR MATRIX SUB: Matrices rows not match.'
    end
    result
  end
  
  def matrices_mult(matrix1, matrix2)
    result = Array.new
    if matrix1.first.size == matrix2.size
      for i in 0...matrix1.size
        result[i] = Array.new
        for j in 0...matrix2.first.size
          sum = 0
          for k in 0...matrix1.first.size
            sum += matrix1[i][k] * matrix2[k][j]
          end
          result[i] << sum
        end
      end
    else
      puts 'ERROR MATRIX MULT: Dimensions mismatch.'
    end
    result
  end
  
  def identity_function(vector)
    vector
  end
  def identity_derivative(vector)
    vector.map { |x| 1.0 }
  end
  
  def logistic_function(vector)
    vector.map { |x| 1.0 / (1.0 + Math.exp(-x)) }
  end
  def logistic_derivative(vector)
    vector.map { |x| (1.0 / (1.0 + Math.exp(-x))) * (1.0 - (1.0 / (1.0 + Math.exp(-x)))) }
  end
  
  def tanh_function(vector)
    vector.map { |x| Math.tanh x }
  end
  def tanh_derivative(vector)
    vector.map { |x| 1.0 - (Math.tanh(x))**2 }
  end
  
  def arctan_function(vector)
    vector.map { |x| Math.atan(x) }
  end
  def arctan_derivative(vector)
    vector.map { |x| 1.0 / (x**2 + 1) }
  end
  
  def softsign_function(vector)
    vector.map { |x| x / (1.0 + x.abs) }
  end
  def softsign_derivative(vector)
    vector.map { |x| 1.0 / (1.0 + x.abs)**2 }
  end
  
  def relu_function(vector)
    vector.map do |x|
      if x <= 0.0
        0.0
      else
        x
      end
    end
  end
  def relu_derivative(vector)
    vector.map do |x|
      if x <= 0.0
        0.0
      else
        1.0
      end
    end
  end
  
  def softplus_function(vector)
    vector.map { |x| Math.log(1.0 + Math.exp(x)) }
  end
  def softplus_derivative(vector)
    vector.map { |x| 1.0 / (1.0 + Math.exp(-x)) }
  end
  
  def cost_function(y_predicted, y_assumed)
    result = Array.new
    if y_predicted.size == y_assumed.size
    for i in 0...y_predicted.size
        result[i] = (y_predicted[i] - y_assumed[i])**2
      end
      result = -1.0 * (1.0 / y_assumed.size) * result.inject(0, :+)
    else
      puts 'ERROR COST FUNCTION: y size not match.'
    end
    result
  end
end
