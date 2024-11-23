import configuraciones.*
import wollok.game.*
import naves.*
import municiones.*
// OBJETOS, NAVES Y MISILES

object horda {
  const property filasEnemigas = []
  var filaActual = 9
  method agregarFila(){
    filasEnemigas.addAll([new NaveEnemiga(x=0, y=filaActual), new NaveEnemiga(x=2, y=filaActual), new NaveEnemiga(x=4, y=filaActual), new NaveEnemiga(x=6, y=filaActual), new NaveEnemiga(x=8, y=filaActual)])

    filaActual = 2.max(filaActual - 1)
  }

  method comenzar(){
    //game.onTick(1000, "ataqueHorda", {self.atacar()})
  }

  method atacar(){
    filasEnemigas.forEach({unaNave=>unaNave.disparar()})
  }

  method removerNave(unaNave){
    unaNave.alternarMovimiento()
    filasEnemigas.remove(unaNave)
    game.removeVisual(unaNave)
  }
}












class Explosion {
  var x
  var y
  var property position = game.at(x, y) 
  var imagenActual = "explosion1.png"


  method initialize(){
    game.addVisual(self)
    self.mostrarExplosion()
  }

  method image()= imagenActual

  method mostrarExplosion() {
    game.schedule(10, {self.cambiarImagen("explosion2.png")})
    game.schedule(50, {self.cambiarImagen("explosion2.png")})
    game.schedule(100, {self.cambiarImagen("explosion2.png")})
    game.schedule(150, {self.eliminarExplosion()})
  }

  method cambiarImagen(unaImagen){
    imagenActual= unaImagen
  }
  
  method eliminarExplosion(){
    game.removeVisual(self)
    juego.removerEntidad(self)
  }
}