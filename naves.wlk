import horda.*
import municiones.*
import configuraciones.*
import wollok.game.*

class Nave{
  method image()
  method disparar()
}

object jugador inherits Nave{
  var property position = game.at(5, 0)
  var property misilCargado= 0 // MUNISION 
  var imagenActual = "naveJugador.png"

  method initialize(){
    game.schedule(200, {self.alternarImagen()})
  }
  method moverIzquierda() {
    if (position.x()>0) position = position.left(1)
    }
  method moverDerecha() {
    if (position.x()<game.width()-1) position = position.right(1)
    }
  method cargarMisil(unMisil) {
    misilCargado=unMisil
  }
  override method image() = imagenActual
  override method disparar(){
    juego.agregarEntidad(new MisilPropio(x=self.position().x(), y=self.position().y()+1))
  }
  method serImpactado(){
    niveles.gameOver()
  }
  method alternarImagen(){
    if (imagenActual == "naveJugador.png"){
        imagenActual = "naveJugador2.png"
    }else{
        imagenActual = "naveJugador.png"
    }  
  }
}

class NaveEnemiga inherits Nave{
  var property x
  var property y
  var property position = game.at(x, y)
  var property direccion = 1 // 1 = derecha, -1 = izquierda
  var property puedeMover = false
  
  method initialize(){
    game.addVisual(self)
    game.schedule(3000, {self.alternarMovimiento()})
    game.onTick(300, "avanzar", {self.moverseSiPuede()})
  }

  method alternarMovimiento(){
    puedeMover = !puedeMover
  }
  method moverseSiPuede(){
    if(puedeMover){
      self.mover()
      self.invadirSiSePuede()
    }
  }
  method mover(){
    position = position.right(direccion)
    if (position.x() >= game.width() - 1) {
      position = position.down(1)
      direccion = -1
    }
    if (position.x() <= 0) {
      position = position.down(1)
      direccion = 1
    } 
  }
  override method image()= "naveEnemiga.png"
  override method disparar(){
      if((0.. 2).anyOne() == 1){
        juego.agregarEntidad(new MisilEnemigo(x=self.position().x(), y=self.position().y()-1))
      }
  }
  method serImpactado(unaCosa){
    niveles.gameOver()
  }
  method invadirSiSePuede(){
    if (self.position().y() == 0){
      game.removeTickEvent("avanzar")
      game.schedule(500, {niveles.gameOver()})
    }
  }
}

