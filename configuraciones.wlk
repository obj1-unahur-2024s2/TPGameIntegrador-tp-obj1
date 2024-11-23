import horda.*
import wollok.game.*
import naves.*
import municiones.*
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

  method terminarSiNoHayMasEnemigos(){
    if(!self.elJuegoEstaEnCurso()){
      niveles.youWin()
    }
  }
  method elJuegoEstaEnCurso(){
    return horda.filasEnemigas().size() >= 1
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

object niveles{
  var property position = game.at(0,0)
  method image()= "niveles.png"

  method fondoNivel(x, y){
    position = game.at(x, y)
  }

  method gameOver(){
    game.boardGround("gameOver.png")
    game.clear()
    game.schedule(300, {game.stop()})
  }
  method youWin(){
    game.addVisual(juego)
    game.schedule(100, {game.stop()})
  }
}

object juego{
  const property municionEnPantalla = []
  
  method configurarJuego(){
    game.boardGround("gameOver.png")
    game.height(10)
    game.width(10)
    game.cellSize(50)
  }
  method image()= "youWin.png"
  method agregarEntidad(unaEntidad){
    municionEnPantalla.add(unaEntidad)
  }

  method removerEntidad(unaEntidad){
    municionEnPantalla.remove(unaEntidad)
    game.removeVisual(unaEntidad)
  }
}