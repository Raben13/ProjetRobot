
__author__ = 'Ben younes Radhoane'
__email__ = 'Radhoane.ben@gmail.com'

import serial
import math


# SSC32 permet la communication entre la carte ss32 et l'utulisateur. 
class SSC32(object):

    def __init__(self, port, baudrate, count=5,  autocommit=None):
        self.autocommit = autocommit # Permet de définir la vitesse de rotation d'un Servo
        self.ser = serial.Serial(port, baudrate, timeout=1) # Socket de connexion
        self.ser.write('\r'*10) # On initialise la carte en envoyant 10 fois RetourChar.
        self._servos = [Servo(self, i) for i in xrange(count)] # On associe tous les servos associé à cette connexion.
        
 # On vide le buffer
    #Fermer la connexion
    def close(self):
        self.ser.close()

    #def __del__(self):
    #    self.close()

    #Représentation de la forme format(self.ser.port,self.ser.baudrate)
    def __repr__(self):
        return '<SSC32: {0} {1},8,N,1 >'.format(self.ser.port,self.ser.baudrate)
    
    #
    def write (self,text):
        self.ser.write(text)
    
    def Position (self,numeroMoteur):
        position = 'QP {0} <cr>'.format(numeroMoteur) # Qp permet de demander à la carte la position du Servo. 
        self.ser.write(position)
        Us = self.read();# On lit la position envoyé en Us . 
        return To_Degrees (Us*10) # /10 voir manuel.
        
    def read (self):
        ich = "";
        inp = "";

        while (ich <> '\r'):
                ich = self.ser.read(1);

                if (ich <> '\r'): #tant qu'il n'y pas de marque d'arrêt. On lit
                        inp = inp + ich;
        return inp; # inp est un char ou un int , depend de la demande .
    
    def Enmouvement (self):
        self.ser.flushInput() # On efface le buffer d'entrer.
        self.ser.write('Q\n \r') # Cette commande Q permet de demander à la carte si le robot est en mouvement
        r = self.read()
        return r == '.' # Si true alors le robot est en mouvement . (voir manuel)
    
    # Permet de définir tous les Servos .
    def __getitem__(self, it):
        if type(it) == str or type(it) == unicode:
            for servo in self._servos:
                it = it.upper()
                if servo.name == it:
                    return servo
            raise KeyError(it) # En cas d'erreur .
        return self._servos[it]

    def __len__(self):
        return len(self._servos) # la taille du servos 

    def _servo_on_changed(self):
        if self.autocommit is not None:
            self.commit(self.autocommit)
            
            
    def commit(self, time=None):
        """
        Commit permet d'envoyé la configuaration choisit pour chaque servo.

        De la forme ([#<n>P<pos>]T<time>) avec n le numéro du Servo 
        """
        cmd = ''.join([self._servos[i]._get_cmd_string() for i in xrange(len(self._servos))])
        if time is not None:
            cmd += 'T{0}'.format(time)
        cmd += '\n'
        self.ser.write(cmd)
    
# Converts a  position in degrees to uS for the SSC-32
def To_Degrees (uS):
        result= 0;
   
        result = (uS - 1500) / 10;
   
        return result;

# Converts an SSC-32 servo position in uS to degrees
def To_uS (degrees):
   result = 0;
   
   result = (degrees * 10) + 1500;
   
   return result;

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
