import configuraciones.*
import naves.*
import horda.*
import wollok.game.*
// Cualquier objeto que pueda ser impactado por las naves
class Impactable {
    const x
    const y
    var property position = game.at(x, y)
    method image()
    
    method avanzar(){
        if(self.seSalioDelTablero()){
            juego.removerEntidad(self)
        }
    }
    method seSalioDelTablero(){
        return (self.position().y() == game.height()) or (self.position().y() == (-1))
    }
}

// Misiles
class Misil inherits Impactable{
    override method initialize(){
        game.addVisual(self)
        game.onTick(200, "avanzar", {self.avanzar()})
        game.onCollideDo(self, {unEnemigo=>self.impactar(unEnemigo)})
    }
    method impactar(unaNave)
}

class MisilPropio inherits Misil{
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
        }
    }
}

class MisilEnemigo inherits Misil{
    override method image()="laserEnemigo.png"
    override method avanzar(){
        super()
        position = position.down(1)
    }
    override method impactar(unEnemigo){
        if(unEnemigo.image() == "naveJugador.png")
            juego.agregarEntidad(new Explosion(x=self.position().x(), y=self.position().y()))
            niveles.gameOver()
    }
}

// Cajas
class Caja inherits Impactable{

}
