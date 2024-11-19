
import wollok.game.*

object horda {
  var property nivel = 1 // construir lógica para seleccionar niveles.
  var property cantEnemigos = 1
  const property filasEnemigas = []
  var property filaActual = 9
  method agregarFila(){
    self.filasEnemigas().add([new NaveEnemiga(x=1, y=filaActual), new NaveEnemiga(x=2, y=filaActual), new NaveEnemiga(x=3, y=filaActual), new NaveEnemiga(x=4, y=filaActual), new NaveEnemiga(x=5, y=filaActual), new NaveEnemiga(x=6, y=filaActual), new NaveEnemiga(x=7, y=filaActual) ,new NaveEnemiga(x=8, y=filaActual)])
    filaActual = 2.max(filaActual - 1)
  }

  method initialize(){
    game.onTick(3000, "ataqueHorda", {self.atacar()})
  }

  method atacar(){
    self.filasEnemigas().last().forEach({x=>x.disparar()})
  }

}


class NaveEnemiga{
  var property x
  var property y
  var property position = game.at(self.x(), self.y())
  var property direccion = 1 // 1 = derecha, -1 = izquierda
  var property puedeMover = false
  method esElJugador()= false
  method initialize(){
    game.addVisual(self)
    game.onTick(10000, "inicio", {puedeMover = true})
    game.onTick(500, "movimiento", {self.mover()})
  }

    method mover(){
      if(puedeMover){
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
    }

  method image() = "naveEnemiga.png"
  method disparar(){
    if(0.randomUpTo(5).truncate(0) == 0 and puedeMover){
      game.addVisual(new MisilEnemigo(x=self.position().x(), y=self.position().y()-1))
    }
  }
}


class Misil{
    var property x
    var property y
    var property position = game.at(x, y)
    var property imagenActual = "misil_up1.png"

    method image()= imagenActual
    method initialize(){
        game.onTick(200, "animacion_misil", {self.cambiarImagen()})
        game.onTick(200, "avanzar", {self.avanzar()})
        game.onCollideDo(self, {enemigo=>
          game.removeVisual(enemigo)
          game.removeVisual(self)
          } )
    }
    method cambiarImagen()
    method avanzar()
    method seSalioDelTablero(){
        return (self.position().y() == game.height()-1) or (self.position().y() == (-1))
    }
}

class MisilPropio inherits Misil{
    override method cambiarImagen(){
        if (imagenActual == "misil_up1.png"){
            imagenActual = "misil_up2.png"
        }else{
            imagenActual = "misil_up1.png"
        }  
    }
    override method avanzar(){
        if(self.seSalioDelTablero()){
            game.removeVisual(self)
        }
        position = position.up(1)
    }
}

class MisilEnemigo inherits Misil{
    override method initialize(){
        game.onTick(200, "animacion_misil", {self.cambiarImagen()})
        game.onTick(200, "avanzar", {self.avanzar()})
        game.onCollideDo(self, {enemigo=>if(enemigo.esElJugador()){game.removeVisual(enemigo)} }) // daña solo al jugador
    }
    override method cambiarImagen(){
        if (imagenActual == "misil_down1.png"){
            imagenActual = "misil_down2.png"
        }else{
            imagenActual = "misil_down1.png"
        }  
    }
    override method avanzar(){
        if(self.seSalioDelTablero()){
            game.removeVisual(self)
        }
        position = position.down(1)
    }
}


object jugador {
  var property position = game.at(5, 0)
  var property misilCargado= misil

  method esElJugador()= true
  // Mover izquierda o derecha, luego deberiamos ponerlo dentro de configurar teclado
  method moverIzquierda() {
    if (position.x()>0) position = position.left(1)
  }

  method moverDerecha() { if (position.x()<game.width()-1) position = position.right(1)}

  method cargarMisil(unMisil) {
    misilCargado=unMisil
  }

 

  method image() = "naveJugador.png"


  method disparar(){
    game.addVisual(new MisilPropio(x=self.position().x(), y=self.position().y()+1))
  }
}




//  Me faltó
// Hacer una sola clase de misil, creo que Misil Doble sería una clase aparte ya que tendría 2 posiciones distintas
// Hacer funsionar la explosión
// Ver si es posible hacer una sola clase Nave y de ahí derivar la NaveEnemiga y al jugador
// optimizar algunos métodos e incluír la lógica de disparos y adaptar al polimorfísmo.
//
//

class Misild {
  var property position = game.at(0, -1)
  var property enMovimiento = false

  method image()// la hace abstracta

  method initialize(){ // apenas aparezca el misil, se mueva hacia adelante y si toca al enemigo, lo elimina
    game.onTick(50, "moverMisil", {jugador.misilCargado().mover() })
    game.onCollideDo(self, {enemigo=>enemigo.enElBlanco(self)})
  }

  method disparar() {
    if (!enMovimiento) {
      enMovimiento = true
       self.posicion(jugador.position())   // al misil lo ponemos arriba de la nave
    }
  }

  method posicion(unaPosicion) { position= unaPosicion}

  method mover() {
    if (enMovimiento) {
       position = position.up(1)

    // Controlamos si el misil sale de lapantalla
      if (position.y() > game.height()) {
        enMovimiento = false
        position = game.at(0, -1)
      }
    }
  }




}

class MisilSimple inherits Misild{
    
    override method image() = "misil.png"
}

class MisilDoble inherits Misild{
    override method image() = "misildoble1.png"     
}


const misil= new MisilSimple()
const misilDoble= new MisilDoble()

//---------------------------

object explosion {
  var property position = game.at(0, 0) 
  var property imagen = "explosionchica.png" 



  method mostrar(pos) {
    position = pos
    game.addVisual(self)

  }


  method ocultar() {
    game.removeVisual(self)
  }

    method enElBlanco(unMisil) {
   /* game.removeVisual(self)
    game.removeVisual(jugador.misilCargado())
    game.addVisual(explosion)
    */
    self.mostrar (jugador.misilCargado().position())
    game.removeVisual(self)
    game.removeVisual(jugador.misilCargado()) 
    game.schedule(500, { self.ocultar() })
    
  }
}
