require './math_utils'

class Individual
  attr_accessor :var, :fits, :active_payoff, :passive_payoff
  
  def initialize
    @var = Array.new
  end
end

class GeneticUtils
  def initialize(vector, y, size = 200, maxe = 1000)
    @up = 1.0
    @down = 0.0
    @nc = 15
    @nm = 20
    @p1 = 0.9
    @p2 = 0.02
    @p3 = 0.1
    @w1 = 0.9
    @w2 = 0.01
    @s_suc = 0
    @s_num = 0
    @math = MathUtils.new
    @vector = vector
    @vector_size = vector.size
    @y = y
    @size = size
    @maxe = maxe
    @evolutions = 0
  end
  
  def gameea
    # Init population
    @population = Array.new
    for i in 0...@size
      @population[i] = Individual.new
      @population[i].var = @vector.map { |e| e + Random.rand(0.0..0.25) }
      @population[i].active_payoff = 0
      @population[i].passive_payoff = 0
      @evolutions += 1
    end
    # Init best
    @best = Individual.new
    @best.var = 0.0
    @best.active_payoff = -1
    @best.passive_payoff = -1

    for i in 0...@size
      @population[i].fits = calc_fitness(@population[i].var)
    end
    
    find_best
    
    while @evolutions < @maxe
      for i in 0...@size
        game_evolution(i)
        @evolutions += 1
      end
      find_best
    end
    
    @best.var
  end
  
  def calc_fitness(var)
    @math.cost_function(var, @y)
  end
  
  def find_best
    if @best.active_payoff != -1 && @best.passive_payoff != -1
      best_index = find_best_index
      if @best.fits < @population[best_index].fits
        @best.fits = @population[best_index].fits
        @best.var = @population[best_index].var
        @best.active_payoff = @population[best_index].var
        @best.passive_payoff = @population[best_index].var
      end
    else
      best_index = find_best_index
      @best.fits = @population[best_index].fits
      @best.var = @population[best_index].var
      @best.active_payoff = @population[best_index].var
      @best.passive_payoff = @population[best_index].var
    end
  end
  
  def find_best_index
    best_index = 0
    for i in 0...@size
      best_index = i if @population[best_index].fits < @population[i].fits
    end
    best_index
  end
  
  def game_evolution(index)
    rd = Random.rand(0...@size)
    loop do
      rd = Random.rand(0...@size)
      break if rd != index
    end
    tmp_count = @population[index].active_payoff + @population[index].passive_payoff
    
    if tmp_count == 0
      improve_gene(index, rd) if Random.rand(0.0..1.0) > @p1
    elsif Random.rand(0..1) > (@population[rd].passive_payoff * @w2) / ((@population[index].active_payoff + @population[index].passive_payoff) * @w1 + @population[rd].passive_payoff * @w2)
      improve_gene(index, rd)
    else
      change_gene(index) if Random.rand(0.0..1.0) > @p2
    end
  end
  
  def improve_gene(improved_index, helper_index)
    flag = true
  
    if @population[improved_index].fits > @population[helper_index].fits
      @population[improved_index].active_payoff += 1
    else
      @population[helper_index].passive_payoff += 1
    end
    
    tmp_index = Individual.new
    tmp_index.fits = @population[improved_index].fits
    tmp_index.var = @population[improved_index].var
    tmp_index.active_payoff = @population[improved_index].var
    tmp_index.passive_payoff = @population[improved_index].var
    
    rd = Random.rand(0...@vector_size)
    
    if speculation
      rdx = Random.rand(0...@vector_size)
      tmp_index.var[rdx] = 0.5 * ((1 - beta) * @population[improved_index].var[rd] + (1 + beta) * @population[helper_index].var[rd])
      tmp_index.var[rdx] = Random.rand(@down..@up) if tmp_index.var[rdx] < @down || tmp_index.var[rdx] > @up
      calc_fitness(tmp_index.var, tmp_index.fits)
      if @population[improved_index].fits < tmp_index.fits
        flag = false
        @s_suc += 1
      end
    else
      tmp_index.var[rd] = 0.5 * ((1 - beta) * @population[improved_index].var[rd] + (1 + beta) * @population[helper_index].var[rd])
      tmp_index.var[rd] = Random.rand(@down..@up) if tmp_index.var[rd] < @down || tmp_index.var[rd] > @up
      calc_fitness(tmp_index.var)
      if @population[improved_index].fits < tmp_index.fits
        flag = false
      end
    end
    
    if !flag
      @population[improved_index].fits = tmp_index.fits
      @population[improved_index].var = tmp_index.var
      @population[improved_index].active_payoff = tmp_index.active_payoff
      @population[improved_index].passive_payoff = tmp_index.passive_payoff
    end
  end
  
  def change_gene(index)
    rd = Random.rand(0...@vector_size)
    
    @population[index].var[rd] += (@up - @down) * delta
    
    @population[index].var[rd] = Random.rand(@down..@up) if @population[index].var[rd] > @up || @population[index].var[rd] < @down
    
    calc_fitness(@population[index].var)
  end
  
  def speculation
    flag = false
    rd = @p3 * (1 + (2 * @s_suc - @s_num) / (@s_num + 1))
    if Random.rand(0.0..1.0) < rd
      flag = false
      @s_num += 1
    end
    flag
  end
  
  def beta
    bu = 0.0
    u = Random.rand(0.0..1.0)
    if u < 0.5
      bu = (2.0 * u)**(@nc + 1)
    else
      bu = (2 * (1.0 - u))**(@nc + 1)
    end
    bu
  end
  
  def delta
    du = 0.0
    u = Random.rand(0.0..1.0)
    if u < 0.5
      du = (2.0 * u)**(1.0 / (@nm + 1)) - 1
    else
      du = 1 - (2.0 * (1.0 - u))**(1.0 / (@nm + 1))
    end
    du
  end
end

t = GeneticUtils.new([0.45, 0.55, 0.35, 0.45, 0.55, 0.35, 0.45, 0.55, 0.35, 0.45, 0.55, 0.35], [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5])
t1 = t.gameea

t2 = MathUtils.new
p t1
p t2.cost_function(t1, [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5])