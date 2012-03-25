## Esto no es el readme oficial, sólo una explicación de lo que deberá hacer el código. El README oficial, se redactará para el initial commit.

## Para Ruby!

#### Código de ejemplo:

./robot.rb
#```ruby
class Robot

  # .
  # .
  # .

  tune_me_up style: :speaker,
    actions: [:say, :shout],
    create_methods: true,
    path: "speakers",
    file_name_pattern: /_speaker.rb$/,
    module_name_pattern: /Speaker$/,
    selector: :select_me,
    callback: :make_me_a_speaker,
    public_callback: false,
    styler: :inject_style

  # .
  # .
  # .

  def number
    rand 1..5
  end
  # .
  # .
  # .


end
#```

./reverse_speaker.rb

#```ruby
module ReverseSpeaker
  action :say do |frase|
    puts frase.reverse
  end

  action :shout do |frase|
    say(frase).upcase
  end

  def self.select_me(receiver) # Only if selector: :select_me
    return true if receiver.number == 1
  end
end
#```


#```ruby
r = Robot.new
#```

#### Descripción de lo que debería hacer

En un momento determinado (cuando se le indique) la instancia r de la clase Robot, deberá buscar en el directorio "./speakers" todos los archivos terminados en "_speaker.rb", levantar los módulos que haya adentro y agregarlos a un arreglo que será guardado en la clase Robot (para que sea accesible desde todas las instancias de Robot).

Deberá sobreescribir los métodos "say" y "shout" de la instancia a la que se aplica el tunning con los bloques que se definen en el módulo correspondiente (*Speaker) en las llamadas a:

#```ruby
action :say 
action :say
#```

Definidas en el módulo correspondiente.

Si agregamos 

#```ruby
create_methods: true
#```

deberá implementar en la instancia, los métodos "say" y "shout" que reciban "*args" y devuelvan nil (o algo). Si se pone _false_ no deberá hacerlo. La opciṕn por default es _true_ (*VER*)

Si tenemos:

#```ruby
selector: :select_me
#```

los módulos *Speaker deberán tener un método 

#```ruby
self.select_me(receiver)
#```

que devuelva _true_ o _false_ dependiendo de si el _receiver_ cumple con las condiciones para recibir ese estilo. 

En cambio, si tenemos:

#```ruby
selector: lambda { |receiver| return true if receiver.something == "something_else"  }
#```

éste se utilizará para determinar el estilo, dependiendo de si devuelve _true_ o _false_.

####Un ejemplo de uso:

#```ruby
class Robot
  tune_me_up #...
    selector: lambda { |receiver| return true if receiver.style == self.class  }
  
  def style
    ReverseSpeaker
  end
end
#```

Éste código deberá insertar el estilo ReverseSpeaker en las clases donde el método _style_ devuelva _ReverseSpeaker_.

Deberá inyectarse en la clase un método privado llamado "make_me_a_speaker", que contenga la lógica para aplicar el estilo. Ésta lógica sería: LLamar al selector (_self.select_) de cada uno de los módulos *Speaker y, si retorna true, llamar al styler (_self.inject_style_) del módulo que haya retornado true y retornar. (Se aplicará un solo estilo *VER*). A ambos métodos debe pasarle _self_ como único argumento para que hagan lo que tienen que hacer.

#### Política de inyección de estilo

La inyección del estilo se llevará a cabo cuando se llame al método "make_me_a_speaker". Éste método sólo podrá ser llamado desde dentro de la clase, ya que es privado. Para poder ser llamado desde afuera de la clase, ya que por defecto es privado.

Para hacerlo público deberá pasarse el parámetro 

#```ruby
public_callback: true
#```

a la llamada a _tune_me_up_ en la clase Robot.

Otra opción es implementar alguna función que llame al styler en algún caso en particular o en algún momento determinado.


## Para Rails!

#### Código de ejemplo:

./robot.rb
#```ruby
class Robot < ActiveRecord::Base
  after_find :make_me_a_speaker
  # .
  # .
  # .

  tune_me_up style: :speaker,
    actions: [:say, :shout],
    selector: :select_me

  # .
  # .
  # .

end
#```

./reverse_speaker.rb

#```ruby
module ReverseSpeaker
  action :say do |frase|
    puts frase.reverse
  end

  action :shout do |frase|
    say(frase).upcase
  end

  def self.select_me(receiver)  # Only if selector: :select_me
    return true if receiver.number == 1
  end
end
#```


#```ruby
r = Robot.first
#```

#### Descripción de lo que debería hacer

En éste caso se ha elegido inyectar el estilo luego de que se trae el objeto de la base de datos, pero podría utilizarse cualquier otra lógica para hacerlo. Para hacerlo, llama al método "make_me_a_speaker", que es el que usa por default la gema.

Éste código hace lo siguiente:

* Levanta todos los módulos que se encuentran en el directorio "<rails-app-root>/app/speakers/", cuyo nombre sea *Speaker (y que el nombre del archivo sea *_speaker.rb) y los coloca en un arreglo dentro de la clase.
* Elige el primer módulo que cumpla con las condiciones que imponga el selector (el primero que devuelva _true_), y ejecuta el método "inject_style" del módulo (que es el que se encarga de la lógica de inyección). Luego devuelve _true_ si aplicó el estilo o _false_ si no hubo coincidencia.
* Sobreescribe los métodos say y shout de la instancia _r_ por los del Speaker correspondiente
* El método "action" en el módulo indica el código que llevará el método correspondiente al primer argumento.

