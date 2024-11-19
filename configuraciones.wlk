import porNestor.*
import wollok.game.*
// APARTADO APARTE PARA CONFIGURACIONES, YA QUE NO ES POSIBLE ACCEDER A LOS OBJETOS DENTRO DEL ARCHIVO .WPGM
object configurarNiveles{

  method initialize(){
    game.addVisual(niveles)
    niveles.fondoNivel(0, -10) // nivel 0
    self.cargarControlesMenuPrincipal()
  }

  method cargarBase(){
    game.clear()
    game.addVisual(niveles)
    horda.initialize()
    game.addVisual(jugador)
    self.cargarControlesJugador()
  }

  method nivel1(){
    self.cargarBase()
    niveles.fondoNivel(-10, -10) // nivel 1
    horda.agregarFila()
  }
  method nivel2(){
    self.cargarBase()
    niveles.fondoNivel(0, 0) // nivel 2
    horda.agregarFila()
    horda.agregarFila()
  }
  method nivel3(){
    self.cargarBase()
    niveles.fondoNivel(-10, 0) // nivel 3
    horda.agregarFila()
    horda.agregarFila()
    horda.agregarFila()
  }

  method elJuegoInicio(){
    return horda.filasEnemigas().size() >= 1
  }

  method cargarControlesJugador(){
    keyboard.left().onPressDo { jugador.moverIzquierda() }
    keyboard.right().onPressDo { jugador.moverDerecha() }
    keyboard.space().onPressDo {jugador.disparar()}
  }
  
  method cargarControlesMenuPrincipal(){
    keyboard.num1().onPressDo {self.nivel1()}
    keyboard.num2().onPressDo {self.nivel2()}
    keyboard.num3().onPressDo {self.nivel3()}
  }
}

object niveles{
  var property position = game.at(0,0)
  method image()= "niveles.png"

  method fondoNivel(x, y){
    position = game.at(x, y)
  }

  method gameOver(){
    game.clear()
    game.schedule(300, {game.stop()})
  }
}