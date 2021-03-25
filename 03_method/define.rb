# Q1.
# 次の動作をする A1 class を実装する
# - "//" を返す "//"メソッドが存在すること
class A1
  define_method('//') do
    '//'
  end
end

# Q2.
# 次の動作をする A2 class を実装する
# - 1. "SmartHR Dev Team"と返すdev_teamメソッドが存在すること
# - 2. initializeに渡した配列に含まれる値に対して、"hoge_" をprefixを付与したメソッドが存在すること
# - 2で定義するメソッドは下記とする
#   - 受け取った引数の回数分、メソッド名を繰り返した文字列を返すこと
#   - 引数がnilの場合は、dev_teamメソッドを呼ぶこと
# - また、2で定義するメソッドは以下を満たすものとする
#   - メソッドが定義されるのは同時に生成されるオブジェクトのみで、別のA2インスタンスには（同じ値を含む配列を生成時に渡さない限り）定義されない
class A2

  def initialize(args)
    args.each do |arg|
      method_name = "hoge_#{arg}"
      # define_methodだと
      # NoMethodError: undefined method `define_method' for #<A2:0x000055f44913f1f8>
      # Did you mean?  define_singleton_method
      define_singleton_method(method_name) do |n|
        return dev_team if n.nil?
        method_name * n
      end
    end
  end

  def dev_team
    'SmartHR Dev Team'
  end
end


# Q3.
# 次の動作をする OriginalAccessor モジュール を実装する
# - OriginalAccessorモジュールはincludeされたときのみ、my_attr_accessorメソッドを定義すること
# - my_attr_accessorはgetter/setterに加えて、boolean値を代入した際のみ真偽値判定を行うaccessorと同名の?メソッドができること

module OriginalAccessor
  # https://www.techscore.com/blog/2013/03/01/rails-include%E3%81%95%E3%82%8C%E3%81%9F%E6%99%82%E3%81%AB%E3%82%AF%E3%83%A9%E3%82%B9%E3%83%A1%E3%82%BD%E3%83%83%E3%83%89%E3%81%A8%E3%82%A4%E3%83%B3%E3%82%B9%E3%82%BF%E3%83%B3%E3%82%B9%E3%83%A1/
  # ライブラリを使用する時に、提供されているモジュールを include すれば良いのか、extend すれば良いのか迷うこともあると思います。
  # えぇーい、面倒くさい！ ということで生まれたかどうかは知りませんが、モジュールに関する頻出パターンをご紹介します。
  # 「モジュールが include された時に、クラスメソッドとインスタンスメソッドの両方を追加する」という手法です。
  # この手法を使うと、何も考えずに include すれば便利なクラスメソッドやインスタンスメソッドが使えるようになるモジュールを作ることができます。

  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def my_attr_accessor(arg)
      define_method(arg) do
        instance_variable_get("@#{arg}")
      end

      define_method("#{arg}=") do |n|
        if [true, false].include?(n)
          define_singleton_method("#{arg}?") do
            !!send(arg)
          end
        end
        instance_variable_set("@#{arg}", n)
      end
    end
  end
end
