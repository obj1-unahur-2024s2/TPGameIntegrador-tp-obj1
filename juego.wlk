import horda.*
import municiones.*
import configuraciones.*
import wollok.game.*
object juego{
  const property municionEnPantalla = []
  
  method configurarJuego(){
    game.boardGround("gameOver.png")
    game.height(10)
    game.width(10)
    game.cellSize(50)
  }
  method agregarEntidad(unaEntidad){
    municionEnPantalla.add(unaEntidad)
  }
  method removerEntidad(unaEntidad){
    municionEnPantalla.remove(unaEntidad)
    game.removeVisual(unaEntidad)
  }
}