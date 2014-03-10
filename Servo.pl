import math
import SSC32





# La classe Servo permet de décrire chaque Servo en définisant ça position , son nom (facultatif)  et son numero
class Servo(object):
        def __init__(self, conexion, numero, name=None):
            
            self.co = conexion
            self.name = name
            self.no = numero
            self.min = 500
            self._pos = 1500
            self.max = 2500
            self.deg_max = 90.0
            self.deg_min = -90.0
            self.is_changed = True #Permet de voir si il y a eu modification des valeurs .( dans le cas d'un commit) 

        def __repr__(self):
            if self.name is not None:
                name = ' ' +self.name
            else :
                name = ''
            return '<Servo{0}: #{1} pos={2}({5}°) {3}({6}°)..{4}({7}°)>'.format( name, self.no,self._pos, self.min, self.max,self.degree, self.deg_min, self.deg_max)
    
    
        @property
        def position(self):
            return self._pos 
        
        @position.setter
        def position (self,pos):
            pos = int (pos)
           
            if pos > self.max : # Si la position désirée est sup  à la valeur max alors on va à la valeur max.
                pos = self.max 
          
            elif  pos < self.min : # Si la position désirée est inf.  à la valeur min alors on va à la valeur max.
                pos = self.min ;
            
            self.is_changed = True
            self._pos = pos
            self.co._servo_on_changed()
        
        @degree.setter
        def degree(self, deg):
            """
            La position en degree
            """
            deg = float(deg)
            pos = self.min + \
                     (deg - self.deg_min) * (self.max - self.min) \
                    / (abs(self.deg_min) + abs(self.deg_max))
            self.position = pos

        @property
        def radian(self):
            return math.radians(self.degree)

        @radian.setter
        def radian(self, rad):
            """
            Set position in radians
            """
            self.degree = math.degrees(rad)
