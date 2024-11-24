import horda.*
import wollok.game.*
import naves.*
import municiones.*
import juego.*
// APARTADO APARTE PARA CONFIGURACIONES, YA QUE NO ES POSIBLE ACCEDER A LOS OBJETOS DENTRO DEL ARCHIVO .WPGM
object configurarNiveles{
  method initialize(){
    game.addVisual(niveles)
    self.pantallaDeInicio()
  }

  method cargarBase(){
    game.clear()
    game.addVisual(niveles)
    horda.comenzar()
    game.addVisual(jugador)
    configuracionDeControles.cargarControlesJugador()
  }

  method pantallaDeInicio(){
    niveles.fondoNivel(0, -10) // nivel 0
    configuracionDeControles.cargarControlesMenuPrincipal()
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

  method gameOver(){
    game.clear()
    game.schedule(200, {game.stop()})
  }
  method youWin(){
    game.clear()
    niveles.cambiarImagen("youWin.png")
    game.addVisual(niveles)
    game.schedule(200, {game.stop()})
  }

  method terminarSiNoHayMasEnemigos(){
    if(!self.elJuegoEstaEnCurso()){
      self.youWin()
    }
  }
  method elJuegoEstaEnCurso()= !horda.filasEnemigas().isEmpty()
}

object niveles{
  var property position = game.at(0,0)
  var imagenActual = "niveles.png"
  method image()= imagenActual

  method fondoNivel(x, y){
    position = game.at(x, y)
  }

  method cambiarImagen(unaImagen){
    imagenActual = unaImagen
    position = game.at(0, 0)
  }

}


object configuracionDeControles{
    method cargarControlesJugador(){
    keyboard.left().onPressDo {jugador.moverIzquierda()}
    keyboard.right().onPressDo {jugador.moverDerecha()}
    keyboard.space().onPressDo {jugador.disparar()}
  }
  
  method cargarControlesMenuPrincipal(){
    keyboard.num1().onPressDo {configurarNiveles.nivel1()}
    keyboard.num2().onPressDo {configurarNiveles.nivel2()}
    keyboard.num3().onPressDo {configurarNiveles.nivel3()}
  }
}


