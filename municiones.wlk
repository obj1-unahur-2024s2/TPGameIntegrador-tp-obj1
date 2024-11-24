import configuraciones.*
import naves.*
import horda.*
import wollok.game.*
import juego.*
// Cualquier objeto que pueda ser impactado por las naves
class Municion{
    const x
    const y
    var property position = game.at(x, y)
    var property puedeMover = true
    method image()
    method initialize(){
        game.addVisual(self)
        game.onTick(200, "avanzar", {self.avanzar()})
        game.onCollideDo(self, {unEnemigo=>self.impactar(unEnemigo)})
    }
    method avanzar(){
        if(self.seSalioDelTablero() or !self.puedeMover()){
            juego.removerEntidad(self)
            game.removeVisual(self)
        }
    }
    method seSalioDelTablero(){
        return (self.position().y() == game.height()) or (self.position().y() == (-1))
    }
    method impactar(unaNave)
    method ocultar(){
        game.removeVisual(self)
        juego.removerEntidad(self)
        puedeMover = false
    }
}

class MisilPropio inherits Municion{
    override method image()="laser.png"
    override method avanzar(){
        super()
        position = position.up(1)
    }
    override method impactar(unEnemigo){
        if (unEnemigo.image() == "naveEnemiga.png"){
            juego.agregarEntidad(new Explosion(x=self.position().x(), y=self.position().y()))
            horda.removerNave(unEnemigo)
            configurarNiveles.terminarSiNoHayMasEnemigos()
            self.ocultar()
        }
    }
}

class MisilEnemigo inherits Municion{
    override method image()="laserEnemigo.png"
    override method avanzar(){
        super()
        position = position.down(1)
    }
    override method impactar(unEnemigo){
        if(unEnemigo.image() == "naveJugador.png"){
            juego.agregarEntidad(new Explosion(x=self.position().x(), y=self.position().y()))
            configurarNiveles.gameOver()
        }
    }
}

// Cajas
class Caja inherits Municion{

}
