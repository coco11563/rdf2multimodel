class KeyValueAdapter

  attr_reader :data

  def initialize(data)
    @data = data
  end

  def insert_data
    data.each do |triple|
      save_triple_sp(triple)
      save_triple_p(triple)
    end
  end

  # sp = Subejct Predicate
  def save_triple_sp(triple)
    redis.sadd(key_sp(triple), value_sp(triple))
  end

  def load_data
    key = "#{data.first}:#{data.second}"

    render json: redis.smembers(key), head: :ok
  end

  def key_sp(triple)
    "#{triple.first}:#{triple.second}"
  end

  def value_sp(triple)
    triple[2]
  end

  # p = predicate
  def save_triple_p(triple)
    redis.sadd(key_p(triple), value_p(triple))
  end

  def key_p(triple)
    triple.second
  end

  def value_p(triple)
    "#{triple.first}:#{triple.second}:#{triple.last}"
  end

  private

  def redis
    Redis.new
  end
end
