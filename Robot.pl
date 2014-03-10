__author__ = 'Ben younes Radhoane'
__email__ = 'Radhoane.ben@gmail.com'

import serial
import math


# SSC32 permet la communication entre la carte ss32 et l'utulisateur. 
class SSC32(object):

    def __init__(self, port, count=5,  autocommit=None):
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
    
    def Position (self,numServo):
        position = 'QP {0} <cr>'.format(numServo) # QP permet de demander à la carte la position du Servo numServo. 
        self.ser.write(position)
        Us = self.read();# On lit la position envoyé en Us . 
        return To_Degrees (Us*10) # *10 voir manuel.
    
    #Fonction permettant de lire la reponse suite à une requete
    
    def lire (self):
        ich = "";
        inp = "";

        while (ich <> '\r'):
                ich = self.ser.read(1);

                if (ich <> '\r'): #tant qu'il n'y pas de marque d'arrêt. On lit
                        inp = inp + ich;
        return inp; # inp est un char  , depend de la demande .
    
    #Cette fonction per
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
            raise KeyError(it) # En cas d'erreur 
        return self._servos[it]

    def __len__(self):
        return len(self._servos) # return le nbr de servos 

   #Permet d'envoyer les commandes 
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


